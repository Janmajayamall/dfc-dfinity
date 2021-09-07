import { createSlice } from "@reduxjs/toolkit";

export const commentsSlice = createSlice({
	name: "contents",
	initialState: {
		value: [],
	},
	reducers: {
		addContent: (state) => {
			// Redux Toolkit allows us to write "mutating" logic in reducers. It
			// doesn't actually mutate the state because it uses the Immer library,
			// which detects changes to a "draft state" and produces a brand new
			// immutable state based off those changes
		},
		addCommentToContent: (state, action) => {
			const { contentId, commentId } = action.payload;
			// THE REST
		},
		toggleComment: (state, action) => {
			const { contentId, commentId } = action.payload;
			// toggle rating
		},
	},
});

// Action creators are generated for each case reducer function
export const actions = commentsSlice.actions;

export default commentsSlice.reducer;
