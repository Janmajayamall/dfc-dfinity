import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Types "./../Shared/types";

actor DfcUsers {

    let users = HashMap.HashMap<Types.UserId, Types.Profile>(1, Principal.equal, Principal.hash);

    var userProfileEventSubscribers: [Types.SubcribeUserProfileEventsData] = [];

    //TODO set of usernames to avoid duplication
    

    public shared query (msg) func getUserProfile(): async Result.Result<Types.Profile, Types.ProfileError> {
        switch (users.get(msg.caller)){
            case (?profile){
                return #ok(profile);
            };
            case _ {
                return #err(#profileDoesNotExists(msg.caller));
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

    public shared func subcribeUserProfileEvents(data: Types.SubcribeUserProfileEventsData) {
        userProfileEventSubscribers := Array.append<Types.SubcribeUserProfileEventsData>(userProfileEventSubscribers, [data])
    };

    public shared func publishUserProfileEvent(userProfileEvent: Types.SubscriptionUserProfileEvent) {
        for (data in userProfileEventSubscribers.vals()){
            data.callback(userProfileEvent);
        };
    };

}