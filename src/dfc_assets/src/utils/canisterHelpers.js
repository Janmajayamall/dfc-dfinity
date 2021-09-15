// function related to DFC data
export async function flagNewContent(DfcData, args) {
	const { url, tokensBurnt } = args;
	let content = await DfcData.flagNewContent(url, tokensBurnt);
	return content;
}

export async function getContentDetailsInBatch(DfcData, contentIds) {
	let contents = await DfcData.getContentDetailsInBatch(contentIds);
	return contents;
}

// functions related to DfcFeed
export async function getNeedsHelpFeedContentIds(DfcFeed) {
	let ids = await DfcFeed.getNeedsHelpFeedContentIds();
	return ids;
}

export async function getSatisfiedFeedContentIds(DfcFeed) {
	let ids = await DfcFeed.getSatisfiedFeedContentIds();
	return ids;
}

export async function getAllFeedIds(DfcFeed) {
	let feedIds = {
		needsHelpFeedIds: await getNeedsHelpFeedContentIds(DfcFeed),
		satisfiedFeedIds: await getSatisfiedFeedContentIds(DfcFeed),
	};
	return feedIds;
}

export async function getAllFeed(DfcData, DfcFeed) {
	let feedIds = await getAllFeedIds(DfcFeed);
	let feed = {
		needsHelpFeed: await getContentDetailsInBatch(
			DfcData,
			feedIds.needsHelpFeedIds
		),
		satisfiedFeed: await getContentDetailsInBatch(
			DfcData,
			feedIds.satisfiedFeedIds
		),
	};
	return feed;
}

export async function getUserProfile(DfcUsers, userId) {
	try {
		let profile = await DfcUsers.getUserProfile(userId);
		return profile;
	} catch (e) {
		return undefined;
	}
}
