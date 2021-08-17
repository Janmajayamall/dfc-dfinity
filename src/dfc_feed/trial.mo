
import Nat "mo:base/Nat";

actor {
    public type Timestamp = Int;
    public type ID = Text;

    type Rating = {
        id: ID;
        userId: UserId;
        rating: Bool;
    }

    type Commment = {
        id: ID;
        text: Text;
        userId: UserId;
        username: Text;
        // ratings: HashMap.HashMap<ID, Comment>(1, Text.equal, Text.hash);
    }   

    type Content = {
        id: ID;
        url: Text;
        // comments: HashMap.HashMap<ID, Comment>(1, Text.equal, Text.hash);
        time: Timestamp;
        tokensBurnt: Nat;
    }

    let contentMap = HashMap.HashMap<ID, Content>(1, Text.equal, Text.hash);
    let commentMap = HashMap.HashMap<ID, Comment>(1, Text.equal, Text.hash);
    let contentCommentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<ID, Comment>>(1, Text.equal, Text.hash);
    let commentRatingMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<ID, Rating>>(1, Text.equal, Text.hash);
    
    var contentIdCount: Nat = 0;
    var commentIdCount: Nat = 0;

    func flagNewContent(url: Text) {
        let contentId = Nat.toText(contentIdCount);
        contentIdCount += 1;

        let newContent: Content = {
            id = contentId;
            url = url; 
            time = Time.now();
            tokensBurnt = 0;
        }
        contenMap.put(contentId, newContent);

        contentCommentMap.put(contentId, HashMap.HashMap<ID, Comment>(1, Text.equal, Text.hash));
    }

    public shared (msg) func addComment(commentText: Text, contentId: Text): async Comment {
        // change option.unwrap
        let contentComments = Option.unwrap(contentCommentMap.get(contentId));

        // get user's profile & username


        let commentId = Nat.toText(commentIdCount);
        commentIdCount += 1;

        let newComment: Comment = {
            id = commentId;
            text = commentText;
            userId = msg.caller;
            username = "This is fake";
        };
        contentComments.put(commentId, newComment);
        
        return newComment;
    }

    // same thing for rating
}