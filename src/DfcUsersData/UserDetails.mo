import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Types "./../Shared/types";
import DfcData "canister:DfcData";

shared ({caller = owner}) actor class UserDetails () {
    
    let userComments = HashMap.HashMap<Types.CommentId, Types.Comment>(1, Nat.equal, Hash.hash);
    let receivedRatings = HashMap.HashMap<Types.UserId, HashMap.HashMap<Types.CommentId, Types.Rating>>(1, Principal.equal, Principal.hash);
    let userRatings = HashMap.HashMap<Types.CommentId, Types.Rating>(1, Nat.equal, Hash.hash);

    // func _calculateAverageReceivedRatingByUserId(userId: UserId): ?Float {
    //     switch (receivedRatings.get(userId)){
    //         case (?ratingsMap){
    //             var numerator: Float = 0;
    //             var denominator: Float = 0;
    //             for ((commentId, ratingObj) in ratingsMap.entries()){
    //                 if (ratingObj.rating == true){
    //                     numerator += 1;
    //                 };
    //                 denominator += 1;
    //             };

    //             if (denominator == 0){
    //                 return null;
    //             };
    //             return numerator/denominator;
    //         };
    //     };

    //     return null;   
    // }

    public shared func init(): async () {
        DfcData.subscribeUserDataEvents({
            userId = owner;
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
                assert(commentAuthorUserId == owner);
                userComments.put(comment.id, comment);
            };
            case (#didDeleteComment({commentAuthorUserId; commentId})){
                assert(commentAuthorUserId == owner);
                userComments.delete(commentId);
            };
            case (#didReceiveRatingOnThyComment({commentAuthorUserId; raterUserId; rating})){
                assert(commentAuthorUserId == owner);               
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
                assert(raterUserId == owner);
                userRatings.put(rating.commentId, rating);
            };
        };
    };
}