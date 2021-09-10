export const idlFactory = ({ IDL }) => {
  const CommentId = IDL.Nat;
  const UserId = IDL.Principal;
  const RatingValue = IDL.Bool;
  const Rating = IDL.Record({
    'commentId' : CommentId,
    'userId' : UserId,
    'rating' : RatingValue,
    'validRating' : IDL.Bool,
  });
  const ContentId = IDL.Nat;
  const RatingUpdate = IDL.Record({
    'ratingObj' : Rating,
    'contentId' : ContentId,
    'commentId' : CommentId,
    'negativeDelta' : IDL.Int,
    'positiveDelta' : IDL.Int,
  });
  const SubscriptionRatingEvent = IDL.Variant({
    'didUpdateRating' : RatingUpdate,
  });
  const Timestamp = IDL.Int;
  const ReputationScore = IDL.Record({
    'reputationScore' : IDL.Float64,
    'authorScore' : IDL.Float64,
    'userId' : UserId,
    'raterScore' : IDL.Float64,
    'timestamp' : Timestamp,
  });
  const SubscriptionReputationScoreEvent = IDL.Variant({
    'didUpdateLeadershipBoard' : IDL.Vec(
      IDL.Record({ 'userId' : UserId, 'reputationScoreObj' : ReputationScore })
    ),
  });
  const SubscribeReputationScoreEventsData = IDL.Record({
    'callback' : IDL.Func([SubscriptionReputationScoreEvent], [], ['oneway']),
  });
  return IDL.Service({
    'calculateReputationScore' : IDL.Func([], [], ['oneway']),
    'callbackForRatingEvent' : IDL.Func(
        [SubscriptionRatingEvent],
        [],
        ['oneway'],
      ),
    'getLatestLeadershipBoard' : IDL.Func([], [IDL.Vec(ReputationScore)], []),
    'init' : IDL.Func([], [], []),
    'publishReputationScoreEvents' : IDL.Func(
        [SubscriptionReputationScoreEvent],
        [],
        ['oneway'],
      ),
    'subscribeReputationScoreEvents' : IDL.Func(
        [SubscribeReputationScoreEventsData],
        [],
        ['oneway'],
      ),
    'testCommentsRatingDataMap' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Record({
              'negativeRatings' : IDL.Int,
              'commentId' : CommentId,
              'positiveRatings' : IDL.Int,
            })
          ),
        ],
        ['query'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
