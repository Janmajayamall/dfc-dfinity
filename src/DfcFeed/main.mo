import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Order "mo:base/Order";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Types "./../Shared/types";
import DfcData "canister:DfcData";
import DfcReputationScorer "canister:DfcReputationScorer";

actor {
    let flaggedContentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, Bool>>(1, Nat.equal, Hash.hash);
    let commentRatingsMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<Types.UserId, Bool>>(1, Nat.equal, Hash.hash);
    
    let needsHelpFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Nat.equal, Hash.hash);
    let satisfiedFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Nat.equal, Hash.hash);

    var latestLeadershipBoardMap = HashMap.HashMap<Types.UserId, Types.ReputationScore>(1, Principal.equal, Principal.hash);

    func _helperDescendingOrder(value1: Float, value2: Float): Order.Order {
        if (value1 >= value2){
            return #less;
        }else {
            return #greater;
        };
    };

    func _isValidForSatisfiedFeedPromotion(contentId: Types.ContentId): Bool {
        switch(flaggedContentMap.get(contentId)){
            case(?commentMap){
                label commentChecker for ((commentId, _) in commentMap.entries()){
                    switch(commentRatingsMap.get(commentId)){
                        case (?ratingMap){
                            if (ratingMap.size() < 3){
                                continue commentChecker;
                            };

                            var positiveRatings: [Float] = [];
                            var negativeRatings: [Float] = [];
                            for ((userId, rating) in ratingMap.entries()){
                                switch(latestLeadershipBoardMap.get(userId)){
                                    case (?reputationScoreObj){
                                        if(rating == true){
                                            positiveRatings := Array.append<Float>(positiveRatings, [reputationScoreObj.reputationScore]);
                                        }else{
                                            negativeRatings := Array.append<Float>(negativeRatings, [reputationScoreObj.reputationScore]);
                                        };
                                    };
                                    case _ {};
                                };
                            };
                            positiveRatings := Array.sort(positiveRatings, _helperDescendingOrder);
                            negativeRatings := Array.sort(negativeRatings, _helperDescendingOrder);

                            if(positiveRatings.size() >= 3
                                and
                                ((positiveRatings[0]+positiveRatings[1]+positiveRatings[2])/3) >= 1
                            ){
                                return true;
                            }else if (negativeRatings.size() >= 3
                                and
                                ((negativeRatings[0]+negativeRatings[1]+negativeRatings[2])/3) >= 1
                            ){
                                return true;
                            }else {
                                continue commentChecker;
                            };
                        };
                        case _ {continue commentChecker;};
                    };
                };
                return false;
            };
            case _ {
                return false;
            };
        };
    };

    public func init() {
        DfcData.subscribeRatingEvents({callback = callbackForRatingEvent});
        DfcData.subscribeCommentEvents({callback = callbackForCommentEvent});
        DfcData.subscribeContentEvents({callback = callbackForContentEvent});
        DfcReputationScorer.subscribeReputationScoreEvents({callback = callbackForReputationScoreEvent});
    };

    public func scanNeedsHelpFeed() {
        var promotedContentIds: [Types.ContentId] = [];
        for((contentId, content) in needsHelpFeedMap.entries()){
            if (_isValidForSatisfiedFeedPromotion(contentId)){
                promotedContentIds := Array.append<Types.ContentId>(promotedContentIds, [contentId]);
            };
        };

        for(contentId in promotedContentIds.vals()){
            needsHelpFeedMap.delete(contentId);
        };
    };

    public func callbackForCommentEvent(commentEvent: Types.SubscriptionCommentEvent){
        switch(commentEvent){
            case(#didAddComment(newComment)){
                switch(flaggedContentMap.get(newComment.contentId)){
                    case(?commentMap){
                        switch(commentMap.get(newComment.commentId)){
                            case null {
                                commentMap.put(newComment.commentId, true);
                                commentRatingsMap.put(
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
            };
        };
    };

    public func callbackForContentEvent(contentEvent: Types.SubscriptionContentEvent){
        switch(contentEvent){
            case(#didFlagNewContent(newContent)){
                switch(flaggedContentMap.get(newContent.contentId)){
                    case null {
                        flaggedContentMap.put(
                            newContent.contentId,
                            HashMap.HashMap<Types.CommentId, Bool>(1, Nat.equal, Hash.hash)
                        );
                        needsHelpFeedMap.put(newContent.contentId, newContent.content);
                    };
                    case _ {

                    };
                };
            }; 
        };
    };

    public func callbackForReputationScoreEvent(reputationScoreEvent: Types.SubscriptionReputationScoreEvent){
        switch(reputationScoreEvent){
            case (#didUpdateLeadershipBoard(leadershipBoard)){
                let newLeadershipBoardMap = HashMap.HashMap<Types.UserId, Types.ReputationScore>(1, Principal.equal, Principal.hash);
                for(value in leadershipBoard.vals()){
                    newLeadershipBoardMap.put(value.userId, value.reputationScoreObj);
                };
                latestLeadershipBoardMap := newLeadershipBoardMap;
            };
        };
    };
    
    // test functions for __Candid_UI
    public shared query func testFlaggedContentMap(): async [{contentId: Types.ContentId; comments:[{commentId: Types.CommentId; ratings:{positiveRatings:[Types.UserId];negativeRatings:[Types.UserId]}}]}] {

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

// Framework for writing functions
// 1. Keep cache of content being flagged
// 2. Keep cache of comments & respective ratings they have received {to figure out whether any of them is effective}
// 3. Keep two maps, one for needs more help feed & one for satisfied feed.
// 4. Add every new content to needs more help feed initially
// 5. At regular intervals scan the two maps and do the following - 
//     a. Check whether content in needs more help feed can be promoted to satisfied feed
//     b. Check whether content in satisfied feed needs to be demoted

// Design for classifying content under needsHelpFeedMap or satisfiedFeedMap
// 1. Condition for classifying a content as SATISFIED -
//     3 ratings in same direction on a comment with average 
//     author score of 0.5
// 2. At regular intervals scan for flagged content in Needs Help Feed & 
//     promote them to SATISFIED FEED according to the condition in (1).
// 3. Not yet decided - Should it be allowed to demote content in SATISFIED FEED
//     to NEEDS HELP FEED? 
//     I think yes, since users might withdraw their rating in the future (probably 
//     they learnt something new - happens a lot while commenting on a subjective matter like 
//     Covid vaccine). Given that users withdraw, others should be given the opportunity to 
//     provide their commentary & earn rewards for that. 
//     Plus, remember that users have little motivation to withdraw their comments if their comment
//     has received good ratings from good authors (which is why the content was promoted to 
//     SATISFIED FEED in the first place) because doing so will impact their Reputation Score negatively.
