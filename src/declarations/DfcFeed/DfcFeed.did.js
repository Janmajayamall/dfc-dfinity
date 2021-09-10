export const idlFactory = ({ IDL }) => {
  const ContentId = IDL.Nat;
  const CommentId = IDL.Nat;
  const UserId = IDL.Principal;
  const Comment = IDL.Record({
    'id' : CommentId,
    'contentId' : ContentId,
    'username' : IDL.Text,
    'userId' : UserId,
    'text' : IDL.Text,
  });
  const SubscriptionCommentEvent = IDL.Variant({
    'didAddComment' : IDL.Record({
      'contentId' : ContentId,
      'commentId' : CommentId,
      'comment' : Comment,
    }),
  });
  const Timestamp = IDL.Int;
  const Content = IDL.Record({
    'id' : ContentId,
    'url' : IDL.Text,
    'time' : Timestamp,
    'tokensBurnt' : IDL.Nat,
  });
  const SubscriptionContentEvent = IDL.Variant({
    'didFlagNewContent' : IDL.Record({
      'contentId' : ContentId,
      'content' : Content,
    }),
  });
  const RatingValue = IDL.Bool;
  const Rating = IDL.Record({
    'commentId' : CommentId,
    'userId' : UserId,
    'rating' : RatingValue,
    'validRating' : IDL.Bool,
  });
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
  return IDL.Service({
    'callbackForCommentEvent' : IDL.Func(
        [SubscriptionCommentEvent],
        [],
        ['oneway'],
      ),
    'callbackForContentEvent' : IDL.Func(
        [SubscriptionContentEvent],
        [],
        ['oneway'],
      ),
    'callbackForRatingEvent' : IDL.Func(
        [SubscriptionRatingEvent],
        [],
        ['oneway'],
      ),
    'callbackForReputationScoreEvent' : IDL.Func(
        [SubscriptionReputationScoreEvent],
        [],
        ['oneway'],
      ),
    'getNeedsHelpFeedContentIds' : IDL.Func(
        [],
        [IDL.Vec(ContentId)],
        ['query'],
      ),
    'getSatisfiedFeedContentIds' : IDL.Func(
        [],
        [IDL.Vec(ContentId)],
        ['query'],
      ),
    'init' : IDL.Func([], [], ['oneway']),
    'scanNeedsHelpFeed' : IDL.Func([], [], ['oneway']),
    'testFlaggedContentMap' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Record({
              'contentId' : ContentId,
              'comments' : IDL.Vec(
                IDL.Record({
                  'commentId' : CommentId,
                  'ratings' : IDL.Record({
                    'negativeRatings' : IDL.Vec(UserId),
                    'positiveRatings' : IDL.Vec(UserId),
                  }),
                })
              ),
            })
          ),
        ],
        ['query'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
