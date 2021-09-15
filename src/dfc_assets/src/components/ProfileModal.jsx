import * as React from "react";
import Modal from "@material-ui/core/Modal";
import Backdrop from "@material-ui/core/Backdrop";
import Fade from "@material-ui/core/Fade";
import Card from "@material-ui/core/Card";
import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";

export const ProfileModal = ({ user, open, handleClose }) => {
	function TitleDetailRow({ title, detail }) {
		return (
			<div style={{ display: "flex", flexDirection: "row", margin: 10 }}>
				<Typography
					variant="body1"
					style={{
						color: colorScheme.textPrimary,
						fontWeight: "bold",
						marginRight: 5,
					}}
				>
					{`${title}:`}
				</Typography>
				<Typography
					variant="body1"
					style={{ color: colorScheme.textPrimary }}
				>
					{detail}
				</Typography>
			</div>
		);
	}

	return (
		<Modal
			aria-labelledby="transition-modal-title"
			aria-describedby="transition-modal-description"
			style={{
				display: "flex",
				alignItems: "center",
				justifyContent: "center",
				padding: 10,
			}}
			open={open}
			onClose={handleClose}
			closeAfterTransition
			BackdropComponent={Backdrop}
			BackdropProps={{
				timeout: 500,
			}}
		>
			<Fade in={open}>
				<Card
					style={{
						backgroundColor: colorScheme.secondary,
						display: "flex",
						flexDirection: "column",
					}}
				>
					<TitleDetailRow
						title={"Username"}
						detail={user ? user.username : ""}
					/>
					<TitleDetailRow
						title={"Reputation score"}
						detail={"1034"}
					/>
					<TitleDetailRow
						title={"Total coin rewards"}
						detail={"500"}
					/>
					<Button
						variant="contained"
						color="primary"
						style={{
							// backgroundColor: colorScheme.primary,
							color: colorScheme.textPrimary,
							margin: 10,
						}}
						onClick={handleClose}
					>
						Go Back
					</Button>
				</Card>
			</Fade>
		</Modal>
	);
};
