import * as React from "react";
import { render } from "react-dom";
import TweetEmbed from "react-tweet-embed";
import Card from "@material-ui/core/Card";
import Paper from "@material-ui/core/Paper";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import { ArrowDownward, ArrowUpward } from "@material-ui/icons";
import Button from "@material-ui/core/Button";
import IconButton from "@material-ui/core/IconButton";
// import { dfc } from "../../declarations/dfc";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory as dfc_idl, canisterId as dfc_id } from "dfx-generated/dfc";
import Comment from "./Comment";
import { colorScheme } from "../utils";

const FeedItem = ({ user, feedItem, addNewComment, changeRating }) => {
	const [newComment, setNewComment] = React.useState("");

	return (
		<Paper
			style={{
				margin: 10,
				padding: 10,
				width: 520,
				backgroundColor: colorScheme.secondary,
			}}
			elevation={14}
			variant="outlined"
		>
			<div
				style={{
					width: "100%",
					display: "flex",
					flexDirection: "row",
					justifyContent: "flex-end",
				}}
			>
				<Typography
					variant="body2"
					style={{
						color: colorScheme.textPrimary,
						fontWeight: "bold",
					}}
				>{`Tokens burnt - ${feedItem.content.burntTokens}`}</Typography>
			</div>
			<TweetEmbed
				id={feedItem.content.contentIdentification.postId}
				options={{
					align: "center",
					conversation: "none",
					theme: "dark",
				}}
			/>
			<div>
				{feedItem.comments.map((comment, index) => {
					return (
						<Comment
							user={user}
							comment={comment}
							changeRating={changeRating}
							ratings={feedItem.ratings2d[index]}
							contentId={feedItem.contentId}
						/>
					);
				})}
				<div
					style={{
						display: "flex",
						flexDirection: "column",
						marginTop: 10,
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
						style={{
							width: "100%",
							fontSize: 10,
							marginBottom: 5,
							backgroundColor: "#ffffff",
							borderRadius: 10,
						}}
					/>
					<Button
						variant="contained"
						color="primary"
						style={{
							// backgroundColor: colorScheme.primary,
							color: colorScheme.textPrimary,
						}}
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
		</Paper>
	);
};

export default FeedItem;
