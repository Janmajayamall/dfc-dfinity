import { createSlice } from "@reduxjs/toolkit";
import {
	canisterId as dfcDataCanisterId,
	createActor as dfcDataCreateActor,
} from "./../../../declarations/DfcData/index";
import { Actor, HttpAgent } from "@dfinity/agent";

const initialState = {
	DfcData: undefined,
	DfcFeed: undefined,
};

function createActor(canisterId, idlFactory, options, agent) {
	return Actor.createActor(idlFactory, {
		agent,
		canisterId,
		...options,
	});
}

export const actorsSlice = createSlice({
	name: "actors",
	initialState: initialState,
	reducers: {
		initActors: (state, action) => {
			const { identity } = action.payload;
			const agent = new HttpAgent();
			// create actors
			const DfcData = dfcDataCreateActor(dfcDataCanisterId);
			// const DfcFeed = createActor(DFC_FEED_ID, DFC_FEED_IDL, {}, agent);

			// assign actors to state
			state = {
				DfcData,
			};
		},
	},
});

// Action creators are generated for each case reducer function
export const { initActors } = actorsSlice.actions;
export const selectActors = (state) => state.actors;

export default actorsSlice.reducer;
