import { createSlice } from "@reduxjs/toolkit";

const defaultState = {
	authenticated: false,
};

const initialState = defaultState;

export const authSlice = createSlice({
	name: "auth",
	initialState: initialState,
	reducers: {
		updateAuthState: (state, action) => {
			state.authenticated = action.authState;
		},
	},
});

// Action creators are generated for each case reducer function
export const { updateAuthState } = authSlice.actions;
export const selectAuthenticated = (state) => state.authenticated;

export default authSlice.reducer;
