import { createSlice } from "@reduxjs/toolkit";
import {
	canisterId as dfcDataCanisterId,
	createActor as dfcDataCreateActor,
} from "./../../../declarations/DfcData/index";
import {
	canisterId as dfcFeedCanisterId,
	createActor as dfcFeedCreateActor,
} from "./../../../declarations/DfcFeed/index";
import {
	canisterId as dfcUsersCanisterId,
	createActor as dfcUsersCreateActor,
} from "./../../../declarations/DfcUsers/index";

const initialState = {
	DfcData: undefined,
	DfcFeed: undefined,
	DfcUsers: undefined,
};

export const actorsSlice = createSlice({
	name: "actors",
	initialState: initialState,
	reducers: {
		initActors: async (state, action) => {
			const { identity } = action.payload;
			const agentOptions =
				identity != undefined
					? {
							identity: identity,
					  }
					: {};
			// create actors
			const DfcData = dfcDataCreateActor(dfcDataCanisterId, {
				agentOptions: agentOptions,
			});
			const DfcFeed = dfcFeedCreateActor(dfcFeedCanisterId, {
				agentOptions: agentOptions,
			});
			const DfcUsers = dfcUsersCreateActor(dfcUsersCanisterId, {
				agentOptions: agentOptions,
			});

			// assign actors to state
			return (state = {
				DfcData,
				DfcFeed,
				DfcUsers,
			});
		},
	},
});

// Action creators are generated for each case reducer function
export const { initActors } = actorsSlice.actions;
export const selectActors = (state) => state.actors;

export default actorsSlice.reducer;
