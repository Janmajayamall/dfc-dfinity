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
	middleware: (getDefaultMiddleware) =>
		getDefaultMiddleware({
			serializableCheck: {
				// Ignore these action types
				ignoredActions: ["actors/initActors", "auth/updateAuthState"],
				// Ignore these field paths in all actions
				// ignoredActionPaths: ["meta.arg", "payload.timestamp"],
				// Ignore these paths in the state
				// ignoredPaths: ["items.dates"],
			},
		}),
});
