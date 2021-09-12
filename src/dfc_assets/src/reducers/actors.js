import { createSlice } from "@reduxjs/toolkit";
import {
	canisterId as dfcDataCanisterId,
	createActor as dfcDataCreateActor,
} from "./../../../declarations/DfcData/index";

const initialState = {
	DfcData: undefined,
	DfcFeed: undefined,
};

export const actorsSlice = createSlice({
	name: "actors",
	initialState: initialState,
	reducers: {
		initActors: (state, action) => {
			const { identity } = action.payload;
			// create actors
			const DfcData = dfcDataCreateActor(dfcDataCanisterId, {
				agentOptions: {
					identity: identity,
				},
			});
			// const DfcFeed = createActor(DFC_FEED_ID, DFC_FEED_IDL, {}, agent);

			// assign actors to state
			return (state = {
				DfcData,
			});
		},
	},
});

// Action creators are generated for each case reducer function
export const { initActors } = actorsSlice.actions;
export const selectActors = (state) => state.actors;

export default actorsSlice.reducer;
