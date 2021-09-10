export const idlFactory = ({ IDL }) => {
  const UserId = IDL.Principal;
  const Profile = IDL.Record({ 'username' : IDL.Text, 'userId' : UserId });
  const SubscriptionUserProfileEvent = IDL.Variant({
    'didRegisterNewUser' : IDL.Record({
      'userId' : UserId,
      'profile' : Profile,
    }),
  });
  const ReceivedRatingsFromUserMetadata = IDL.Record({
    'totalRatings' : IDL.Float64,
    'negativeRatings' : IDL.Float64,
    'positiveRatings' : IDL.Float64,
    'userId' : UserId,
  });
  const UsersDataForAuthorScore = IDL.Vec(
    IDL.Record({
      'receivedRatingsMetadataArray' : IDL.Vec(ReceivedRatingsFromUserMetadata),
      'userId' : UserId,
    })
  );
  const CommentId = IDL.Nat;
  const RatingValue = IDL.Bool;
  const Rating = IDL.Record({
    'commentId' : CommentId,
    'userId' : UserId,
    'rating' : RatingValue,
    'validRating' : IDL.Bool,
  });
  const UsersDataForRaterScore = IDL.Vec(
    IDL.Record({ 'userId' : UserId, 'userValidRatings' : IDL.Vec(Rating) })
  );
  const ContentId = IDL.Nat;
  const Comment = IDL.Record({
    'id' : CommentId,
    'contentId' : ContentId,
    'username' : IDL.Text,
    'userId' : UserId,
    'text' : IDL.Text,
  });
  return IDL.Service({
    'callbackForUserProfileEvent' : IDL.Func(
        [SubscriptionUserProfileEvent],
        [],
        ['oneway'],
      ),
    'getMyPrincipal' : IDL.Func([], [IDL.Principal], []),
    'getUsersDataForAuthorScore' : IDL.Func([], [UsersDataForAuthorScore], []),
    'getUsersDataForRaterScore' : IDL.Func([], [UsersDataForRaterScore], []),
    'init' : IDL.Func([], [], []),
    'testAllUsers' : IDL.Func([], [IDL.Vec(UserId)], []),
    'testAllUsersRatings' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Record({
              'userId' : UserId,
              'ratings' : IDL.Vec(
                IDL.Record({ 'commentId' : CommentId, 'rating' : Rating })
              ),
            })
          ),
        ],
        [],
      ),
    'testAllUsersReceivedRatings' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Record({
              'userId' : UserId,
              'receivedRatings' : IDL.Vec(
                IDL.Record({
                  'userId' : UserId,
                  'comments' : IDL.Vec(
                    IDL.Record({ 'commentId' : CommentId, 'rating' : Rating })
                  ),
                })
              ),
            })
          ),
        ],
        [],
      ),
    'testGetAllUsersComments' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Record({ 'userId' : UserId, 'comments' : IDL.Vec(Comment) })
          ),
        ],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
