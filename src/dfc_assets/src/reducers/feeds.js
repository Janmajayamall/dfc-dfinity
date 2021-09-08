import { createSlice } from "@reduxjs/toolkit";

const defaultFeedState = {
	contents: [],
};

const initialState = {
	needsHelpFeed: defaultFeedState,
	satisfiedFeed: defaultFeedState,
};

const FEED_SELECTOR = {
	needsHelpFeed: "NEEDS_HELP_FEED",
	satisfiedFeed: "SATISFIED_FEED",
};

function _addContent(feed, newContent) {
	let newFeed = {
		...feed,
		contents: [newContent, ...feed.contents],
	};
	return newFeed;
}
function addComment(content, comment) {
	let newContent = {
		...content,
		comments: [...content.comments, comment],
	};
	return newContent;
}

function findContentByIdInFeed(feed, contentId) {
	return feed.contents.find((obj) => obj.id === contentId);
}

function updateInFeedContent(feed, contentId, update) {
	let updatedContentArray = [];
	feed.contents.forEach((obj) => {
		if (obj.id === contentId) {
			let newContent = {
				...obj,
				...update,
			};
			updatedContentArray.push(newContent);
		} else {
			updatedContentArray.push(obj);
		}
	});
	return updatedContentArray;
}

export const feedsSlice = createSlice({
	name: "feeds",
	initialState: initialState,
	reducers: {
		addContent: (state, action) => {
			// Redux Toolkit allows us to write "mutating" logic in reducers. It
			// doesn't actually mutate the state because it uses the Immer library,
			// which detects changes to a "draft state" and produces a brand new
			// immutable state based off those changes
			const { contentObj, feedType } = action.payload;
			if (feedType === FEED_SELECTOR.needsHelpFeed) {
				state.needsHelpFeed = _addContent(
					state.needsHelpFeed,
					contentObj
				);
			} else if (feedType === FEED_SELECTOR.satisfiedFeed) {
				state.satisfiedFeed = addContent(
					state.satisfiedFeed,
					contentObj
				);
			}
		},
		addCommentToContent: (state, action) => {
			const { contentId, commentObj } = action.payload;
			let updatedNeedsHelpFeed = updateInFeedContent(
				state.needsHelpFeed,
				contentId,
				commentObj
			);
			let updatedSatisfiedFeed = updateInFeedContent(
				state.satisfiedFeed,
				contentId,
				commentObj
			);
			state.needsHelpFeed = updatedNeedsHelpFeed;
			state.satisfiedFeed = updatedSatisfiedFeed;
		},
	},
});

// Action creators are generated for each case reducer function
export const { addContent, addCommentToContent } = feedsSlice.actions;
export const selectNeedsHelpFeed = (state) => state.needsHelpFeed;
export const selectSatisfiedFeed = (state) => state.satisfiedFeed;

export default feedsSlice.reducer;
