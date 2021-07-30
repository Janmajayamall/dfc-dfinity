import * as React from "react";
import Modal from "@material-ui/core/Modal";
import Backdrop from "@material-ui/core/Backdrop";
import Fade from "@material-ui/core/Fade";

export const ProfileModal = ({ user, open, handleClose }) => {
	return (
		<Modal
			aria-labelledby="transition-modal-title"
			aria-describedby="transition-modal-description"
			style={{
				display: "flex",
				alignItems: "center",
				justifyContent: "center",
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
				<div style={{ backgroundColor: "#ffffff" }}>
					<h2 id="transition-modal-title">Transition modal</h2>
					<p id="transition-modal-description">
						react-transition-group animates me.
					</p>
				</div>
			</Fade>
		</Modal>
	);
};