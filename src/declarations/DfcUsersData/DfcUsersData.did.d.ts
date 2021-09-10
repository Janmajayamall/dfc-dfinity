import type { Principal } from '@dfinity/principal';
export interface Comment {
  'id' : CommentId,
  'contentId' : ContentId,
  'username' : string,
  'userId' : UserId,
  'text' : string,
}
export type CommentId = bigint;
export type ContentId = bigint;
export interface Profile { 'username' : string, 'userId' : UserId }
export interface Rating {
  'commentId' : CommentId,
  'userId' : UserId,
  'rating' : RatingValue,
  'validRating' : boolean,
}
export type RatingValue = boolean;
export interface ReceivedRatingsFromUserMetadata {
  'totalRatings' : number,
  'negativeRatings' : number,
  'positiveRatings' : number,
  'userId' : UserId,
}
export type SubscriptionUserProfileEvent = {
    'didRegisterNewUser' : { 'userId' : UserId, 'profile' : Profile }
  };
export type UserId = Principal;
export type UsersDataForAuthorScore = Array<
  {
    'receivedRatingsMetadataArray' : Array<ReceivedRatingsFromUserMetadata>,
    'userId' : UserId,
  }
>;
export type UsersDataForRaterScore = Array<
  { 'userId' : UserId, 'userValidRatings' : Array<Rating> }
>;
export interface _SERVICE {
  'callbackForUserProfileEvent' : (
      arg_0: SubscriptionUserProfileEvent,
    ) => Promise<undefined>,
  'getMyPrincipal' : () => Promise<Principal>,
  'getUsersDataForAuthorScore' : () => Promise<UsersDataForAuthorScore>,
  'getUsersDataForRaterScore' : () => Promise<UsersDataForRaterScore>,
  'init' : () => Promise<undefined>,
  'testAllUsers' : () => Promise<Array<UserId>>,
  'testAllUsersRatings' : () => Promise<
      Array<
        {
          'userId' : UserId,
          'ratings' : Array<{ 'commentId' : CommentId, 'rating' : Rating }>,
        }
      >
    >,
  'testAllUsersReceivedRatings' : () => Promise<
      Array<
        {
          'userId' : UserId,
          'receivedRatings' : Array<
            {
              'userId' : UserId,
              'comments' : Array<
                { 'commentId' : CommentId, 'rating' : Rating }
              >,
            }
          >,
        }
      >
    >,
  'testGetAllUsersComments' : () => Promise<
      Array<{ 'userId' : UserId, 'comments' : Array<Comment> }>
    >,
}
