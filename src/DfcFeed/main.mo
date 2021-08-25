import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Types "./../Shared/types";
import DfcData "canister:DfcData";

actor {
    let flaggedContentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, Bool>>(1, Nat.equal, Hash.hash);
    // let flaggedContentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, {
    //     positiveRatings: HashMap.HashMap<Types.UserId, Bool>;
    //     negativeRatings: HashMap.HashMap<Types.UserId, Bool>;
    // }>>(1, Nat.equal, Hash.hash);
    let commentRatingsMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<Types.UserId, Bool>>(1, Nat.equal, Hash.hash);
    let commentPositiveRatingsMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<Types.UserId, Bool>>(1, Nat.equal, Hash.hash);
    let commentNegativeRatingsMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<Types.UserId, Bool>>(1, Nat.equal, Hash.hash);
    
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
                    case(?commentMap){
                        switch(commentMap.get(newComment.commentId)){
                            case null {
                                commentMap.put(newComment.commentId, true);
                                commentRatingsMap.put(
                                    newComment.commentId,
                                    HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash)
                                );
                                commentPositiveRatingsMap.put(
                                    newComment.commentId,
                                    HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash)
                                );
                                commentNegativeRatingsMap.put(
                                    newComment.commentId,
                                    HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash)
                                );
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
                Debug.print(Nat.toText(ratingUpdate.commentId));
                Debug.print(Nat.toText(ratingUpdate.contentId));
                switch(commentRatingsMap.get(ratingUpdate.commentId)){
                    case(?ratingMap){
                        if(ratingUpdate.ratingObj.rating == true){
                            ratingMap.put(ratingUpdate.ratingObj.userId, true);
                        }else {
                            ratingMap.put(ratingUpdate.ratingObj.userId, false);
                        };
                    };
                    case _ {};
                };

                // switch(commentPositiveRatingsMap.get(ratingUpdate.commentId), commentNegativeRatingsMap.get(ratingUpdate.commentId)){
                //     case (?positiveRatingMap, ?negativeRatingMap){
                //         Debug.print("here1");
                //         // switch(positiveRatingMap.put(ratingUpdate.ratingObj.userId, true)){
                //         //     case (?exists){
                //         //         positiveRatingMap
                //         //     };
                //         // };
                //         if (ratingUpdate.ratingObj.rating == true){
                //             Debug.print("here2");
                //             // do {
                //             //     negativeRatingMap.put(ratingUpdate.ratingObj.userId, true);
                //             // };
                //             positiveRatingMap.put(ratingUpdate.ratingObj.userId, true);
                //             negativeRatingMap.delete(ratingUpdate.ratingObj.userId);
                //             // Debug.print(Principal.toText(ratingUpdate.ratingObj.userId));
                            
                //             Debug.print(Nat.toText(positiveRatingMap.size()));
                //             Debug.print(Nat.toText(negativeRatingMap.size()));
                //         }else {
                //             negativeRatingMap.put(ratingUpdate.ratingObj.userId, true);
                //             // positiveRatingMap.delete(ratingUpdate.ratingObj.userId);
                //         };                        
                //     };
                //     case _ {};
                // };
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
                            HashMap.HashMap<Types.CommentId, Bool>(1, Nat.equal, Hash.hash)
                        );
                        // TODO add to needs help feed
                    };
                    case _ {

                    };
                };
            }; 
        };
    };

    public shared query func getPositiveRating(): async [{commentId: Types.CommentId; ratings:[Types.UserId]}] {
        var comments: [{commentId: Types.CommentId; ratings:[Types.UserId]}] = [];
        for ((commentId, ratingMap) in commentPositiveRatingsMap.entries()){
            var ratings: [Types.UserId] = [];
            for ((userId, _) in ratingMap.entries()){
                ratings := Array.append<Types.UserId>(
                    ratings,
                    [userId]
                );  
            };
            comments := Array.append<{commentId: Types.CommentId; ratings:[Types.UserId]}>(
                comments,
                [{
                    commentId = commentId;
                    ratings = ratings;
                }]
            );
        };
        return comments;
    };

    public shared query func testFlaggedContentMap(): async [{contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}] {
        Debug.print("Start -------");
        var returnArray: [{contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}] = [];
        for ((contentId, commentMap) in flaggedContentMap.entries()){
            var commentsArray: [{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}] = [];
            for ((commentId, _) in commentMap.entries()){
                var positiveRatingsArray: [Types.UserId] = [];
                var negativeRatingsArray: [Types.UserId] = [];
                switch(commentRatingsMap.get(commentId)){
                    case(?ratingMap){
                        for((userId, ratingVal) in ratingMap.entries()){
                            if(ratingVal == true){
                                positiveRatingsArray := Array.append<Types.UserId>(
                                    positiveRatingsArray,
                                    [userId]
                                );
                            }else{
                                negativeRatingsArray := Array.append<Types.UserId>(
                                    negativeRatingsArray,
                                    [userId]
                                );
                            };
                        };
                    };
                    case _ {};
                };
                // switch(commentPositiveRatingsMap.get(commentId), commentNegativeRatingsMap.get(commentId)){
                //     case (?positiveRatingMap, ?negativeRatingMap){
                //         Debug.print(Nat.toText(positiveRatingMap.size()));
                //         Debug.print(Nat.toText(negativeRatingMap.size()));
                //         for((userId, _) in positiveRatingMap.entries()) {
                //             Debug.print(Principal.toText(userId));
                //             positiveRatingsArray := Array.append<Types.UserId>(
                //                 positiveRatingsArray,
                //                 [userId]
                //             );
                //         };
                //         for((userId, _) in negativeRatingMap.entries()){
                //             Debug.print(Principal.toText(userId));
                //             negativeRatingsArray := Array.append<Types.UserId>(
                //                 negativeRatingsArray,
                //                 [userId]
                //             );
                //         };
                //     };
                //     case _ {};
                // };
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
        Debug.print("End -------");
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
