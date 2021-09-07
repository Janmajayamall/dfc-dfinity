import { Actor, HttpAgent } from "@dfinity/agent";
import { dummyFeed } from "./utils";
import { AuthClient } from "@dfinity/auth-client";
import { useImperativeHandle } from "react";

const agent = new HttpAgent();
// const dfc = Actor.createActor(dfc_idl, { agent, canisterId: dfc_id });

// export async function getFeed() {
// 	try {
// 		let feed = await dfc.getFeed();
// 		return feed;
// 	} catch (e) {
// 		console.log(e);
// 		return dummyFeed;
// 	}
// }

// export function addComment(contentId, comment) {
// 	return dfc.addComment(contentId, comment);
// }

// export function addRating(commentId, ratingValue) {
// 	return dfc.addRating(commentId, ratingValue);
// }

// export async function lookupUser() {
// 	try {
// 		let user = await dfc.lookupUser();
// 		if (user) {
// 			return user;
// 		}
// 		throw new Error("No user with user id");
// 	} catch (e) {
// 		// return default user for dev
// 		return {
// 			userId: 4,
// 			username: "justBeingHelpful",
// 		};
// 	}
// }

// export async function flagContent(site, postId, burntTokens) {
// 	return dfc.flagContent(site, postId, burntTokens);
// }
