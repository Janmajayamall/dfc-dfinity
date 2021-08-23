import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Option "mo:base/Option";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Array "mo:base/Array";
import DfcUsers "canister:DfcUsers";
import Types "./../Shared/types";

actor DfcData {

    let contentMap = HashMap.HashMap<Types.ContentId, Types.Content>(1, Nat.equal, Hash.hash);
    let contentCommentMap = HashMap.HashMap<Types.ContentId, HashMap.HashMap<Types.CommentId, Types.Comment>>(1, Nat.equal, Hash.hash);
    let commentRatingMap = HashMap.HashMap<Types.CommentId, HashMap.HashMap<Types.UserId, Types.Rating>>(1, Nat.equal, Hash.hash);

    let userDataEventSubscribers = HashMap.HashMap<Types.UserId, Types.SubscribeUserDataEventsData>(1, Principal.equal, Principal.hash);
    var ratingEventSubscribers: [Types.SubscribeRatingEventsData] = [];
    var contentEventSubscribers: [Types.SubscribeContentEventsData] = [];
    var commentEventSubscribers: [Types.SubscribeCommentEventsData] = [];
    
    var contentIdCount: Nat = 0;
    var commentIdCount: Nat = 0;

    func _getCommentOfContentId(contentId: Types.ContentId, commentId: Types.CommentId): Result.Result<Types.Comment, Types.IDError> {
        switch(contentCommentMap.get(contentId)){
            case (?commentMap){
                switch(commentMap.get(commentId)){
                    case (?comment){
                        #ok(comment);
                    };
                    case _ {
                        #err(#idDoesNotExists(commentId));
                    };
                };
            };
            case _ {
                #err(#idDoesNotExists(contentId));
            };
        };
    };

    func _getCommentRatingArray(commentId: Types.CommentId): Result.Result<[Types.Rating], Types.CommentId> {
        switch(commentRatingMap.get(commentId)){
            case (?ratingMap){
                var ratings: [Types.Rating] = [];
                for((userId, rating) in ratingMap.entries()){
                    ratings := Array.append<Types.Rating>(ratings, [rating]);
                };
                #ok(ratings);
            };
            case _ {
                #err(commentId);
            };
        };
    };

    func _getContentCommentDetailsArray(contentId: Types.ContentId): Result.Result<[Types.CommentDetails], Types.ContentId> {
        switch(contentCommentMap.get(contentId)){
            case (?commentMap){
                var commentDetailsArray: [Types.CommentDetails] = [];
                for ((commentId, comment) in commentMap.entries()){
                    // ratings array
                    var ratings: [Types.Rating] = [];
                    switch(_getCommentRatingArray(commentId)){
                        case (#ok(ratingArray)){
                            ratings := ratingArray;
                        };
                        case _ {
                            ratings := [];
                        };
                    };

                    let commentDetails: Types.CommentDetails = {
                        id = comment.id;
                        text = comment.text;
                        userId = comment.userId;
                        username = comment.username;
                        ratings = ratings;
                        contentId = contentId;
                    };
                    commentDetailsArray := Array.append<Types.CommentDetails>(commentDetailsArray, [commentDetails]);
                };
                return #ok(commentDetailsArray);
            };
            case _ {
                return #err(contentId)
            };
        }
    };

    func _getContentDetails(contentId: Types.ContentId): Result.Result<Types.ContentDetails, Types.ContentId> { 
        switch(contentMap.get(contentId), _getContentCommentDetailsArray(contentId)){
            case (?content, #ok(commentDetailsArray)){
                let contentDetails: Types.ContentDetails = {
                    id = content.id;
                    url = content.url;
                    time = content.time;
                    tokensBurnt = content.tokensBurnt;
                    comments = commentDetailsArray; 
                };
                #ok(contentDetails);
            };
            case _ {
                #err(contentId);
            };
        };
    };

    // public query functions
    public shared query func getContentDetails(contentId: Types.ContentId): async Result.Result<Types.ContentDetails, Types.ContentId> {
        return _getContentDetails(contentId);
    };

    public shared query func getContentDetailsInBatch(contentIds: [Types.ContentId]): async [Types.ContentDetails] {
        var contentDetailsArray: [Types.ContentDetails] = [];
        for (contentId in contentIds.vals()){
            switch(_getContentDetails(contentId)){
                case (#ok(contentDetails)){
                    contentDetailsArray := Array.append<Types.ContentDetails>(contentDetailsArray, [contentDetails]); 
                };
                case _ {

                };  
            };
        };
        return contentDetailsArray;
    };

    // public update functions
    public shared (msg) func flagNewContent(url: Text): async Types.Content {
        // check user's token balance

        let contentId = contentIdCount;
        contentIdCount += 1;

        let newContent: Types.Content = {
            id = contentId;
            url = url; 
            time = Time.now();
            tokensBurnt = 0;
        };
        contentMap.put(contentId, newContent);
        contentCommentMap.put(contentId, HashMap.HashMap<Types.CommentId, Types.Comment>(1, Nat.equal, Hash.hash));

        // publish content event
        publishContentEvent(#didFlagNewContent({contentId = newContent.id; content = newContent}));

        return newContent;
    };

    public shared (msg) func addComment(commentText: Text, contentId: Types.ContentId): async Result.Result<Types.Comment, Types.NewCommentError> {
        switch (contentCommentMap.get(contentId), await DfcUsers.getUserProfile(msg.caller)){
            case (?contentComments, #ok(userProfile)){
                let commentId = commentIdCount;
                commentIdCount += 1;

                let newComment: Types.Comment = {
                    id = commentId;
                    text = commentText;
                    userId = msg.caller;
                    username = userProfile.username;
                    contentId = contentId;
                };
                contentComments.put(commentId, newComment);
                commentRatingMap.put(commentId, HashMap.HashMap<Types.UserId, Types.Rating>(1, Principal.equal, Principal.hash));

                // publish didAddComment event for user data event
                publishUserDataEvent([msg.caller], #didAddComment({commentAuthorUserId = msg.caller; comment = newComment}));
                // publish didAddComment event for comment event
                publishCommentEvent(#didAddComment({commentId = newComment.id; contentId = newComment.contentId; comment = newComment}));
                
                return #ok(newComment);
            };
            case (_, #err(#profileDoesNotExists(userPrincipal))){
                return #err(#profileDoesNotExists(userPrincipal));
            };
            case (null, _) {
                return #err(#idDoesNotExists(contentId));
            };
            case (_, _){
                return #err(#unknown);
            };
        };
    };

    public shared (msg) func rateComment(contentId: Types.ContentId, commentId: Types.CommentId, rating: Bool): async Result.Result<Types.Rating, Types.CommentId> {
        switch (commentRatingMap.get(commentId), _getCommentOfContentId(contentId, commentId)) {
            case (?commentRatings, #ok(commentObj)){
                var validRating: Bool = false;
                if(commentRatings.size() <= 5){
                    validRating := true;
                };
                let newRating: Types.Rating = {
                    userId = msg.caller;
                    rating = rating;
                    commentId = commentId;
                    validRating = validRating;
                };

                // publish rating event
                switch(commentRatings.get(msg.caller)){
                    case (?existingRating){
                        if(existingRating.rating != newRating.rating){
                            if(newRating.rating == true){
                                publishRatingEvent(#didUpdateRating({
                                    commentId = commentId;
                                    contentId = contentId;
                                    ratingObj = newRating;
                                    positiveDelta = 1;
                                    negativeDelta = -1;
                                }));
                            }
                            else {
                                publishRatingEvent(#didUpdateRating({
                                    commentId = commentId;
                                    contentId = contentId;
                                    ratingObj = newRating;
                                    positiveDelta = -1;
                                    negativeDelta = 1;
                                }));
                            };
                        };
                    };
                    case _ {
                        if (newRating.rating == true){
                            publishRatingEvent(#didUpdateRating({
                                commentId = commentId;
                                contentId = contentId;
                                ratingObj = newRating;
                                positiveDelta = 1;
                                negativeDelta = 0;
                            }));
                        }
                        else {
                            publishRatingEvent(#didUpdateRating({
                                commentId = commentId;
                                contentId = contentId;
                                ratingObj = newRating;
                                positiveDelta = 0;
                                negativeDelta = 1;
                            }));
                        }                
                    };
                };

                // update rating
                commentRatings.put(msg.caller, newRating);

                // publish didReceiveRatingOnThyComment & didAddNewRating for user data event
                publishUserDataEvent([commentObj.userId], #didReceiveRatingOnThyComment({commentAuthorUserId = commentObj.userId; raterUserId = msg.caller; rating = newRating}));
                publishUserDataEvent([msg.caller], #didAddNewRating({raterUserId = msg.caller; rating = newRating}));

                return #ok(newRating);
            };
            case _ {
                return #err(commentId);
            };
        };
    };

    public shared func subscribeUserDataEvents(data: Types.SubscribeUserDataEventsData) {
        userDataEventSubscribers.put(data.userId, data);
    };

    public shared func subscribeRatingEvents(data: Types.SubscribeRatingEventsData) {
        ratingEventSubscribers := Array.append<Types.SubscribeRatingEventsData>(ratingEventSubscribers, [data]);
    };

    public shared func subscribeContentEvents(data: Types.SubscribeContentEventsData) {
        contentEventSubscribers := Array.append<Types.SubscribeContentEventsData>(contentEventSubscribers, [data]);
    };

    public shared func subscribeCommentEvents(data: Types.SubscribeCommentEventsData) {
        commentEventSubscribers := Array.append<Types.SubscribeCommentEventsData>(commentEventSubscribers, [data]);
    };

    public shared func publishUserDataEvent(userIds: [Types.UserId], commentEvent: Types.SubscriptionUserDataEvent) {
        for (u in userIds.vals()){
            switch(userDataEventSubscribers.get(u)){
                case (?{callback}) {
                    callback(commentEvent);
                };
                case _ {
                    
                };
            };
        };
    };

    public shared func publishRatingEvent(ratingEvent: Types.SubscriptionRatingEvent){
        for (s in ratingEventSubscribers.vals()){
            s.callback(ratingEvent);
        };
    };

    public shared func publishContentEvent(contentEvent: Types.SubscriptionContentEvent){
        for (s in contentEventSubscribers.vals()){
            s.callback(contentEvent);
        };
    };

    public shared func publishCommentEvent(commentEvent: Types.SubscriptionCommentEvent){
        for (s in commentEventSubscribers.vals()){
            s.callback(commentEvent);
        };
    };

    // test functions for CandidUI
    public shared (msg) func getMyPrincipal(): async Principal {
        return msg.caller;
    };
}
