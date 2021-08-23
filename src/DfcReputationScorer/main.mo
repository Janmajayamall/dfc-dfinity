import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Bool "mo:base/Bool";
import Time "mo:base/Time";
import Int "mo:base/Int";
import DfcData "canister:DfcData";
import DfcUsersData "canister:DfcUsersData";
import Types "./../Shared/types";

actor DfcReputationScorer {

    let leadershipBoardMap = HashMap.HashMap<Types.Timestamp, HashMap.HashMap<Types.UserId, Types.ReputationScore>>(1, Int.equal, Int.hash);
    let commentsRatingDataMap = HashMap.HashMap<Types.CommentId, {commentId: Types.CommentId; positiveRatings: Int; negativeRatings: Int}>(1, Nat.equal, Hash.hash);
    var latestTimestamp: Types.Timestamp = Time.now();

    public shared func init(): async () {
        DfcData.subscribeRatingEvents({
            callback = callbackForRatingEvent;
        })
    };

    func _calculateAuthorScores(usersDataForAuthorScore: Types.UsersDataForAuthorScore): Types.UsersAuthorScoreMap {
        // initializing maps for calculating author score (initial author score is always 1)
        var usersReceivedRatingsRefMap = HashMap.HashMap<Types.UserId, [Types.ReceivedRatingsFromUserMetadata]>(1, Principal.equal, Principal.hash);
        var lastCycleUsersHashmap = HashMap.HashMap<Types.UserId, {authorScore: Float}>(1, Principal.equal, Principal.hash);
        var currentCycleUsersHashmap = HashMap.HashMap<Types.UserId, {authorScore: Float}>(1, Principal.equal, Principal.hash);
        for ({userId; receivedRatingsMetadataArray} in usersDataForAuthorScore.vals()){
            lastCycleUsersHashmap.put(userId, {
                authorScore = 1;
            });
            usersReceivedRatingsRefMap.put(userId, receivedRatingsMetadataArray);
        };

        // calculate author scores iteratively (fixed iterations: 300)
        for (i in Iter.range(0, 300)){
            for ((userId, authorScoreData) in lastCycleUsersHashmap.entries()){
                let receivedRatings = Option.get(usersReceivedRatingsRefMap.get(userId), []);
                var numerator: Float = 0;
                var denominator: Float = 0;
                for (ratingMetadata in receivedRatings.vals()){
                    switch (lastCycleUsersHashmap.get(ratingMetadata.userId)){
                        case (?raterData){
                            numerator += (raterData.authorScore*(ratingMetadata.positiveRatings / ratingMetadata.totalRatings));
                            denominator += raterData.authorScore;
                        };
                        case _ {
                        };
                    };
                };
                let currentCycleAuthorScore = (1.5 * ((2 + numerator)/(6 + denominator))) - 0.5;
                currentCycleUsersHashmap.put(userId, {authorScore = currentCycleAuthorScore});

                // switch(usersReceivedRatingsRefMap.get(userId)){
                //     case (?receivedRatings){
                //         var numerator: Float = 0;
                //         var denominator: Float = 0;
                //         for (ratingMetadata in receivedRatings.vals()){
                //             switch (lastCycleUsersHashmap.get(ratingMetadata.userId)){
                //                 case (?raterData){
                //                     numerator += (raterData.authorScore*(ratingMetadata.positiveRatings / ratingMetadata.totalRatings));
                //                     denominator += raterData.authorScore;
                //                 };
                //                 case _ {
                //                 };
                //             };
                //         };
                //         let currentCycleAuthorScore = (1.5 * ((2 + numerator)/(6 + denominator))) - 0.5;
                //         currentCycleUsersHashmap.put(userId, {authorScore = currentCycleAuthorScore});
                //     };
                //     case _ {
                //         currentCycleUsersHashmap.put(userId, {authorScore = 0});
                //     };
                // };
            };
            lastCycleUsersHashmap := currentCycleUsersHashmap;
            currentCycleUsersHashmap := HashMap.HashMap<Types.UserId, {authorScore: Float}>(1, Principal.equal, Principal.hash);
        };
        return lastCycleUsersHashmap;
    };

    func _calculateRaterScores(usersDataForRaterScore: Types.UsersDataForRaterScore): Types.UsersRaterScoreMap {
        let usersRaterScoreMap = HashMap.HashMap<Types.UserId, {raterScore: Float}>(1, Principal.equal, Principal.hash);
        for (userData in usersDataForRaterScore.vals()){
            var ratingsInConsensus: Float = 0;
            var totalRatings: Float = 0;
            for (userRating in userData.userValidRatings.vals()){
                switch(commentsRatingDataMap.get(userRating.commentId)){
                    case(?commentRatingData){
                        if (((commentRatingData.positiveRatings > commentRatingData.negativeRatings) and (userRating.rating == true))
                        or ((commentRatingData.positiveRatings < commentRatingData.negativeRatings) and (userRating.rating == false))) {
                            ratingsInConsensus += 1;
                        };
                    };
                    case _ {

                    };
                };                
                totalRatings += 1;
            };
            let raterScore: Float = (1.5 * ((2 + ratingsInConsensus)/(6 + totalRatings))) - 0.5;
            usersRaterScoreMap.put(userData.userId, {raterScore = raterScore});
        };
        return usersRaterScoreMap;
    };

    public shared func calculateReputationScore() {
        let startTimestamp: Types.Timestamp = Time.now();
        let usersDataForAuthorScore: Types.UsersDataForAuthorScore = await DfcUsersData.getUsersDataForAuthorScore();
        let usersAuthorScoreMap = _calculateAuthorScores(usersDataForAuthorScore);

        let usersDataForRaterScore: Types.UsersDataForRaterScore = await DfcUsersData.getUsersDataForRaterScore();
        let usersRaterScoreMap = _calculateRaterScores(usersDataForRaterScore);

        // store the reputation score by timestamp (I guess 2d hashmap?)
        let reputationScoreMap = HashMap.HashMap<Types.UserId, Types.ReputationScore>(1, Principal.equal, Principal.hash);
        for ((userId, {authorScore}) in usersAuthorScoreMap.entries()){
            switch(usersRaterScoreMap.get(userId)){
                case (?{raterScore}){
                    let reputationScore: Float = authorScore + raterScore;
                    let reputationScoreObj: Types.ReputationScore = {
                        userId = userId;
                        authorScore = authorScore;
                        raterScore = raterScore;
                        timestamp = startTimestamp;
                        reputationScore = reputationScore;
                    };
                    reputationScoreMap.put(userId, reputationScoreObj);
                };
                case _ {

                };
            };
        };
        latestTimestamp = startTimestamp;
        leadershipBoardMap.put(startTimestamp, reputationScoreMap);
    };
 
    public shared func callbackForRatingEvent(ratingEvent: Types.SubscriptionRatingEvent) {
        switch(ratingEvent){
            case(#didUpdateRating(updateValue)){
                let oldRatingData = Option.get(commentsRatingDataMap.get(updateValue.commentId), {
                    commentId = updateValue.commentId; 
                    positiveRatings = 0; 
                    negativeRatings = 0;
                });
                let newRatingData = {
                    commentId = updateValue.commentId; 
                    positiveRatings = oldRatingData.positiveRatings + updateValue.positiveDelta; 
                    negativeRatings = oldRatingData.negativeRatings + updateValue.negativeDelta
                };
                commentsRatingDataMap.put(updateValue.commentId, newRatingData);
            };
        };
    };
}
