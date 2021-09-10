import type { Principal } from '@dfinity/principal';
export interface Comment {
  'id' : CommentId,
  'contentId' : ContentId,
  'username' : string,
  'userId' : UserId,
  'text' : string,
}
export interface CommentDetails {
  'id' : CommentId,
  'contentId' : ContentId,
  'username' : string,
  'userId' : UserId,
  'text' : string,
  'ratings' : Array<Rating>,
}
export type CommentId = bigint;
export interface Content {
  'id' : ContentId,
  'url' : string,
  'time' : Timestamp,
  'tokensBurnt' : bigint,
}
export interface ContentDetails {
  'id' : ContentId,
  'url' : string,
  'time' : Timestamp,
  'tokensBurnt' : bigint,
  'comments' : Array<CommentDetails>,
}
export type ContentId = bigint;
export type ID = bigint;
export type NewCommentError = { 'idDoesNotExists' : ID } |
  { 'profileDoesNotExists' : Principal } |
  { 'unknown' : null };
export interface Rating {
  'commentId' : CommentId,
  'userId' : UserId,
  'rating' : RatingValue,
  'validRating' : boolean,
}
export interface RatingUpdate {
  'ratingObj' : Rating,
  'contentId' : ContentId,
  'commentId' : CommentId,
  'negativeDelta' : bigint,
  'positiveDelta' : bigint,
}
export type RatingValue = boolean;
export type Result = { 'ok' : Rating } |
  { 'err' : CommentId };
export type Result_1 = { 'ok' : ContentDetails } |
  { 'err' : ContentId };
export type Result_2 = { 'ok' : Comment } |
  { 'err' : NewCommentError };
export interface SubscribeCommentEventsData { 'callback' : [Principal, string] }
export interface SubscribeContentEventsData { 'callback' : [Principal, string] }
export interface SubscribeRatingEventsData { 'callback' : [Principal, string] }
export interface SubscribeUserDataEventsData {
  'userId' : UserId,
  'callback' : [Principal, string],
}
export type SubscriptionCommentEvent = {
    'didAddComment' : {
      'contentId' : ContentId,
      'commentId' : CommentId,
      'comment' : Comment,
    }
  };
export type SubscriptionContentEvent = {
    'didFlagNewContent' : { 'contentId' : ContentId, 'content' : Content }
  };
export type SubscriptionRatingEvent = { 'didUpdateRating' : RatingUpdate };
export type SubscriptionUserDataEvent = {
    'didDeleteComment' : {
      'commentId' : CommentId,
      'commentAuthorUserId' : UserId,
    }
  } |
  {
    'didReceiveRatingOnThyComment' : {
      'raterUserId' : UserId,
      'commentAuthorUserId' : UserId,
      'rating' : Rating,
    }
  } |
  {
    'didAddComment' : { 'comment' : Comment, 'commentAuthorUserId' : UserId }
  } |
  { 'didAddNewRating' : { 'raterUserId' : UserId, 'rating' : Rating } };
export type Timestamp = bigint;
export type UserId = Principal;
export interface _SERVICE {
  'addComment' : (arg_0: string, arg_1: ContentId) => Promise<Result_2>,
  'flagNewContent' : (arg_0: string, arg_1: bigint) => Promise<Content>,
  'getContentDetails' : (arg_0: ContentId) => Promise<Result_1>,
  'getContentDetailsInBatch' : (arg_0: Array<ContentId>) => Promise<
      Array<ContentDetails>
    >,
  'getMyPrincipal' : () => Promise<Principal>,
  'publishCommentEvent' : (arg_0: SubscriptionCommentEvent) => Promise<
      undefined
    >,
  'publishContentEvent' : (arg_0: SubscriptionContentEvent) => Promise<
      undefined
    >,
  'publishRatingEvent' : (arg_0: SubscriptionRatingEvent) => Promise<undefined>,
  'publishUserDataEvent' : (
      arg_0: Array<UserId>,
      arg_1: SubscriptionUserDataEvent,
    ) => Promise<undefined>,
  'rateComment' : (
      arg_0: ContentId,
      arg_1: CommentId,
      arg_2: boolean,
    ) => Promise<Result>,
  'subscribeCommentEvents' : (arg_0: SubscribeCommentEventsData) => Promise<
      undefined
    >,
  'subscribeContentEvents' : (arg_0: SubscribeContentEventsData) => Promise<
      undefined
    >,
  'subscribeRatingEvents' : (arg_0: SubscribeRatingEventsData) => Promise<
      undefined
    >,
  'subscribeUserDataEvents' : (arg_0: SubscribeUserDataEventsData) => Promise<
      undefined
    >,
}
