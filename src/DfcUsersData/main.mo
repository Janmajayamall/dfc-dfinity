import HashMap "mo:base/HashMap";
import DfcUsers "canister:DfcUsers";
import Principal "mo:base/Principal";
import Types "./../Shared/types";
import UserDetails "UserDetails";

actor DfcUsersData {
    let usersDataMap = HashMap.HashMap<Types.UserId, UserDetails.UserDetails>(1, Principal.equal, Principal.hash);

    public shared func init(): async () {
        //TODO restrict this to the controller of the casnister
        DfcUsers.subcribeUserProfileEvents({
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
}