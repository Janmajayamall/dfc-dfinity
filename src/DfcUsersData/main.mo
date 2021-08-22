import HashMap "mo:base/HashMap";
import DfcUsers "canister:DfcUsers";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Types "./../Shared/types";
import UserDetails "UserDetails";

actor DfcUsersData {
    let usersDataMap = HashMap.HashMap<Types.UserId, UserDetails.UserDetails>(1, Principal.equal, Principal.hash);

    public shared func init(): async () {
        //TODO restrict this to the controller of the canister
        DfcUsers.subscribeUserProfileEvents({
            callback = callbackForUserProfileEvent;
        });
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

    public shared func getUsersDataForAuthorScore(): async Types.UsersDataForAuthorScore {
        var usersData: Types.UsersDataForAuthorScore = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            let receivedRatingsMetadataArray = await userDetails.getReceivedRatingsMetadata();
            usersData := Array.append<{userId: Types.UserId; receivedRatingsMetadataArray: [Types.ReceivedRatingsFromUserMetadata]}>(usersData, [{
                userId = userId;
                receivedRatingsMetadataArray = receivedRatingsMetadataArray;
            }]);
        };
        return usersData;
    };

    public shared func getUsersDataForRaterScore(): async Types.UsersDataForRaterScore {
        var usersData: [{userId: Types.UserId; userValidRatings: [Types.Rating]}] = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            let validRatings = await userDetails.getUserValidRatings();
            usersData := Array.append<{userId: Types.UserId; userValidRatings: [Types.Rating]}>(usersData, [{
                userId = userId;
                userValidRatings = validRatings;
            }]);
        };
        return usersData;
    };

    // public shared func calculateAuthorScoreOfUser(userId: Types.UserId, authorScoresMap: Types.AuthorScoresMap): async Float {
    //     switch(usersDataMap.get(userId)){
    //         case(?userDetails){
    //             let userAuthorScore = await userDetails.calculateAuthorScore(authorScoresMap);
    //             return userAuthorScore;
    //         };
    //         case _ {
    //             return 0.0;
    //         };
    //     };
    // };
    
}