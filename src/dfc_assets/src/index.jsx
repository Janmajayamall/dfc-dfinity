import * as React from "react";
import { render } from "react-dom";
import TweetEmbed from "react-tweet-embed";
import Card from "@material-ui/core/Card";
import Paper from "@material-ui/core/Paper";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import { ArrowDownward, ArrowUpward } from "@material-ui/icons";
import Button from "@material-ui/core/Button";
// import { dfc } from "../../declarations/dfc";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory as dfc_idl, canisterId as dfc_id } from "dfx-generated/dfc";

const agent = new HttpAgent();
const dfc = Actor.createActor(dfc_idl, { agent, canisterId: dfc_id });

const dummyFeed = [
	{
		comments: [
			{
				id: "0",
				contentId: "0",
				createdAt: 1627592149940225000n,
				text: "this is the comment",
				user: { username: "newUser1" },
			},
		],
		content: {
			contentIdentification: {
				postId: "1410462056495542277",
				site: { twitter: null },
			},
			createdAt: 1627592144734283000n,
			id: "1",
		},
		user: { username: "newUser" },
		contentId: "1",
		ratings2d: [
			[
				{
					id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
					commentId: "0",
					ratingValue: true,
					user: { username: "dawda" },
				},
			],
		],
	},
	{
		comments: [
			{
				id: "0",
				contentId: "0",
				createdAt: 1627592149940225000n,
				text: "this is the comment",
				user: { username: "newUser2" },
			},
		],
		content: {
			contentIdentification: {
				postId: "1410462056495542277",
				site: { twitter: null },
			},
			createdAt: 1627592144734283000n,
			id: "1",
		},
		user: { username: "newUser3" },
		contentId: "1",
		ratings2d: [
			[
				{
					id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
					commentId: "0",
					ratingValue: false,
					user: { username: "dawda" },
				},
			],
		],
	},
];

const FeedItem = ({ user, feedItem, addNewComment }) => {
	const [newComment, setNewComment] = React.useState("");

	return (
		<Card style={{ padding: 10, maxWidth: 520 }}>
			<TweetEmbed
				id={feedItem.content.contentIdentification.postId}
				options={{ align: "center" }}
			/>
			<div>
				{feedItem.comments.map((comment) => {
					return <Comment user={user} comment={comment} />;
				})}
				<div
					style={{
						display: "flex",
						flexDirection: "column",
					}}
				>
					<TextField
						multiline
						InputProps={{ disableUnderline: true }}
						placeholder="Your Comment!"
						variant="filled"
						onChange={(e) => {
							setNewComment(e.target.value);
						}}
						value={newComment}
						style={{ width: "100%", fontSize: 16 }}
					/>
					<Button
						variant="contained"
						color="primary"
						onClick={() => {
							if (newComment === "") {
								return;
							}
							addNewComment(feedItem.contentId, newComment);
							setNewComment("");
						}}
					>
						Post
					</Button>
				</div>
			</div>
		</Card>
	);
};

const Comment = ({ user, comment, ratings }) => {
	const [upRates, setUpRates] = React.useState(0);
	const [downRates, setDownRates] = React.useState(0);
	const [userRate, setUserRate] = React.useState(null); // null = no rate, true = up rate, false = down rate

	React.useEffect(() => {
		ratings.forEach(function (rating) {
			if (rating.user.id === user.id) {
				setUserRate(rating.user.ratingValue);
			}
		});
	}, []);

	function changeRatingHelper(rating) {
		if (rating === userRate) {
			return;
		}
	}

	return (
		<Paper
			elevation={0}
			style={{
				display: "flex",
				flexDirection: "row",
			}}
		>
			<div
				style={{
					display: "flex",
					flexDirection: "column",
				}}
			>
				<div
					style={{
						display: "flex",
						flexDirection: "column",
						justContent: "center",
					}}
				>
					<ArrowUpward color="primary" />
					<Typography variant="body2">10</Typography>
				</div>
				<div
					style={{
						display: "flex",
						flexDirection: "column",
					}}
				>
					<Typography variant="body2">10</Typography>
					<ArrowDownward color="primary" />
				</div>
			</div>
			<div
				style={{
					display: "flex",
					flexDirection: "column",
				}}
			>
				<Typography variant="body2">{comment.user.username}</Typography>
				<Typography variant="body2">{comment.text}</Typography>
			</div>
		</Paper>
	);
};

const App = () => {
	const [feed, setFeed] = React.useState([]);
	const [user, setUser] = React.useState({
		id: "1212",
		username: "this is username",
	});

	React.useEffect(() => {
		getFeed();
	}, []);

	async function getFeed() {
		try {
			let feed = await dfc.getFeed();
			console.log(feed);
			setFeed(feed);
		} catch (e) {
			setFeed(dummyFeed);
			console.log(e);
		}
	}

	function addNewComment(contentId, commentText) {
		let updatedFeed = [];
		feed.forEach(function (feedItem) {
			if (feedItem.contentId === contentId) {
				let comments = [
					...feedItem.comments,
					{
						id: "100000000",
						contentId: contentId,
						createdAt: 1627592149940225000n,
						text: commentText,
						user: { username: "newUser1" },
					},
				];
				updatedFeed.push({
					...feedItem,
					comments: comments,
				});
			} else {
				updatedFeed.push(feedItem);
			}
		});
		console.log(updatedFeed, "comments updated");
		setFeed(updatedFeed);
	}

	function changeRating(contentId, commentId, rating) {
		let updatedFeed = [];
		feed.forEach(function (feedItem) {
			if (feedItem.contentId === contentId) {
				let comments = [];
				let ratings2d = [];
				feedItem.comments.forEach(function (comment, index) {
					if (comment.id === commentId) {
						// check user's existing rating
						let existingRating = comment.ratings2d[index].find(
							(rating) => {
								return rating.user.id === user.id;
							}
						);

						// if existing rating matches incoming rating, then return
						if (existingRating === rating) {
							return;
						}

						var ratings = [];
						if (existingRating == undefined) {
							// rating did not exists, thus add new one
							ratings = [
								...comment.ratings2d[index],
								{
									id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
									commentId: "0",
									ratingValue: rating,
									user: { username: "dawda" },
								},
							];
						} else {
							// rating exists, flip it
							comment.ratings2d[index].forEach((val) => {
								if (val.user.id === user.id) {
									ratings.push({
										...val,
										ratingValue: rating,
									});
								} else {
									ratings.push(val);
								}
							});
						}

						// finish
						ratings2d.push(ratings);
					} else {
						ratings2d.push(comment.ratings2d);
					}
					comments.push(comment);
				});
				updatedFeed.push({
					...feed,
					comments: comments,
				});
			} else {
				updatedFeed.push(feedItem);
			}
		});
	}

	return (
		<div style={{ fontSize: "30px" }}>
			<div style={{ backgroundColor: "black" }}>
				<div>
					{feed.map((feedItem) => (
						<FeedItem
							user={user}
							feedItem={feedItem}
							addNewComment={addNewComment}
						/>
					))}
				</div>
			</div>
		</div>
	);
};

render(<App />, document.getElementById("app"));

// document.getElementById("clickMeBtn").addEventListener("click", async () => {
// 	const name = document.getElementById("name").value.toString();
// 	const greeting = await dfc.greet(name);

// 	document.getElementById("greeting").innerText = greeting;
// });
