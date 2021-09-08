// import * as React from "react";
// import Modal from "@material-ui/core/Modal";
// import Backdrop from "@material-ui/core/Backdrop";
// import Fade from "@material-ui/core/Fade";
// import Card from "@material-ui/core/Card";
// import Typography from "@material-ui/core/Typography";
// import TextField from "@material-ui/core/TextField";
// import { colorScheme } from "../utils";
// import Button from "@material-ui/core/Button";

// export const NewContentModal = ({
// 	user,
// 	open,
// 	handleClose,
// 	flagNewContent,
// }) => {
// 	const [contentUrl, setContentUrl] = React.useState("");
// 	const [numberOfTokens, setNumberOfTokens] = React.useState("");

// 	return (
// 		<Modal
// 			aria-labelledby="transition-modal-title"
// 			aria-describedby="transition-modal-description"
// 			style={{
// 				display: "flex",
// 				alignItems: "center",
// 				justifyContent: "center",
// 			}}
// 			open={open}
// 			onClose={handleClose}
// 			closeAfterTransition
// 			BackdropComponent={Backdrop}
// 			BackdropProps={{
// 				timeout: 500,
// 			}}
// 		>
// 			<Fade in={open}>
// 				<Card
// 					style={{
// 						backgroundColor: colorScheme.secondary,
// 						display: "flex",
// 						flexDirection: "column",
// 						padding: 10,
// 						width: 512,
// 					}}
// 				>
// 					<Typography
// 						variant="body1"
// 						style={{
// 							color: colorScheme.textPrimary,
// 							fontWeight: "bold",
// 							marginBottom: 10,
// 						}}
// 					>
// 						{"Flag new content"}
// 					</Typography>
// 					<TextField
// 						multiline
// 						InputProps={{ disableUnderline: true }}
// 						placeholder="Content URL"
// 						variant="filled"
// 						onChange={(e) => {
// 							setContentUrl(e.target.value);
// 						}}
// 						value={contentUrl}
// 						style={{
// 							width: "100%",
// 							fontSize: 10,
// 							marginBottom: 5,
// 							backgroundColor: "#ffffff",
// 							borderRadius: 10,
// 						}}
// 					/>
// 					<TextField
// 						multiline
// 						InputProps={{ disableUnderline: true }}
// 						placeholder="Tokens to burn"
// 						variant="filled"
// 						onChange={(e) => {
// 							setNumberOfTokens(e.target.value);
// 						}}
// 						value={numberOfTokens}
// 						style={{
// 							width: "100%",
// 							fontSize: 10,
// 							marginBottom: 5,
// 							backgroundColor: "#ffffff",
// 							borderRadius: 10,
// 						}}
// 					/>
// 					<Button
// 						variant="contained"
// 						color="primary"
// 						style={{
// 							// backgroundColor: colorScheme.primary,
// 							color: colorScheme.textPrimary,
// 							margin: 10,
// 						}}
// 						onClick={() => {
// 							flagNewContent(contentUrl, numberOfTokens);
// 							handleClose();
// 						}}
// 					>
// 						Flag content
// 					</Button>
// 				</Card>
// 			</Fade>
// 		</Modal>
// 	);
// };
