import * as React from "react";
import { useDispatch, useSelector } from "react-redux";
import { actorsSlice, selectActors } from "../reducers/actors";
import { getAllFeed } from "../utils/index";

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

	return <div>{}</div>;
};

export default Page;
