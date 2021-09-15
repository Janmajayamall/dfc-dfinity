import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import MenuIcon from "@material-ui/icons/Menu";

const useStyles = makeStyles((theme) => ({
	root: {
		flexGrow: 1,
	},
	menuButton: {
		marginRight: theme.spacing(2),
	},
}));

export default function TopBar({ authState, login }) {
	const classes = useStyles();

	return (
		<div style={{ flexGrow: 1 }}>
			<AppBar position="static">
				<Toolbar>
					<div
						style={{
							display: "flex",
							flexDirection: "row",
							justifyContent: "flex-end",
							width: "100%",
						}}
					>
						{/* <Typography variant="h6" color="inherit">
							Photos
						</Typography> */}
						{authState.isAuthenticated == true ? (
							<IconButton
								edge="end"
								className={classes.menuButton}
								color="inherit"
								aria-label="menu"
							>
								<MenuIcon />
							</IconButton>
						) : (
							<Typography
								onClick={login}
								variant="h6"
								color="inherit"
							>
								Login
							</Typography>
						)}
					</div>
				</Toolbar>
			</AppBar>
		</div>
	);
}
