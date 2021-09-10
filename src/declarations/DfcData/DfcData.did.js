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
  const ID = IDL.Nat;
  const NewCommentError = IDL.Variant({
    'idDoesNotExists' : ID,
    'profileDoesNotExists' : IDL.Principal,
    'unknown' : IDL.Null,
  });
  const Result_2 = IDL.Variant({ 'ok' : Comment, 'err' : NewCommentError });
  const Timestamp = IDL.Int;
  const Content = IDL.Record({
    'id' : ContentId,
    'url' : IDL.Text,
    'time' : Timestamp,
    'tokensBurnt' : IDL.Nat,
  });
  const RatingValue = IDL.Bool;
  const Rating = IDL.Record({
    'commentId' : CommentId,
    'userId' : UserId,
    'rating' : RatingValue,
    'validRating' : IDL.Bool,
  });
  const CommentDetails = IDL.Record({
    'id' : CommentId,
    'contentId' : ContentId,
    'username' : IDL.Text,
    'userId' : UserId,
    'text' : IDL.Text,
    'ratings' : IDL.Vec(Rating),
  });
  const ContentDetails = IDL.Record({
    'id' : ContentId,
    'url' : IDL.Text,
    'time' : Timestamp,
    'tokensBurnt' : IDL.Nat,
    'comments' : IDL.Vec(CommentDetails),
  });
  const Result_1 = IDL.Variant({ 'ok' : ContentDetails, 'err' : ContentId });
  const SubscriptionCommentEvent = IDL.Variant({
    'didAddComment' : IDL.Record({
      'contentId' : ContentId,
      'commentId' : CommentId,
      'comment' : Comment,
    }),
  });
  const SubscriptionContentEvent = IDL.Variant({
    'didFlagNewContent' : IDL.Record({
      'contentId' : ContentId,
      'content' : Content,
    }),
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
  const SubscriptionUserDataEvent = IDL.Variant({
    'didDeleteComment' : IDL.Record({
      'commentId' : CommentId,
      'commentAuthorUserId' : UserId,
    }),
    'didReceiveRatingOnThyComment' : IDL.Record({
      'raterUserId' : UserId,
      'commentAuthorUserId' : UserId,
      'rating' : Rating,
    }),
    'didAddComment' : IDL.Record({
      'comment' : Comment,
      'commentAuthorUserId' : UserId,
    }),
    'didAddNewRating' : IDL.Record({
      'raterUserId' : UserId,
      'rating' : Rating,
    }),
  });
  const Result = IDL.Variant({ 'ok' : Rating, 'err' : CommentId });
  const SubscribeCommentEventsData = IDL.Record({
    'callback' : IDL.Func([SubscriptionCommentEvent], [], ['oneway']),
  });
  const SubscribeContentEventsData = IDL.Record({
    'callback' : IDL.Func([SubscriptionContentEvent], [], ['oneway']),
  });
  const SubscribeRatingEventsData = IDL.Record({
    'callback' : IDL.Func([SubscriptionRatingEvent], [], ['oneway']),
  });
  const SubscribeUserDataEventsData = IDL.Record({
    'userId' : UserId,
    'callback' : IDL.Func([SubscriptionUserDataEvent], [], ['oneway']),
  });
  return IDL.Service({
    'addComment' : IDL.Func([IDL.Text, ContentId], [Result_2], []),
    'flagNewContent' : IDL.Func([IDL.Text, IDL.Nat], [Content], []),
    'getContentDetails' : IDL.Func([ContentId], [Result_1], ['query']),
    'getContentDetailsInBatch' : IDL.Func(
        [IDL.Vec(ContentId)],
        [IDL.Vec(ContentDetails)],
        ['query'],
      ),
    'getMyPrincipal' : IDL.Func([], [IDL.Principal], []),
    'publishCommentEvent' : IDL.Func(
        [SubscriptionCommentEvent],
        [],
        ['oneway'],
      ),
    'publishContentEvent' : IDL.Func(
        [SubscriptionContentEvent],
        [],
        ['oneway'],
      ),
    'publishRatingEvent' : IDL.Func([SubscriptionRatingEvent], [], ['oneway']),
    'publishUserDataEvent' : IDL.Func(
        [IDL.Vec(UserId), SubscriptionUserDataEvent],
        [],
        ['oneway'],
      ),
    'rateComment' : IDL.Func([ContentId, CommentId, IDL.Bool], [Result], []),
    'subscribeCommentEvents' : IDL.Func(
        [SubscribeCommentEventsData],
        [],
        ['oneway'],
      ),
    'subscribeContentEvents' : IDL.Func(
        [SubscribeContentEventsData],
        [],
        ['oneway'],
      ),
    'subscribeRatingEvents' : IDL.Func(
        [SubscribeRatingEventsData],
        [],
        ['oneway'],
      ),
    'subscribeUserDataEvents' : IDL.Func(
        [SubscribeUserDataEventsData],
        [],
        ['oneway'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
