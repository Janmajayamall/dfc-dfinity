import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Error "mo:base/Error";
import Option "mo:base/Option";
import Array "mo:base/Array";

actor {
    public type Site = {#twitter; #facebook};

    public type ContentIdentification = {
        site: Site;
        postId: Text;
    };

    public type ContentId = Text;
    public type Content = {
        id: ContentId;
        contentIdentification:ContentIdentification;
        createdAt: Int;
        user: User;
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

    let usersMap = HashMap.HashMap<UserId, User>(1, func (x, y) {x==y;}, Principal.hash);
    let contentsMap = HashMap.HashMap<ContentId, Content>(1, Text.equal, Text.hash);
    let contentCommentsMap = HashMap.HashMap<ContentId, CommentHashMap>(1, Text.equal, Text.hash);
    let commentRatingsMap = HashMap.HashMap<CommentId, RatingHashMap>(1, Text.equal, Text.hash);
    
    var contentIdCount : Nat = 0;
    var commentIdCount : Nat = 0;

    func findUser(userId: UserId): ?User {
        usersMap.get(userId);
    };

    func findContent(contentId: ContentId): ?Content {
        contentsMap.get(contentId);
    };

    func findComment(contentId: ContentId, commentId: CommentId): ?Comment {
        let comments = Option.unwrap(contentCommentsMap.get(contentId));
        comments.get(commentId);
    };

    func findAllContents(): [Content] {
         var contentArray: [Content] = [];

        for ((id, content) in contentsMap.entries()) {
            contentArray := Array.append<Content>(contentArray, [content]);
        };

        return contentArray;
    };

    func findAllComments(contentId: ContentId): [Comment] {
        var commentsMap = Option.unwrap(contentCommentsMap.get(contentId));

        var commentArray: [Comment] = [];
        for ((id, comment) in commentsMap.entries()) {
            commentArray := Array.append<Comment>(commentArray, [comment]);
        };

        return commentArray;
    };

    func findAllRatings(commentId: CommentId): [Rating] {
        var ratingsMap = Option.unwrap(commentRatingsMap.get(commentId));

        var ratingArray: [Rating] = [];
        for((id, rating) in ratingsMap.entries()) {
            ratingArray := Array.append<Rating>(ratingArray, [rating]);
        };

        return ratingArray
    };

    // shared functions
    public shared (msg) func createProfile(username: Text): async () {
        // Check whether username already exists or not
        usersMap.put(msg.caller, {
            id = msg.caller;
            username = username;
        });
    };

    public shared query (msg) func lookupUser() : async ?User {
        findUser(msg.caller);
    };

    public shared query (msg) func getAllContents() : async [Content] {
        findAllContents();
    };

    public shared query (msg) func getAllComments(contentId: ContentId): async [Comment] {
        findAllComments(contentId);
    };

    public shared query (msg) func getAllRatings(commentId: CommentId): async [Rating] {
        findAllRatings(commentId);
    };

    public shared query (msg) func getFeed(): async [Feed] {
        var feedArray : [Feed] = [];

        let contents = findAllContents();
        for (content in contents.vals()){
            let comments = findAllComments(content.id);
            var ratings2d: [[Rating]] = [];
            for (comment in comments.vals()) {
                let commentRatings = findAllRatings(comment.id);
                ratings2d := Array.append<[Rating]>(ratings2d, [commentRatings]);
            };
            let feedItem: Feed = {
                contentId = content.id;
                content = content;
                comments = comments;
                ratings2d = ratings2d;
            };
            feedArray := Array.append<Feed>(feedArray, [feedItem]);
        };

        return feedArray
    };

    public shared (msg) func flagContent(site: Site, postId: Text) : async () {
        // check whether content has already been flagged or not 

        // change it to Reject to make the error more clear
        let user = Option.unwrap(findUser(msg.caller));

        let contentId : Text = Nat.toText(contentIdCount);
        contentIdCount += 1;

        // content identification
        let contentIdentification: ContentIdentification = {
            site = site;
            postId = postId;
        };
        
        // insert flagged content into contents hashmap
        contentsMap.put(contentId, {
            id = contentId;
            contentIdentification = contentIdentification;
            createdAt = Time.now();
            user = user;
        });

        // insert content comment map
        contentCommentsMap.put(contentId, HashMap.HashMap<CommentId, Comment>(1, Text.equal, Text.hash));
    };

    public shared (msg) func addComment(contentId: ContentId, comment: Text) : async () {
        // check user
        let user = Option.unwrap(findUser(msg.caller));
        
        // check comment map exists
        var comments = Option.unwrap(contentCommentsMap.get(contentId));

        // a new comment
        let newCommentId: Text = Nat.toText(commentIdCount);
        commentIdCount += 1;
        comments.put(newCommentId, {
            id = newCommentId;
            contentId = contentId;
            text = comment;
            user = user;
            createdAt = Time.now();
        });

        // insert commment rating map
        commentRatingsMap.put(newCommentId, HashMap.HashMap<RatingId, Rating>(1, Text.equal, Text.hash));
    };

    public shared (msg) func addRating(commentId: CommentId, ratingValue: Bool): async () {
        // check - comment author cannot rate themselves

        // check user
        let user = Option.unwrap(findUser(msg.caller));

        // check comment in the content
        let ratings = Option.unwrap(commentRatingsMap.get(commentId));

        // a new rating
        let newRatingId: Text = Principal.toText(msg.caller) # "+" # commentId;
        ratings.put(newRatingId, {
            id = newRatingId;
            commentId = commentId;
            user = user;
            ratingValue = ratingValue;
        });
    };


    func isEqUserId(x: UserId, y: UserId): Bool {
        x == y;
    };

};
