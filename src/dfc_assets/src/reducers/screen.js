import { createSlice } from "@reduxjs/toolkit";
import { StarTwoTone } from "../../../../node_modules/@material-ui/icons/index";

export const SCREEN_SELECTOR = {
	main: "MAIN",
	profile: "PROFILE",
};

const initialState = {
	screen: SCREEN_SELECTOR.main,
};

export const screenSlice = createSlice({
	name: "screen",
	initialState: initialState,
	reducers: {
		changeScreen: (state, action) => {
			const to = action.payload;
			console.log(to, " the calue id ");
			state = {
				...state,
				screen: to,
			};
		},
	},
});

// Action creators are generated for each case reducer function
export const { changeScreen } = screenSlice.actions;
export const selectScreen = (state) => state.screen.screen;

export default screenSlice.reducer;
