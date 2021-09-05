import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Types "./../Shared/types";
import DfcData "canister:DfcData";

actor class DfcToken {

    private let _balances = HashMap.HashMap<Types.CommentId, Types.Comment>(1, Nat.equal, Hash.hash);
    private let _allowances = HashMap.HashMap<Types.UserId, HashMap.HashMap<Types.CommentId, Types.Rating>>(1, Principal.equal, Principal.hash);
    private var _totalSupply: Nat = 100000000000000;

    private var _name: String = "DfactCheck";
    private var _symbol: String = "DFC";

    public shared (msg) func transfer(){

    };

    public shared (msg) func transferFrom(){}

    public shared (msg) func increaseAllowance(){}

    public shared (msg) func decreaseAllowance(){}


    public shared func init(): async () {
        Debug.print(Principal.toText(owner));
        Debug.print(Principal.toText(userId));
        DfcData.subscribeUserDataEvents({
            userId = userId;
            callback = callbackForUserDataEvent;   
        });
    };

    public shared func getReceivedRatingsMetadata(): async [Types.ReceivedRatingsFromUserMetadata] {
        var metadataArray: [Types.ReceivedRatingsFromUserMetadata] = [];
        for ((userId, commentRatingMap) in receivedRatings.entries()) {
            var positiveRatings: Float = 0;
            var negativeRatings: Float = 0;
            var totalRatings: Float = 0;    
            for ((commentId, ratingObj) in commentRatingMap.entries()){
                if (ratingObj.rating == true){
                    positiveRatings += 1;
                }
                else {
                    negativeRatings += 1;
                };  
                totalRatings += 1;
            };
            metadataArray := Array.append<Types.ReceivedRatingsFromUserMetadata>(metadataArray, [{
                userId = userId;
                positiveRatings = positiveRatings;
                negativeRatings = negativeRatings;
                totalRatings = totalRatings; 
            }]);
        };
        return metadataArray;
    };

    // public shared func calculateAuthorScore(authorScoresMap: Types.AuthorScoresMap): async Float {
    //     var numerator: Float = 2;
    //     var denominator: Float = 6;

    //     for ((userId, ratingsMap) in receivedRatings.entries()){
    //         switch (_calculateAverageReceivedRatingByUserId(userId), authorScoresMap.get(userId)){
    //             case (?averageRatingByUser, ?userAuthorScore){
    //                 let weightedAverage = userAuthorScore * averageRatingByUser;
                    
    //                 numerator += weightedAverage;
    //                 denominator += userAuthorScore;
    //             };
    //             case _ {

    //             };
    //         };
    //     };

    //     let authorScore: Float = 1.5 * (numerator/denominator) - 0.5;
    //     return authorScore;
    // };

    public shared func getUserValidRatings(): async [Types.Rating] {
        var validRatings: [Types.Rating] = [];
        for ((commentId, ratingValue) in userRatings.entries()){
            if(ratingValue.validRating == true){
                validRatings := Array.append<Types.Rating>(validRatings, [ratingValue]);
            };
        };
        return validRatings;
    };

    public shared func callbackForUserDataEvent(commentEvent: Types.SubscriptionUserDataEvent) {
        switch(commentEvent){
            case (#didAddComment({commentAuthorUserId; comment})){
                assert(commentAuthorUserId == userId);
                userComments.put(comment.id, comment);
            };
            case (#didDeleteComment({commentAuthorUserId; commentId})){
                assert(commentAuthorUserId == userId);
                userComments.delete(commentId);
            };
            case (#didReceiveRatingOnThyComment({commentAuthorUserId; raterUserId; rating})){
                assert(commentAuthorUserId == userId);               
                switch(receivedRatings.get(raterUserId)){
                    case (?raterRatingsMap){
                        raterRatingsMap.put(rating.commentId, rating);
                    };
                    case _ {
                        let newRatingMap = HashMap.HashMap<Types.CommentId, Types.Rating>(1, Nat.equal, Hash.hash);
                        newRatingMap.put(rating.commentId, rating);
                        receivedRatings.put(raterUserId, newRatingMap);
                    };
                };
            };
            case (#didAddNewRating({raterUserId; rating})){
                assert(raterUserId == userId);
                userRatings.put(rating.commentId, rating);
            };
        };
    };

    // test functions for CandidUI
    public shared query func testGetUserComments(): async [Types.Comment] {
        var commentArray: [Types.Comment] = [];
        for ((commentId, comment) in userComments.entries()){
            commentArray := Array.append<Types.Comment>(commentArray, [comment]);
        };
        return commentArray;
    };

    public shared query func testReceivedRatings(): async [{userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}] {
        var receivedRatingsArray: [{userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}] = [];
        for ((userId, commentMap) in receivedRatings.entries()){
            var comments: [{commentId: Types.CommentId; rating: Types.Rating}] = [];
            for ((commentId, ratingObj) in commentMap.entries()){
                comments := Array.append<
                    {commentId: Types.CommentId; rating: Types.Rating}
                >(comments, [{
                    commentId = commentId;
                    rating = ratingObj;
                }]);
            };
            receivedRatingsArray := Array.append<
                {userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}
            >(
                receivedRatingsArray,
                [{
                    userId = userId;
                    comments = comments;
                }]
            );
        };
        return receivedRatingsArray;
    };

    public shared query func testUserRatings(): async [{commentId: Types.CommentId; rating: Types.Rating}] {
        var userRatingsArray: [{commentId: Types.CommentId; rating: Types.Rating}] = [];
        for ((commentId, rating) in userRatings.entries()){
            userRatingsArray := Array.append<
                {commentId: Types.CommentId; rating: Types.Rating}
            >(
                userRatingsArray,
                [{
                    commentId = commentId;
                    rating = rating;
                }]
            );
        };
        return userRatingsArray;
    };
}