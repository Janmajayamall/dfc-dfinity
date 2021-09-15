import * as React from "react";
import { render } from "react-dom";
import TweetEmbed from "react-tweet-embed";
import Card from "@material-ui/core/Card";
import Paper from "@material-ui/core/Paper";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import { ArrowDownward, ArrowUpward } from "@material-ui/icons";
import Button from "@material-ui/core/Button";
import Comment from "./Comment";

const FeedItem = ({ feedItem }) => {
	const [newComment, setNewComment] = React.useState("");

	return (
		<Paper
			style={{
				margin: 10,
				padding: 10,
				width: 520,
				backgroundColor: "#000000",
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
						color: "#ffffff",
						fontWeight: "bold",
					}}
				>{`Tokens burnt - ${feedItem.tokensBurnt}`}</Typography>
			</div>
			<TweetEmbed
				id={feedItem.url.split("/").pop()}
				options={{
					align: "center",
					conversation: "none",
					theme: "dark",
				}}
			/>
			<div>
				{feedItem.comments.map((comment, index) => {
					return <Comment comment={comment} />;
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
							color: "#ffffff",
						}}
						onClick={() => {
							if (newComment === "") {
								return;
							}
							// addNewComment(feedItem.contentId, newComment);
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
