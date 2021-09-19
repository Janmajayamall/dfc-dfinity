import { createSlice } from "@reduxjs/toolkit";

const initialState = {
	DfcData: undefined,
	DfcFeed: undefined,
	DfcUsers: undefined,
};

export const actorsSlice = createSlice({
	name: "actors",
	initialState: initialState,
	reducers: {
		initActorsState: async (state, action) => {
			return (state = {
				...action.payload,
			});
		},
	},
});

// Action creators are generated for each case reducer function
export const { initActorsState } = actorsSlice.actions;
export const selectActors = (state) => state.actors;

export default actorsSlice.reducer;
