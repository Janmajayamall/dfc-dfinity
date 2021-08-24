import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Types "./../Shared/types";
import DfcData "canister:DfcData";

actor {
    let flaggedContentMap = HashMap.HashMap<Types.ContentId, [Types.CommentId]>(1, Nat.equal, Hash.hash);
    let flaggedContentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, {
        positiveRatings: HashMap.HashMap<Types.UserId, Bool>;
        negativeRatings: HashMap.HashMap<Types.UserId, Bool>;
    }>>(1, Nat.equal, Hash.hash);
    let commentPositiveRatingsMap = HashMap.HashMap<Types.CommentId, [Types.UserId]>(1, Nat.equal, Hash.hash);
    let commentNegativeRatingsMap = HashMap.HashMap<Types.CommentId, [Types.UserId]>(1, Nat.equal, Hash.hash);
    
    let needsHelpFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Nat.equal, Hash.hash);
    let satisfiedFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Nat.equal, Hash.hash);

    public func init() {
        DfcData.subscribeRatingEvents({callback = callbackForRatingEvent});
        DfcData.subscribeCommentEvents({callback = callbackForCommentEvent});
        DfcData.subscribeContentEvents({callback = callbackForContentEvent});
    };

    // public func scanNeedsHelpFeed() {

    // }

    public func callbackForCommentEvent(commentEvent: Types.SubscriptionCommentEvent){
        switch(commentEvent){
            case(#didAddComment(newComment)){
                Debug.print("Dfc feed comment event");
                Debug.print(Nat.toText(newComment.commentId));
                Debug.print(Nat.toText(newComment.contentId));
                switch(flaggedContentMap.get(newComment.contentId)){
                    case(?commentIdArray){
                        var newArray: [Types.CommentId] = commentIdArray;
                        
                        
                        switch(commentMap.get(newComment.commentId)){
                            case null {
                                commentMap.put(newComment.commentId, {
                                    positiveRatings = HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash);
                                    negativeRatings = HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash);
                                });
                            };
                            case _ {};
                        };
                    };
                    case _ {};
                }
            };
        };
    };

    public func callbackForRatingEvent(ratingEvent: Types.SubscriptionRatingEvent){
        switch(ratingEvent){
            case(#didUpdateRating(ratingUpdate)){
                Debug.print("Dfc feed rating event");
                Debug.print(Nat.toText(ratingUpdate.commentId));
                Debug.print(Nat.toText(ratingUpdate.contentId));
                switch(flaggedContentMap.get(ratingUpdate.contentId)){
                    case (?commentMap){
                        switch(commentMap.get(ratingUpdate.commentId)){
                            case(?ratingMap){
                                Debug.print("reached here");
                                var positiveRatings = ratingMap.positiveRatings;
                                var negativeRatings = ratingMap.negativeRatings;
                                if (ratingUpdate.ratingObj.rating == true){
                                    Debug.print("reached here true");
                                    positiveRatings.put(ratingUpdate.ratingObj.userId, true);
                                    negativeRatings.delete(ratingUpdate.ratingObj.userId);                                
                                }
                                else {
                                    Debug.print("reached here false");
                                    negativeRatings.put(ratingUpdate.ratingObj.userId, true);
                                    positiveRatings.delete(ratingUpdate.ratingObj.userId);                                    
                                };
                                commentMap.put(ratingUpdate.commentId, {
                                    positiveRatings = positiveRatings;
                                    negativeRatings = negativeRatings;
                                });
                            };
                            case _ {};
                        };
                    };
                    case _ {};
                };
            };
        };
    };

    public func callbackForContentEvent(contentEvent: Types.SubscriptionContentEvent){
        switch(contentEvent){
            case(#didFlagNewContent(newContent)){
                Debug.print("Dfc feed content event");
                Debug.print(Nat.toText(newContent.contentId));
                switch(flaggedContentMap.get(newContent.contentId)){
                    case null {
                        flaggedContentMap.put(
                            newContent.contentId,
                            []
                        );
                        // TODO add to needs help feed
                    };
                    case _ {

                    };
                };
            }; 
        };
    };

    public shared query func testFlaggedContentMap(): async [{contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}] {
        var returnArray: [{contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}] = [];
        for ((contentId, commentMap) in flaggedContentMap.entries()){
            var commentsArray: [{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}] = [];
            for ((commentId, ratingsObj) in commentMap.entries()){
                var positiveRatingsArray: [Types.UserId] = [];
                var negativeRatingsArray: [Types.UserId] = [];
                Debug.print("Start -----");
                Debug.print(Nat.toText(ratingsObj.positiveRatings.size()));
                Debug.print(Nat.toText(ratingsObj.negativeRatings.size()));
                for ((userId, _) in ratingsObj.positiveRatings.entries()){
                    Debug.print(Principal.toText(userId));
                    positiveRatingsArray := Array.append<Types.UserId>(positiveRatingsArray, [userId]);
                };
                for ((userId, _) in ratingsObj.negativeRatings.entries()){
                    Debug.print(Principal.toText(userId));
                    negativeRatingsArray := Array.append<Types.UserId>(negativeRatingsArray, [userId]);
                };
                Debug.print("End -----");
                commentsArray := Array.append<
                    {commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}
                >(
                    commentsArray,
                    [{
                        commentId = commentId;
                        ratings = {
                            positiveRatings = positiveRatingsArray;
                            negativeRatings = negativeRatingsArray;
                        };
                    }]
                );
            };
            returnArray := Array.append<
                {contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}
            >(
                returnArray,
                [
                    {
                        contentId = contentId;
                        comments = commentsArray;
                    }
                ]
            );
        };
        return returnArray;
    };
}

// 1. Keep cache of content being flagged
// 2. Keep cache of comments & respective ratings they have received {to figure out whether any of them is effective}
// 3. Keep two maps, one for needs more help feed & one for satisfied feed.
// 4. Add every new content to needs more help feed initially
// 5. At regular intervals scan the two maps and do the following - 
//     a. Check whether content in needs more help feed can be promoted to satisfied feed
//     b. Check whether content in satisfied feed needs to be demoted
