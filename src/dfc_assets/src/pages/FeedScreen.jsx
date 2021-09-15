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
import FeedItem from "../components/FeedItem";
import {
	selectNeedsHelpFeed,
	selectSatisfiedFeed,
	setFeeds,
} from "../reducers/feeds";

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

	let data = value === 0 ? contents.needsHelpFeed : contents.satisfiedFeed;

	return (
		<div
			role="tabpanel"
			hidden={value !== index}
			id={`simple-tabpanel-${index}`}
			aria-labelledby={`simple-tab-${index}`}
			{...other}
			style={{
				width: "100%",
				justifyContent: "center",
				alignItems: "center",
				display: "flex",
				flexDirection: "column",
			}}
		>
			{data.map((content) => (
				<FeedItem feedItem={content} />
			))}
			{data.length === 0 ? <div>No data</div> : undefined}
		</div>
	);
};

const Page = () => {
	const actors = useSelector(selectActors);
	const needsHelpFeed = useSelector(selectNeedsHelpFeed);
	const satisfiedFeed = useSelector(selectSatisfiedFeed);
	const dispatch = useDispatch();
	React.useEffect(async () => {
		const { DfcData, DfcFeed } = await actors;
		if (DfcData && DfcFeed) {
			let { needsHelpFeed, satisfiedFeed } = await getAllFeed(
				DfcData,
				DfcFeed
			);
			console.log(needsHelpFeed, satisfiedFeed);
			dispatch(setFeeds({ needsHelpFeed, satisfiedFeed }));
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
					<Tab label="Needs Help" {...a11yProps(0)} />
					<Tab label="Satisfied" {...a11yProps(1)} />
				</Tabs>
			</AppBar>
			{/* pass in contents as array */}
			<TabPanel
				value={value}
				contents={{ needsHelpFeed, satisfiedFeed }}
			/>
			{/* <TabPanel
				value={value}
				index={1}
				contents={{ needsHelpFeed, satisfiedFeed }}
			/> */}
		</div>
	);
};

export default Page;
