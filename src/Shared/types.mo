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

    // for subscription of comment related events
    public type SubscriptionCommentEvent = {
        #didAddComment: {commentAuthorUserId: UserId; comment: Comment};
        #didDeleteComment: {commentAuthorUserId: UserId; commentId: CommentId};
        #didRecevieRatingOnThyComment: {commentAuthorUserId: UserId; raterUserId: UserId; rating: Rating};
        #didAddNewRating: {raterUserId: UserId; rating: Rating};
    };

    public type SubcribeCommentEventsData = {
        userId: UserId;
        callback: shared SubscriptionCommentEvent -> ();
    };

    // for subscription of user profile related events
    public type SubscriptionUserProfileEvent = {
        #didRegisterNewUser: {userId: UserId; profile: Profile};
    };

    public type SubcribeUserProfileEventsData = {
        callback: shared SubscriptionUserProfileEvent -> ();
    };
};

