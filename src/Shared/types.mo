import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Option "mo:base/Option";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Array "mo:base/Array";

module {
    public type Timestamp = Int;
    public type UserId = Principal;
    public type ID = Nat;
    public type ContentId = ID;
    public type CommentId = ID;
    public type RatingValue = Bool;

    public type Profile = {
        userId: UserId;
        username: Text;
    };

    public type Comment = {
        id: CommentId;
        text: Text;
        userId: UserId;
        username: Text;
        contentId: ContentId;
    }; 

    public type Rating = {
        userId: UserId;
        rating: RatingValue;
        commentId: CommentId;
        validRating: Bool;
    };

    public type Content = {
        id: ContentId;
        url: Text;
        time: Timestamp;
        tokensBurnt: Nat;
    };


    public type CommentDetails = {
        id: CommentId;
        text: Text;
        userId: UserId;
        username: Text;
        ratings: [Rating];
        contentId: ContentId;
    };

    public type ContentDetails = {
        id: ContentId;
        url: Text;
        time: Timestamp;
        tokensBurnt: Nat;
        comments: [CommentDetails];
    };

    public type ProfileError = {
        #profileDoesNotExists: Principal;
        #usernameAlreadyExists: Text;
        #userAlreadyExists: UserId;
    };

    public type IDError = {
        #idDoesNotExists: ID;
    };

    public type NewCommentError = {
        #idDoesNotExists: ID;
        #profileDoesNotExists: Principal;
        #unknown;
    };

    // for subscription of user data related events
    public type SubscriptionUserDataEvent = {
        #didAddComment: {commentAuthorUserId: UserId; comment: Comment};
        #didDeleteComment: {commentAuthorUserId: UserId; commentId: CommentId};
        #didReceiveRatingOnThyComment: {commentAuthorUserId: UserId; raterUserId: UserId; rating: Rating};
        #didAddNewRating: {raterUserId: UserId; rating: Rating};
    };

    public type SubscribeUserDataEventsData = {
        userId: UserId;
        callback: shared SubscriptionUserDataEvent -> ();
    };

    // for subscription of user profile related events
    public type SubscriptionUserProfileEvent = {
        #didRegisterNewUser: {userId: UserId; profile: Profile};
    };

    public type SubscribeUserProfileEventsData = {
        callback: shared SubscriptionUserProfileEvent -> ();
    };

    // for subscription of rating events
    public type SubscriptionRatingEvent = {
        #didUpdateRating: {commentId: CommentId; rating: Rating; positiveDelta: Int; negativeDelta: Int};
    }

    public type SubscribeRatingEventsData = {
        callback: shared SubscriptionRatingEvent -> ();
    }

    // Reputation score
    public type ReputationScore = {
        userId: UserId;
        authorScore: Float;
        raterScore: Float;
        timestamp: Timestamp;
    };

    public type LeadershipBoard = HashMap.HashMap<Timestamp, HashMap.HashMap<UserId, ReputationScore>>(1, Int.equal, Int.hash);
    public type AuthorScoresMap = HashMap.HashMap<Types.UserId, Float>;

    public type ReceivedRatingsFromUserMetadata = {userId: Types.User; positiveRatings: Float; negativeRatings: Float; totalRatings: Float};
    public type UsersDataForAuthorScore = [{userId: UserId, receivedRatingsMetadata: [ReceivedRatingsFromUserMetadata]}];
    public type UsersAuthorScoreMap = HashMap.HashMap<Types.UserId, {authorScore: Float}>;
};
