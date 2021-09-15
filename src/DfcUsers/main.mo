import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Types "./../Shared/types";

actor DfcUsers {

    let users = HashMap.HashMap<Types.UserId, Types.Profile>(1, Principal.equal, Principal.hash);

    var userProfileEventSubscribers: [Types.SubscribeUserProfileEventsData] = [];

    public shared query func getUserProfile(userId: Types.UserId): async Result.Result<Types.Profile, Types.ProfileError> {
        switch (users.get(userId)){
            case (?profile){
                return #ok(profile);
            };
            case _ {
                return #err(#profileDoesNotExists(userId));
            };
        };
    };

    public shared (msg) func registerUser(username: Text): async Result.Result<Types.Profile, Types.ProfileError> {
        // check whether username already exists to avoid duplication of usernames

        switch(users.get(msg.caller)){
            case (?user){
                #err(#userAlreadyExists(msg.caller));
            };
            case _ {
                let newProfile: Types.Profile = {
                    userId = msg.caller;
                    username = username;
                };
                users.put(msg.caller, newProfile);

                // publish new user register event
                publishUserProfileEvent(#didRegisterNewUser({userId = msg.caller; profile = newProfile}));

                #ok(newProfile);
            };
        };
    }; 

    public shared func subscribeUserProfileEvents(data: Types.SubscribeUserProfileEventsData) {
        userProfileEventSubscribers := Array.append<Types.SubscribeUserProfileEventsData>(userProfileEventSubscribers, [data])
    };

    public shared func publishUserProfileEvent(userProfileEvent: Types.SubscriptionUserProfileEvent) {
        for (data in userProfileEventSubscribers.vals()){
            data.callback(userProfileEvent);
        };
    };

    // test functions for CandidUI
    public shared func getAllUsers(): async [Types.Profile] {
        var profiles: [Types.Profile] = [];
        for ((userId, profile) in users.entries()){
            profiles := Array.append<Types.Profile>(profiles, [profile]);            
        };
        return profiles;
    };

    public shared (msg) func getMyPrincipal(): async Principal {
        return msg.caller;
    };
}