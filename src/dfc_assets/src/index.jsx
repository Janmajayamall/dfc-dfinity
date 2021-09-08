import * as React from "react";
import { render } from "react-dom";
import FeedItem from "./components/FeedItem";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import { ProfileModal } from "./components/ProfileModal";
import IconButton from "@material-ui/core/IconButton";
import PersonIcon from "@material-ui/icons/Person";
import AddIcon from "@material-ui/icons/Add";
import Fab from "@material-ui/core/Fab";
import { NewContentModal } from "./components/NewContentModal";
import { colorScheme } from "./utils";
import store from "./store";
import { Provider, useSelector, useDispatch } from "react-redux";
import { selectScreen, changeScreen, SCREEN_SELECTOR } from "./reducers/screen";
import FeedScreen from "./pages/FeedScreen";

const Page = () => {
	const screen = useSelector(selectScreen);
	const dispatch = useDispatch();
	console.log(screen);

	if (screen === SCREEN_SELECTOR.main) {
		return <FeedScreen />;
	}

	return <div />;
};

const Feed = () => {
	const [feed, setFeed] = React.useState([]);
	const [user, setUser] = React.useState({ id: "", username: "" });
	const [toggleUpdate, setToggleUpdate] = React.useState(true);
	const [profileModalState, setProfileModalState] = React.useState(false);
	const [newContentModalState, setNewContentModalState] =
		React.useState(false);

	React.useEffect(async () => {
		const user = await lookupUser();
		setUser(user);

		const feed = await getFeed();
		setFeed(feed);
	}, []);

	async function addNewComment(contentId, commentText) {
		// handle optimistic update
		let fakeId = "100000000";
		handleAddNewComment(
			contentId,
			{
				id: fakeId,
				contentId: contentId,
				createdAt: new Date().getTime(),
				text: commentText,
				user: { username: "justBeingHelpful" },
			},
			true
		);

		// canister call
		try {
			const addedComment = await addComment(contentId, commentText);

			// undo optimistic update
			handleAddNewComment(addedComment, false);
		} catch (e) {
			console.log(e);
		}
	}

	async function handleAddNewComment(
		contentId,
		newCommentObj,
		optimisticUpdate
	) {
		let fakeId = "100000000";
		let updatedFeed = [];
		feed.forEach(function (feedItem) {
			if (feedItem.contentId === contentId) {
				// handle comment updated
				let comments = [];
				if (optimisticUpdate === true) {
					comments = [...feedItem.comments, newCommentObj];
				} else {
					let oldComments = feedItem.comments.filter((comment) => {
						return comment.id !== fakeId;
					});
					comments = [...oldComments, newCommentObj];
				}

				let updatedFeedItem = {
					...feedItem,
					comments: comments,
				};

				// handle rating2d update
				if (optimisticUpdate === true) {
					updatedFeedItem = {
						...updatedFeedItem,
						ratings2d: [...feedItem.ratings2d, []],
					};
				}

				updatedFeed.push(updatedFeedItem);
			} else {
				updatedFeed.push(feedItem);
			}
		});
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
						var newRatings = feedItem.ratings2d[index].filter(
							(rating) => rating.user.id !== user.id
						);

						newRatings.push({
							id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
							commentId: commentId,
							ratingValue: rating,
							user: {
								id: user.id,
								username: user.username,
							},
						});

						ratings2d.push(newRatings);
					} else {
						ratings2d.push(feedItem.ratings2d[index]);
					}
					comments.push(comment);
				});
				updatedFeed.push({
					...feedItem,
					comments: comments,
					ratings2d: ratings2d,
				});
			} else {
				updatedFeed.push(feedItem);
			}
		});
		setFeed(updatedFeed);
		setToggleUpdate(!toggleUpdate);
	}

	async function flagNewContent(contentUrl, tokens) {
		//post id
		let postId = contentUrl.split("/").pop();

		// handle optimistic update
		let fakeContentId = "10000000";
		handleFlagNewContent(
			{
				id: fakeContentId,
				contentIdentification: {
					postId: postId,
				},
				createdAt: new Date().getTime(),
				user: user,
				burntTokens: Number(tokens),
			},
			true
		);

		// canister call
		try {
			const newFlaggedContent = await flagContent(postId, Number(tokens));
			handleFlagNewContent(newFlaggedContent, false);
		} catch (e) {
			console.log(e);
		}
	}

	async function handleFlagNewContent(contentObject, optimisticUpdate) {
		if (optimisticUpdate === true) {
			let updatedFeed = [
				{
					contentId: contentObject.id,
					content: contentObject,
					comments: [],
					ratings2d: [[]],
				},
				...feed,
			];
			setFeed(updatedFeed);
		} else {
			var updatedFeed = feed.filter((content) => {
				return (
					content.contentIdentification.postId !==
					contentObject.contentIdentification.postId
				);
			});
			updatedFeed = [
				{
					contentId: contentObject.id,
					content: contentObject,
					comments: [],
					ratings2d: [[]],
				},
				...updatedFeed,
			];
			setFeed(updatedFeed);
		}
	}

	function toggleProfileModal() {
		setProfileModalState(!profileModalState);
	}

	function toggleNewContentModal() {
		setNewContentModalState(!newContentModalState);
	}

	return (
		<div style={{ flex: 1, backgroundColor: colorScheme.primary }}>
			<AppBar position="static">
				<Toolbar
					style={{
						display: "flex",
						justifyContent: "flex-end",
					}}
				>
					<IconButton
						onClick={() => {
							toggleProfileModal();
						}}
					>
						<PersonIcon
							style={{ color: colorScheme.textPrimary }}
						/>
					</IconButton>
				</Toolbar>
			</AppBar>
			<div
				style={{
					display: "flex",
					flexDirection: "column",
					alignItems: "center",
					width: "100%",
				}}
			>
				{feed.map((feedItem) => (
					<FeedItem
						user={user}
						feedItem={feedItem}
						addNewComment={addNewComment}
						changeRating={changeRating}
					/>
				))}
			</div>
			<Fab
				style={{
					position: "fixed",
					bottom: 10,
					right: 10,
				}}
				color="primary"
				aria-label="add"
				onClick={() => {
					toggleNewContentModal();
				}}
			>
				<AddIcon />
			</Fab>
			<ProfileModal
				user={user}
				open={profileModalState}
				handleClose={toggleProfileModal}
			/>
			<NewContentModal
				user={user}
				open={newContentModalState}
				handleClose={toggleNewContentModal}
				flagNewContent={flagNewContent}
			/>
		</div>
	);
};

const App = () => {
	return (
		<Provider store={store}>
			<Page />
		</Provider>
	);
};

render(<App />, document.getElementById("app"));

// document.getElementById("clickMeBtn").addEventListener("click", async () => {
// 	const name = document.getElementById("name").value.toString();
// 	const greeting = await dfc.greet(name);

// 	document.getElementById("greeting").innerText = greeting;
// });

// Work to do
// 1. Setup react router
// 2. Setup react state
// setup interaction with backend
// 3. UI for 2 different feeds
// 4. Pop up for flagging new content
// 5. Page for leadership board
// 6. Page for individual's past scores
// 7. Profile page
