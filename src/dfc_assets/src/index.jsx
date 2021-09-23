import { useEffect, useState } from "react";
import React from "react";
// import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import { render } from "react-dom";
import store from "./store";
import { Provider, useSelector, useDispatch } from "react-redux";
import { selectScreen, changeScreen, SCREEN_SELECTOR } from "./reducers/screen";
import FeedScreen from "./pages/FeedScreen";
import { AuthClient } from "@dfinity/auth-client";
import auth, { selectAuth, updateAuthState } from "./reducers/auth";
import TopBar from "./components/TopBar";
import { getUserProfile, initActorsHelper } from "./utils/index";
import { useAuth } from "./hooks";
import { init } from "../../declarations/DfcData/DfcData.did";
import { initActorsState } from "./reducers/actors";
import {
	ChakraProvider,
	Stack,
	HStack,
	VStack,
	Flex,
	Button,
	Spacer,
	Tabs,
	TabList,
	TabPanels,
	Tab,
	TabPanel,
	Box,
	AspectRatio,
	Text,
	IconButton,
	Modal,
	ModalOverlay,
	ModalContent,
	ModalHeader,
	ModalFooter,
	ModalBody,
	ModalCloseButton,
	useDisclosure,
	Input,
} from "@chakra-ui/react";
import TweetEmbed from "react-tweet-embed";
import { ArrowUpIcon, ArrowDownIcon, AddIcon } from "@chakra-ui/icons";

const Page = () => {
	const { authClient, isAuthenticated, login, logout } = useAuth();

	const screen = useSelector(selectScreen);
	const dispatch = useDispatch();

	useEffect(() => {
		dispatch(
			updateAuthState({
				isAuthenticated: isAuthenticated,
			})
		);

		identity = authClient.getIdentity();
		initActors(identity);
	}, [isAuthenticated]);

	function initActors(identity) {
		const actors = initActorsHelper(identity);
		dispatch(initActorsState({ ...actors }));
	}

	// if (screen === SCREEN_SELECTOR.main) {
	// 	return (
	// 		<div>
	// 			<TopBar authState={authState} login={login} />
	// 			<div style={{ marginTop: 5 }} />
	// 			<FeedScreen />
	// 		</div>
	// 	);
	// }

	// return <div />;
};

let testObj = {
	username: "aiowda",
	comment:
		"Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
};
let testList = [testObj, testObj];

const App = () => {
	const { isOpen, onOpen, onClose } = useDisclosure();

	function Leaderboard() {}

	function NewContentModal() {
		return (
			<Modal isOpen={isOpen} onClose={onClose}>
				<ModalOverlay />
				<ModalContent bg="gray.800" color="white">
					<ModalHeader>Flag new content</ModalHeader>
					<ModalCloseButton />
					<Box w="100%" p="5" justifyContent="center">
						<Input placeholder="Tweet URL" size="md" w="90%" />
						<Input
							mt="2"
							placeholder="Tokens to burn"
							size="md"
							w="90%"
						/>
					</Box>
					<ModalFooter>
						<Button colorScheme="blue" mr={3} onClick={onClose}>
							Add
						</Button>
					</ModalFooter>
				</ModalContent>
			</Modal>
		);
	}

	return (
		<Provider store={store}>
			<ChakraProvider>
				<VStack
					spacing={4}
					align="stretch"
					h="100vh"
					bg="gray.800"
					color="white"
				>
					<Flex p="5">
						<Spacer />
						<Button colorScheme="teal" variant="solid">
							Home
						</Button>
						<Button colorScheme="teal" variant="solid">
							Leaderboard
						</Button>
						<Button colorScheme="teal" variant="solid">
							Login
						</Button>
					</Flex>
					<Tabs isFitted variant="enclosed">
						<TabList>
							<Tab>Needs Help</Tab>
							<Tab>Satisfied</Tab>
						</TabList>

						<TabPanels>
							<TabPanel>
								<Flex flexDirection="column">
									{/* <TweetEmbed
										id={"1440753048020602881"}
										options={{
											align: "center",
											conversation: "none",
											theme: "dark",
										}}
									/> */}
									<Flex>
										<Spacer />
										<Box
											borderWidth="1px"
											borderRadius="lg"
											w="520px"
											p="5"
										>
											{testList.map((obj) => {
												return (
													<Box marginBottom="4">
														<Text
															color="white"
															noOfLines={10}
															fontSize="sm"
															fontWeight="semibold"
														>
															{obj.username}
														</Text>
														<Flex
															justifyContent="center"
															mu="2"
														>
															<Box mr="2">
																<IconButton
																	colorScheme="teal"
																	aria-label="Call Segun"
																	size="sm"
																	icon={
																		<ArrowUpIcon
																			w={
																				6
																			}
																			h={
																				6
																			}
																		/>
																	}
																/>
																<IconButton
																	colorScheme="teal"
																	aria-label="Call Segun"
																	size="sm"
																	icon={
																		<ArrowDownIcon
																			w={
																				6
																			}
																			h={
																				6
																			}
																		/>
																	}
																/>
															</Box>
															<Text
																color="white"
																noOfLines={10}
																fontSize="sm"
															>
																{obj.comment}
															</Text>
														</Flex>
													</Box>
												);
											})}
										</Box>
										<Spacer />
									</Flex>
								</Flex>
							</TabPanel>
							<TabPanel>
								<p>two!</p>
							</TabPanel>
						</TabPanels>
					</Tabs>
					<Spacer />
					<Flex p="5">
						<Spacer />
						<IconButton
							onClick={onOpen}
							colorScheme="teal"
							aria-label="Call Segun"
							size="md"
							icon={<AddIcon w={6} h={6} />}
						/>
					</Flex>
				</VStack>
				<NewContentModal />
			</ChakraProvider>
		</Provider>
	);
};

render(<App />, document.getElementById("app"));

// screens
// 1. Feed Screen
// 2. Flag modal
// 3. Leaderboard screen

// document.getElementById("clickMeBtn").addEventListener("click", async () => {
// 	const name = document.getElementById("name").value.toString();
// 	const greeting = await dfc.greet(name);

// 	document.getElementById("greeting").innerText = greeting;
// });

// Work to do
// 1. Setup react router
// 2. Setup react state
// setup interaction with backend
// 3. UI for 2 different feeds
// 4. Pop up for flagging new content
// 5. Page for leadership board
// 6. Page for individual's past scores
// 7. Profile page

// const Feed = () => {
// 	const [feed, setFeed] = React.useState([]);
// 	const [user, setUser] = React.useState({ id: "", username: "" });
// 	const [toggleUpdate, setToggleUpdate] = React.useState(true);
// 	const [profileModalState, setProfileModalState] = React.useState(false);
// 	const [newContentModalState, setNewContentModalState] =
// 		React.useState(false);

// 	React.useEffect(async () => {
// 		const user = await lookupUser();
// 		setUser(user);

// 		const feed = await getFeed();
// 		setFeed(feed);
// 	}, []);

// 	async function addNewComment(contentId, commentText) {
// 		// handle optimistic update
// 		let fakeId = "100000000";
// 		handleAddNewComment(
// 			contentId,
// 			{
// 				id: fakeId,
// 				contentId: contentId,
// 				createdAt: new Date().getTime(),
// 				text: commentText,
// 				user: { username: "justBeingHelpful" },
// 			},
// 			true
// 		);

// 		// canister call
// 		try {
// 			const addedComment = await addComment(contentId, commentText);

// 			// undo optimistic update
// 			handleAddNewComment(addedComment, false);
// 		} catch (e) {
// 			console.log(e);
// 		}
// 	}

// 	async function handleAddNewComment(
// 		contentId,
// 		newCommentObj,
// 		optimisticUpdate
// 	) {
// 		let fakeId = "100000000";
// 		let updatedFeed = [];
// 		feed.forEach(function (feedItem) {
// 			if (feedItem.contentId === contentId) {
// 				// handle comment updated
// 				let comments = [];
// 				if (optimisticUpdate === true) {
// 					comments = [...feedItem.comments, newCommentObj];
// 				} else {
// 					let oldComments = feedItem.comments.filter((comment) => {
// 						return comment.id !== fakeId;
// 					});
// 					comments = [...oldComments, newCommentObj];
// 				}

// 				let updatedFeedItem = {
// 					...feedItem,
// 					comments: comments,
// 				};

// 				// handle rating2d update
// 				if (optimisticUpdate === true) {
// 					updatedFeedItem = {
// 						...updatedFeedItem,
// 						ratings2d: [...feedItem.ratings2d, []],
// 					};
// 				}

// 				updatedFeed.push(updatedFeedItem);
// 			} else {
// 				updatedFeed.push(feedItem);
// 			}
// 		});
// 		setFeed(updatedFeed);
// 	}

// 	function changeRating(contentId, commentId, rating) {
// 		let updatedFeed = [];
// 		feed.forEach(function (feedItem) {
// 			if (feedItem.contentId === contentId) {
// 				let comments = [];
// 				let ratings2d = [];
// 				feedItem.comments.forEach(function (comment, index) {
// 					if (comment.id === commentId) {
// 						// check user's existing rating
// 						var newRatings = feedItem.ratings2d[index].filter(
// 							(rating) => rating.user.id !== user.id
// 						);

// 						newRatings.push({
// 							id: "lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae+0",
// 							commentId: commentId,
// 							ratingValue: rating,
// 							user: {
// 								id: user.id,
// 								username: user.username,
// 							},
// 						});

// 						ratings2d.push(newRatings);
// 					} else {
// 						ratings2d.push(feedItem.ratings2d[index]);
// 					}
// 					comments.push(comment);
// 				});
// 				updatedFeed.push({
// 					...feedItem,
// 					comments: comments,
// 					ratings2d: ratings2d,
// 				});
// 			} else {
// 				updatedFeed.push(feedItem);
// 			}
// 		});
// 		setFeed(updatedFeed);
// 		setToggleUpdate(!toggleUpdate);
// 	}

// 	async function flagNewContent(contentUrl, tokens) {
// 		//post id
// 		let postId = contentUrl.split("/").pop();

// 		// handle optimistic update
// 		let fakeContentId = "10000000";
// 		handleFlagNewContent(
// 			{
// 				id: fakeContentId,
// 				contentIdentification: {
// 					postId: postId,
// 				},
// 				createdAt: new Date().getTime(),
// 				user: user,
// 				burntTokens: Number(tokens),
// 			},
// 			true
// 		);

// 		// canister call
// 		try {
// 			const newFlaggedContent = await flagContent(postId, Number(tokens));
// 			handleFlagNewContent(newFlaggedContent, false);
// 		} catch (e) {
// 			console.log(e);
// 		}
// 	}

// 	async function handleFlagNewContent(contentObject, optimisticUpdate) {
// 		if (optimisticUpdate === true) {
// 			let updatedFeed = [
// 				{
// 					contentId: contentObject.id,
// 					content: contentObject,
// 					comments: [],
// 					ratings2d: [[]],
// 				},
// 				...feed,
// 			];
// 			setFeed(updatedFeed);
// 		} else {
// 			var updatedFeed = feed.filter((content) => {
// 				return (
// 					content.contentIdentification.postId !==
// 					contentObject.contentIdentification.postId
// 				);
// 			});
// 			updatedFeed = [
// 				{
// 					contentId: contentObject.id,
// 					content: contentObject,
// 					comments: [],
// 					ratings2d: [[]],
// 				},
// 				...updatedFeed,
// 			];
// 			setFeed(updatedFeed);
// 		}
// 	}

// 	function toggleProfileModal() {
// 		setProfileModalState(!profileModalState);
// 	}

// 	function toggleNewContentModal() {
// 		setNewContentModalState(!newContentModalState);
// 	}

// 	return (
// 		<div style={{ flex: 1, backgroundColor: colorScheme.primary }}>
// 			<TopBar position="static">
// 				<Toolbar
// 					style={{
// 						display: "flex",
// 						justifyContent: "flex-end",
// 					}}
// 				>
// 					<IconButton
// 						onClick={() => {
// 							toggleProfileModal();
// 						}}
// 					>
// 						<PersonIcon
// 							style={{ color: colorScheme.textPrimary }}
// 						/>
// 					</IconButton>
// 				</Toolbar>
// 			</TopBar>
// 			<div
// 				style={{
// 					display: "flex",
// 					flexDirection: "column",
// 					alignItems: "center",
// 					width: "100%",
// 				}}
// 			>
// 				{feed.map((feedItem) => (
// 					<FeedItem
// 						user={user}
// 						feedItem={feedItem}
// 						addNewComment={addNewComment}
// 						changeRating={changeRating}
// 					/>
// 				))}
// 			</div>
// 			<Fab
// 				style={{
// 					position: "fixed",
// 					bottom: 10,
// 					right: 10,
// 				}}
// 				color="primary"
// 				aria-label="add"
// 				onClick={() => {
// 					toggleNewContentModal();
// 				}}
// 			>
// 				<AddIcon />
// 			</Fab>
// 			<ProfileModal
// 				user={user}
// 				open={profileModalState}
// 				handleClose={toggleProfileModal}
// 			/>
// 			<NewContentModal
// 				user={user}
// 				open={newContentModalState}
// 				handleClose={toggleNewContentModal}
// 				flagNewContent={flagNewContent}
// 			/>
// 		</div>
// 	);
// };
