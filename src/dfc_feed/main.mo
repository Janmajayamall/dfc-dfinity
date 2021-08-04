import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Error "mo:base/Error";
import Option "mo:base/Option";
import Array "mo:base/Array";
import Types "./types"

actor {
    let usersMap = HashMap.HashMap<Types.UserId, Types.User>(1, func (x, y) {x==y;}, Principal.hash);
    let contentsMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Text.equal, Text.hash);
    let contentCommentsMap = HashMap.HashMap<Types.ContentId, Types.CommentHashMap>(1, Text.equal, Text.hash);
    let commentRatingsMap = HashMap.HashMap<Types.CommentId, Types.RatingHashMap>(1, Text.equal, Text.hash);

    let usernamesHashMap = HashMap.HashMap<Text, Text>(1, Text.equal, Text.hash);
    
    var contentIdCount : Nat = 0;
    var commentIdCount : Nat = 0;

    func findUser(userId: Types.UserId): ?Types.User {
        usersMap.get(userId);
    };

    func findContent(contentId: Types.ContentId): ?Types.Content {
        contentsMap.get(contentId);
    };

    func findComment(contentId: Types.ContentId, commentId: Types.CommentId): ?Types.Comment {
        let comments = Option.unwrap(contentCommentsMap.get(contentId));
        comments.get(commentId);
    };

    func findAllContents(): [Types.Content] {
         var contentArray: [Types.Content] = [];

        for ((id, content) in contentsMap.entries()) {
            contentArray := Array.append<Types.Content>(contentArray, [content]);
        };

        return contentArray;
    };

    func findAllComments(contentId: Types.ContentId): [Types.Comment] {
        var commentsMap = Option.unwrap(contentCommentsMap.get(contentId));

        var commentArray: [Types.Comment] = [];
        for ((id, comment) in commentsMap.entries()) {
            commentArray := Array.append<Types.Comment>(commentArray, [comment]);
        };

        return commentArray;
    };

    func findAllRatings(commentId: Types.CommentId): [Types.Rating] {
        var ratingsMap = Option.unwrap(commentRatingsMap.get(commentId));

        var ratingArray: [Types.Rating] = [];
        for((id, rating) in ratingsMap.entries()) {
            ratingArray := Array.append<Types.Rating>(ratingArray, [rating]);
        };

        return ratingArray
    };

    // shared functions
    // returns User profile is successful
    // returns null if username || caller already exist
    public shared (msg) func registerUser(username: Text): async ?User {
        let callerExists = usersMap.get(msg.caller);
        if (callerExists == null){

            let usernameExists = usernamesHashMap.get(username);
            if (usernameExists == null){
                let newUser =  {
                id = msg.caller;
                username = username;
                };
                usersMap.put(msg.caller, newUser);
                return newUser
            };

        };

        return null;
    };

    public shared query (msg) func lookupUser() : async ?Types.User {
        findUser(msg.caller);
    };

    public shared query (msg) func getAllContents() : async [Types.Content] {
        findAllContents();
    };

    public shared query (msg) func getAllComments(contentId: Types.ContentId): async [Types.Comment] {
        findAllComments(contentId);
    };

    public shared query (msg) func getAllRatings(commentId: Types.CommentId): async [Types.Rating] {
        findAllRatings(commentId);
    };

    public shared query (msg) func getFeed(): async [Types.Feed] {
        var feedArray : [Types.Feed] = [];

        let contents = findAllContents();
        for (content in contents.vals()){
            let comments = findAllComments(content.id);
            var ratings2d: [[Types.Rating]] = [];
            for (comment in comments.vals()) {
                let commentRatings = findAllRatings(comment.id);
                ratings2d := Array.append<[Types.Rating]>(ratings2d, [commentRatings]);
            };
            let feedItem: Types.Feed = {
                contentId = content.id;
                content = content;
                comments = comments;
                ratings2d = ratings2d;
            };
            feedArray := Array.append<Types.Feed>(feedArray, [feedItem]);
        };

        return feedArray
    };

    public shared (msg) func flagContent(postId: Text, burntTokens: Int) : async Content {
        // check whether content has already been flagged or not 

        // change it to Reject to make the error more clear
        let user = Option.unwrap(findUser(msg.caller));

        let contentId : Text = Nat.toText(contentIdCount);
        contentIdCount += 1;

        // content identification
        let contentIdentification: Types.ContentIdentification = {
            postId = postId;
        };

        // new content 
        let newContent: Types.Content = {
            id = contentId;
            contentIdentification = contentIdentification;
            createdAt = Time.now();
            user = user;
            burntTokens = burntTokens;
        };
        
        // insert flagged content into contents hashmap
        contentsMap.put(contentId, newContent);

        // insert content comment map
        contentCommentsMap.put(contentId, HashMap.HashMap<Types.CommentId, Types.Comment>(1, Text.equal, Text.hash));

        return newContent
    };

    public shared (msg) func addComment(contentId: Types.ContentId, comment: Text) : async Comment {
        // check user
        let user = Option.unwrap(findUser(msg.caller));
        
        // check comment map exists
        var comments = Option.unwrap(contentCommentsMap.get(contentId));

        // a new comment
        let newCommentId: Text = Nat.toText(commentIdCount);
        commentIdCount += 1;
        let newComment: Types.Comment = {
            id = newCommentId;
            contentId = contentId;
            text = comment;
            user = user;
            createdAt = Time.now();
        };
        comments.put(newCommentId, newComment);

        // insert commment rating map
        commentRatingsMap.put(newCommentId, HashMap.HashMap<Types.RatingId, Types.Rating>(1, Text.equal, Text.hash));

        return newComment;
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


    func isEqUserId(x: Types.UserId, y: Types.UserId): Bool {
        x == y;
    };

};
