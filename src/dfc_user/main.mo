import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";

actor {
    public type UserId = Principal;

    public type Profile = {
        userId: UserId;
        username: Text;
    };

    let users = HashMap.HashMap<UserId, Profile>;

    public shared query (msg) func findUser(): async ?Profile {
        return users.get(msg.caller);
    }

    public shared (msg) func registerUser(username: Text): async Profile {
        let newUser: Profile = {
            userId = msg.caller,
            username = username
        }
        users.put(msg.caller, newUser);
        return newUser;
    } 

}