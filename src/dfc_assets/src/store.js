import { configureStore } from "@reduxjs/toolkit";
import feedsReducer from "./reducers/feeds";
import actorsReducer from "./reducers/actors";
import authReducer from "./reducers/auth";
import screenReducer from "./reducers/screen";

export default configureStore({
	reducer: {
		feeds: feedsReducer,
		actors: actorsReducer,
		auth: authReducer,
		screen: screenReducer,
	},
});
