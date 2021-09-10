import type { Principal } from '@dfinity/principal';
export interface Comment {
  'id' : CommentId,
  'contentId' : ContentId,
  'username' : string,
  'userId' : UserId,
  'text' : string,
}
export type CommentId = bigint;
export interface Content {
  'id' : ContentId,
  'url' : string,
  'time' : Timestamp,
  'tokensBurnt' : bigint,
}
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
export type SubscriptionReputationScoreEvent = {
    'didUpdateLeadershipBoard' : Array<
      { 'userId' : UserId, 'reputationScoreObj' : ReputationScore }
    >
  };
export type Timestamp = bigint;
export type UserId = Principal;
export interface _SERVICE {
  'callbackForCommentEvent' : (arg_0: SubscriptionCommentEvent) => Promise<
      undefined
    >,
  'callbackForContentEvent' : (arg_0: SubscriptionContentEvent) => Promise<
      undefined
    >,
  'callbackForRatingEvent' : (arg_0: SubscriptionRatingEvent) => Promise<
      undefined
    >,
  'callbackForReputationScoreEvent' : (
      arg_0: SubscriptionReputationScoreEvent,
    ) => Promise<undefined>,
  'getNeedsHelpFeedContentIds' : () => Promise<Array<ContentId>>,
  'getSatisfiedFeedContentIds' : () => Promise<Array<ContentId>>,
  'init' : () => Promise<undefined>,
  'scanNeedsHelpFeed' : () => Promise<undefined>,
  'testFlaggedContentMap' : () => Promise<
      Array<
        {
          'contentId' : ContentId,
          'comments' : Array<
            {
              'commentId' : CommentId,
              'ratings' : {
                'negativeRatings' : Array<UserId>,
                'positiveRatings' : Array<UserId>,
              },
            }
          >,
        }
      >
    >,
}
