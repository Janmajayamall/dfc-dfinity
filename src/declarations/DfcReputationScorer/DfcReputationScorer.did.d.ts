import type { Principal } from '@dfinity/principal';
export type CommentId = bigint;
export type ContentId = bigint;
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
export interface ReputationScore {
  'reputationScore' : number,
  'authorScore' : number,
  'userId' : UserId,
  'raterScore' : number,
  'timestamp' : Timestamp,
}
export interface SubscribeReputationScoreEventsData {
  'callback' : [Principal, string],
}
export type SubscriptionRatingEvent = { 'didUpdateRating' : RatingUpdate };
export type SubscriptionReputationScoreEvent = {
    'didUpdateLeadershipBoard' : Array<
      { 'userId' : UserId, 'reputationScoreObj' : ReputationScore }
    >
  };
export type Timestamp = bigint;
export type UserId = Principal;
export interface _SERVICE {
  'calculateReputationScore' : () => Promise<undefined>,
  'callbackForRatingEvent' : (arg_0: SubscriptionRatingEvent) => Promise<
      undefined
    >,
  'getLatestLeadershipBoard' : () => Promise<Array<ReputationScore>>,
  'init' : () => Promise<undefined>,
  'publishReputationScoreEvents' : (
      arg_0: SubscriptionReputationScoreEvent,
    ) => Promise<undefined>,
  'subscribeReputationScoreEvents' : (
      arg_0: SubscribeReputationScoreEventsData,
    ) => Promise<undefined>,
  'testCommentsRatingDataMap' : () => Promise<
      Array<
        {
          'negativeRatings' : bigint,
          'commentId' : CommentId,
          'positiveRatings' : bigint,
        }
      >
    >,
}
