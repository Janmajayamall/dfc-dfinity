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
import Divider from "@material-ui/core/Divider";
import { colorScheme } from "../utils";

const Comment = ({ user, contentId, comment, ratings, changeRating }) => {
	let upRates = [];
	let downRates = [];
	let userRating = null; // null = no rate, true = up rate, false = down rate

	function setRatings() {
		// check user rating
		userRating = ratings.find((rating) => rating.user.id === user.id);

		// up ratings
		let upRatesL = [];
		// down ratings
		let downRatesL = [];
		ratings.forEach(function (rating) {
			if (rating.ratingValue === true) {
				upRates.push(rating);
			} else if (rating.ratingValue === false) {
				downRates.push(rating);
			}
		});
		upRates = upRatesL;
		downRates = downRatesL;
	}

	function getUserRating() {
		// null = no rate, true = up rate, false = down rate
		let userRating = ratings.find((rating) => rating.user.id === user.id);
		return userRating ? userRating.ratingValue : null;
	}

	function getRatesFor(ratingValue) {
		let rates = ratings.filter(
			(rating) => rating.ratingValue === ratingValue
		);
		return rates;
	}

	setRatings();

	const Rating = ({ ratingFor }) => {
		return (
			<div>
				{ratingFor ? (
					<IconButton
						onClick={() => {
							changeRating(contentId, comment.id, true);
						}}
					>
						<div
							style={{
								display: "flex",
								flexDirection: "column",
								justContent: "center",
							}}
						>
							<ArrowUpward
								style={{
									color:
										getUserRating() === true
											? colorScheme.red
											: colorScheme.darkGrey,
								}}
							/>
							<Typography
								variant="body2"
								style={{ color: colorScheme.textPrimary }}
							>
								{getRatesFor(ratingFor).length}
							</Typography>
						</div>
					</IconButton>
				) : (
					<IconButton
						onClick={() => {
							changeRating(contentId, comment.id, false);
						}}
					>
						<div
							style={{
								display: "flex",
								flexDirection: "column",
								justContent: "center",
							}}
						>
							<Typography
								variant="body2"
								style={{ color: colorScheme.textPrimary }}
							>
								{getRatesFor(ratingFor).length}
							</Typography>
							<ArrowDownward
								style={{
									color:
										getUserRating() === false
											? colorScheme.red
											: colorScheme.darkGrey,
								}}
							/>
						</div>
					</IconButton>
				)}
			</div>
		);
	};

	return (
		<Paper
			elevation={0}
			style={{
				display: "flex",
				flexDirection: "row",
				backgroundColor: colorScheme.secondary,
			}}
		>
			<div
				style={{
					display: "flex",
					flexDirection: "column",
				}}
			>
				<Rating ratingFor={true} />
				<Rating ratingFor={false} />
			</div>
			<div
				style={{
					display: "flex",
					flexDirection: "column",
					marginTop: 8,
				}}
			>
				<Typography
					variant="body2"
					style={{
						fontWeight: "bold",
						color: colorScheme.textPrimary,
					}}
				>
					{comment.user.username}
				</Typography>
				<Typography
					variant="body2"
					style={{ color: colorScheme.textPrimary }}
				>
					{comment.text}
				</Typography>
			</div>
		</Paper>
	);
};

export default Comment;
