import { createSlice } from "@reduxjs/toolkit";

const defaultState = {
	isAuthenticated: false,
	authClient: undefined,
	sommethingNew: "d",
};

const initialState = defaultState;

export const authSlice = createSlice({
	name: "auth",
	initialState: initialState,
	reducers: {
		updateAuthState: (state, action) => {
			const { authClient, isAuthenticated } = action.payload;
			return (state = {
				...state,
				isAuthenticated,
				authClient,
			});
		},
	},
});

// Action creators are generated for each case reducer function
export const { updateAuthState } = authSlice.actions;
export const selectAuth = (state) => state.auth;

export default authSlice.reducer;
