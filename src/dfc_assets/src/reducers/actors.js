import { createSlice } from "@reduxjs/toolkit";
import {
	idlFactory as DFC_DATA_IDL,
	canisterId as DFC_DATA_ID,
} from "dfx-generated/DfcData";
import {
	idlFactory as DFC_FEED_IDL,
	canisterId as DFC_FEED_ID,
} from "dfx-generated/DfcData";
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
			const DfcData = createActor(DFC_DATA_ID, DFC_DATA_IDL, {}, agent);
			const DfcFeed = createActor(DFC_FEED_ID, DFC_FEED_IDL, {}, agent);

			// assign actors to state
			state = {
				DfcData,
				DfcFeed,
			};
		},
	},
});

// Action creators are generated for each case reducer function
export const { initActors } = actorsSlice.actions;
export const selectActors = (state) => state.actors;

export default actorsSlice.reducer;
