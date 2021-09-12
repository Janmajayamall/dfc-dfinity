import * as React from "react";
import { useDispatch, useSelector } from "react-redux";
import { actorsSlice, selectActors } from "../reducers/actors";
import { getAllFeed } from "../utils/index";
import { makeStyles } from "@material-ui/core/styles";
import AppBar from "@material-ui/core/AppBar";
import Tabs from "@material-ui/core/Tabs";
import Tab from "@material-ui/core/Tab";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";

function a11yProps(index) {
	return {
		id: `simple-tab-${index}`,
		"aria-controls": `simple-tabpanel-${index}`,
	};
}

const useStyles = makeStyles((theme) => ({
	root: {
		flexGrow: 1,
		backgroundColor: theme.palette.background.paper,
	},
}));

const TabPanel = (props) => {
	const { children, value, index, contents, ...other } = props;

	return (
		<div
			role="tabpanel"
			hidden={value !== index}
			id={`simple-tabpanel-${index}`}
			aria-labelledby={`simple-tab-${index}`}
			{...other}
		>
			{value === index && (
				<Box p={3}>
					<Typography>THIS IS HERE</Typography>
				</Box>
			)}
		</div>
	);
};

const Page = () => {
	const actors = useSelector(selectActors);
	const dispatch = useDispatch();
	const [feed, setFeed] = React.useState({
		needsHelpFeed: [],
		satisfiedFeed: [],
	});

	React.useEffect(async () => {
		console.log("this ran");
		if (actors.DfcData && actors.DfcFeed) {
			let feed = await getAllFeed(actors.DfcData, actors.DfcFeed);
			console.log("got the feed");
			setFeed(feed);
		}
	}, [actors]);

	const classes = useStyles();
	const [value, setValue] = React.useState(0);

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
	};

	return (
		<div className={classes.root}>
			<AppBar position="static">
				<Tabs
					value={value}
					onChange={handleTabChange}
					aria-label="simple tabs example"
				>
					<Tab label="Item One" {...a11yProps(0)} />
					<Tab label="Item Two" {...a11yProps(1)} />
				</Tabs>
			</AppBar>
			{/* pass in contents as array */}
			<TabPanel value={value} index={0} contents={[]} />
			<TabPanel value={value} index={1} contents={[]} />
		</div>
	);
};

export default Page;
