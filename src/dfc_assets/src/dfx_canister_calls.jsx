import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory as dfc_idl, canisterId as dfc_id } from "dfx-generated/dfc";
import { dummyFeed } from "./utils";
import { AuthClient } from "@dfinity/auth-client";

const agent = new HttpAgent();
const dfc = Actor.createActor(dfc_idl, { agent, canisterId: dfc_id });

export async function getFeed() {
	try {
		let feed = await dfc.getFeed();
		return feed;
	} catch (e) {
		console.log(e);
		return dummyFeed;
	}
}

export function addComment(contentId, comment) {
	return dfc.addComment(contentId, comment);
}

export function addRating(commentId, ratingValue) {
	return dfc.addRating(commentId, ratingValue);
}
