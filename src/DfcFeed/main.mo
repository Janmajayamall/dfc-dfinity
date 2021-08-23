import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Types "./../Shared/types";
import DfcData "canister:DfcData";
import 

actor {
    let flaggedContentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, [{
        positiveRatings: HashMap.HashMap<Types.UserId, Bool>;
        negativeRatings: HashMap.HashMap<Types.UserId, Bool>;
    }]>>(1, Nat.equal, Hash.hash);
    let needsHelpFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>();
    let satisfiedFeedMap = HashMap.HashMap<Types.ContentId, Types.Content>();

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
                switch(flaggedContentMap.get(newComment.contentId)){
                    case(?commentMap){
                        switch(commentMap.get(newComment.commentId)){
                            case null {
                                commentMap.put([{
                                    positiveRatings = HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash);
                                    negativeRatings = HashMap.HashMap<Types.UserId, Bool>(1, Principal.equal, Principal.hash);
                                }]);
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
                switch(flaggedContentMap.get(ratingUpdate.contentId)){
                    case (?commentMap){
                        switch(commentMap.get(ratingUpdate.commentId)){
                            case(?ratingMap){
                                if (ratingUpdate.ratingObj.rating == true){
                                    ratingMap.positiveRatings.put(ratingUpdate.ratingObj.userId, true);
                                    ratingMap.negativeRatings.delete(ratingUpdate.ratingObj.userId);
                                };
                                else {
                                    ratingMap.negativeRatings.put(ratingUpdate.ratingObj.userId, true);
                                    ratingMap.positiveRatings.delete(ratingUpdate.ratingObj.userId);
                                };
                            };
                            case _ {};
                        };
                    };
                    case _ {};
                };
            };
            case _ {};
        };
    };

    public func callbackForContentEvent(contentEvent: Types.SubscriptionContentEvent){
        switch(contentEvent){
            case(#didFlagNewContent(newContent)){
                switch(flaggedContentMap.get(newContent.contentId)){
                    case null {
                        flaggedContentMap.put(
                            HashMap.HashMap<Types.CommentId, [{
                                positiveRatings: HashMap.HashMap<Types.UserId, Bool>;
                                negativeRatings: HashMap.HashMap<Types.UserId, Bool>;
                            }]>(1, Nat.equal, Hash.hash);
                        );

                        // add to needs help feed


                    };
                    case _ {

                    };
                };
            }; 
        };
    };
}

1. Keep cache of content being flagged
2. Keep cache of comments & respective ratings they have received {to figure out whether any of them is effective}
3. Keep two maps, one for needs more help feed & one for satisfied feed.
4. Add every new content to needs more help feed initially
5. At regular intervals scan the two maps and do the following - 
    a. Check whether content in needs more help feed can be promoted to satisfied feed
    b. Check whether content in satisfied feed needs to be demoted
