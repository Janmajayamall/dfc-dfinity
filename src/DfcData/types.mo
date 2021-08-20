import Principal "mo:base/Principal";
import Array "mo:base/Array";

module {
      public type Site = {#twitter; #facebook};

    public type ContentIdentification = {
        postId: Text;
    };

    public type ContentId = Text;
    public type Content = {
        id: ContentId;
        contentIdentification:ContentIdentification;
        createdAt: Int;
        user: User;
        burntTokens: Int;
    };

    public type CommentId = Text;
    public type Comment = {
        id: CommentId;
        contentId: ContentId;
        text: Text;
        user: User;
        createdAt: Int;
    };
    public type CommentHashMap =  HashMap.HashMap<CommentId, Comment>;

    public type RatingId = Text;
    public type Rating = {
        id: RatingId;
        commentId: CommentId;
        user: User;
        ratingValue: Bool;
    };
    public type RatingHashMap = HashMap.HashMap<RatingId, Rating>;

    public type UserId = Principal;
    public type User = {
        id: UserId;
        username: Text;
    };


    public type Feed = {
        contentId: ContentId;
        content: Content;
        comments: [Comment];
        ratings2d: [[Rating]];
    };

}