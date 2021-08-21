import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Options "mo:base/Options";
import DfcUsers "canister:DfcUsers";
import DfcData "canister:DfcData";

actor DfcReputationScorer {
    public shared func init(): async () {
        DfcUsers.subscribeUserProfileEvents({
            callback = callbackForUserProfileEvent;
        });

        DfcData.subscribeRatingEvents({
            callback = callbackForRatingEvent;
        })
    };

    public shared func callbackForUserProfileEvent(userProfileEvent: Types.SubscriptionUserProfileEvent) {
        switch(userProfileEvent){
            case (#didRegisterNewUser({userId; profile})){
                let userDetails = await UserDetails.UserDetails();
                await userDetails.init();
                usersDataMap.put(userId, userDetails);
            };
        };
    };

    func _calculateAuthorScores(usersDataForAuthorScore: Types.UsersDataForAuthorScore): Types.UsersAuthorScoreMap {
        // initializing maps for calculating author score (initial author score is always 1)
        var usersReceivedRatingsRefMap = HashMap.HashMap<Types.UserId, [ReceivedRatingsFromUserMetadata]>(1, Principal.equal, Hash.hash);
        var lastCycleUsersHashmap = HashMap.HashMap<Types.UserId, {authorScore: Float}>(1, Principal.equal, Principal.hash);
        var currentCycleUsersHashmap = HashMap.HashMap<Types.UserId, {authorScore: Float}>(1, Principal.equal, Principal.hash);
        for ({userId; receivedRatingsMetadata} in usersDataForAuthorScore.vals()){
            lastCycleUsersHashmap.put(userId, {
                authorScore = 1;
            });
            usersReceivedRatingsRefMap.put(userId, receivedRatingsMetadata);
        };

        // calculate author scores iteratively (fixed iterations: 300)
        for (i in Iter.range(0, 300)){
            for ((userId, authorScoreData) in lastCycleUsersHashmap.entries()){
                let receivedRatings = Options.get(usersReceivedRatingsRefMap.get(userId), []);
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

    public shared func calculateReputationScore() {
        let usersDataForAuthorScore: Types.UsersDataForAuthorScore = await DfcUsersData.getUsersDataForAuthorScore();
        let usersAuthorScoreMap = _calculateAuthorScores(usersDataForAuthorScore);
    };

    public shared func callbackForRatingEvent(commentEvent: Types.SubscriptionRatingEvent){
        
    };
}
