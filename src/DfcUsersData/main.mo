import HashMap "mo:base/HashMap";
import DfcUsers "canister:DfcUsers";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Types "./../Shared/types";
import UserDetails "UserDetails";

actor DfcUsersData {
    let usersDataMap = HashMap.HashMap<Types.UserId, UserDetails.UserDetails>(1, Principal.equal, Principal.hash);

    public shared func init(): async () {
        DfcUsers.subscribeUserProfileEvents({
            callback = callbackForUserProfileEvent;
        });
    };

    public shared func callbackForUserProfileEvent(userProfileEvent: Types.SubscriptionUserProfileEvent) {
        switch(userProfileEvent){
            case (#didRegisterNewUser({userId; profile})){
                let userDetails = await UserDetails.UserDetails(userId);
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

    // test functions for __Candid_UI
    public shared func testGetAllUsersComments(): async [{userId: Types.UserId; comments: [Types.Comment]}] {
        var returnArray: [{userId: Types.UserId; comments: [Types.Comment]}] = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            let commentsR = await userDetails.testGetUserComments();
            returnArray := Array.append<{userId: Types.UserId; comments: [Types.Comment]}>(
                returnArray,
                [{
                    userId = userId;
                    comments = commentsR;
                }]
            );
        };
        return returnArray;
    }; 
      
    public shared func testAllUsersReceivedRatings(): async [{userId: Types.UserId; receivedRatings: [{userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}]}] {
        var returnArray: [{userId: Types.UserId; receivedRatings: [{userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}]}] = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            let receivedRatingsR = await userDetails.testReceivedRatings();
            returnArray := Array.append<
                {userId: Types.UserId; receivedRatings: [{userId: Types.UserId; comments:[{commentId: Types.CommentId; rating: Types.Rating}]}]}
            >(
                returnArray,
                [{
                    userId = userId;
                    receivedRatings = receivedRatingsR;
                }]
            );
        };
        return returnArray;
    };

    public shared func testAllUsersRatings(): async [{userId: Types.UserId; ratings: [{commentId: Types.CommentId; rating: Types.Rating}]}] {
        var returnArray: [{userId: Types.UserId; ratings: [{commentId: Types.CommentId; rating: Types.Rating}]}] = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            let ratingsR = await userDetails.testUserRatings();
            returnArray := Array.append<
                {userId: Types.UserId; ratings: [{commentId: Types.CommentId; rating: Types.Rating}]}
            >(
                returnArray,
                [{
                    userId = userId;
                    ratings = ratingsR;
                }]
            );
        };
        return returnArray;
    };

    public shared func testAllUsers(): async [Types.UserId] {
        var returnArray: [Types.UserId] = [];
        for ((userId, userDetails) in usersDataMap.entries()){
            returnArray := Array.append<Types.UserId>(returnArray, [userId]);            
        };
        return returnArray;
    };

    public shared (msg) func getMyPrincipal(): async Principal {
        return msg.caller;
    };
}