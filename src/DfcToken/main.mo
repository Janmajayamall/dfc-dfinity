import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Types "./../Shared/types";
import DfcData "canister:DfcData";

actor DfcToken {
    let admin: Principal = Principal.fromText("lplep-yvd5p-rlk4w-toc45-jry63-kgc7g-dh3sp-akopa-5ukwz-i3crd-gae");

    private let _balances = HashMap.HashMap<Types.UserId, Nat>(1, Principal.equal, Principal.hash);
    private let _allowances = HashMap.HashMap<Types.UserId, HashMap.HashMap<Types.UserId, Nat>>(1, Principal.equal, Principal.hash);
    private var _totalSupply: Nat = 0;

    private var _name: Text = "DFCToken";
    private var _symbol: Text = "DFC";

    func _transfer(sender: Principal, recipient: Principal, amount: Nat): Result.Result<Nat, Types.TokenError> {
        switch(_balances.get(sender)){
            case (?senderBalance){
                if (senderBalance >= amount){
                    let newSenderBalance = Nat.sub(senderBalance, amount);
                    switch(_balances.get(recipient)){
                        case(?recipientBalance){
                            let newRecipientBalance = recipientBalance + amount;
                            _balances.put(recipient, newRecipientBalance);
                        };
                        case _ {
                            _balances.put(recipient, amount);
                        };
                    };
                    _balances.put(sender, newSenderBalance);
                    #ok(amount);
                }else {
                    #err(#insufficientBalance);
                };
            };
            case _ {
                #err(#insufficientBalance);
            }
        };
    };

    func _approve(owner: Principal, spender: Principal, amount: Nat): Bool {
        switch(_allowances.get(owner)){
            case null {
                let newAllowanceMap = HashMap.HashMap<Types.UserId, Nat>(1, Principal.equal, Principal.hash);
                newAllowanceMap.put(spender, amount);
                _allowances.put(owner, newAllowanceMap);
            };
            case (?allowanceMap) {
                allowanceMap.put(spender, amount);
            };
        };
        return true;
    };

    func _burn(account: Principal, amount: Nat): Result.Result<Nat, Types.TokenError>{
        switch(_balances.get(account)){
            case (?balance){
                if (balance >= amount){
                    let newBalance = Nat.sub(balance, amount);
                    _balances.put(account, newBalance);
                    _totalSupply -= amount;
                    return #ok(amount);
                }else{
                    return #err(#insufficientBalance);
                };
            };
            case _ {
                return #err(#insufficientBalance);
            };
        };
    };

    func _mint(account: Principal, amount: Nat): Result.Result<Nat, Types.TokenError> {
        if(Principal.equal(admin, account) == false){
            return #err(#minterNotAdmin);
        };

        switch(_balances.get(admin)){
            case(?balance){
                let newBalance = balance + amount;
                _balances.put(admin, newBalance);
            };
            case _ {
                _balances.put(admin, amount);
            };
        };
        
        _totalSupply += amount;
        
        #ok(amount);
    };

    func _allowance(owner: Principal, spender: Principal): async Nat {
        switch(_allowances.get(owner)){
            case (?ownerAllowanceMap){
                switch(ownerAllowanceMap.get(spender)){
                    case (?allowance){
                        return allowance;
                    };
                    case _ {
                        return 0;
                    };
                };
            };
            case _ {
                return 0;
            };
        };
    };

    public shared query func name(): async Text {
        return _name;
    };

    public shared query func symbol(): async Text {
        return _symbol;
    };

    public shared query func decimals(): async Nat {
        return 18;
    };

    public shared query func totalSupply(): async Nat {
        return _totalSupply;
    };

    public shared query (msg) func balanceOf(): async Nat {
        switch(_balances.get(msg.caller)){
            case (?balance){
                return balance;
            };
            case _ {
                return 0;                
            };
        };
    };

    public shared query (msg) func allowance(owner: Principal, spender: Principal): async Nat {
        return _allowance(owner, spender);
    };

    public shared (msg) func transfer(recipient: Principal, amount: Nat): async Result.Result<Nat, Types.TokenError> {
        return _transfer(msg.caller, recipient, amount);
    };

    public shared (msg) func transferFrom(sender: Principal, recipient: Principal, amount: Nat): async Result.Result<Nat, Types.TokenError>{
        switch(_allowances.get(sender)){
            case(?senderAllowanceMap){
                switch(senderAllowanceMap.get(msg.caller)){
                    case(?allowance){
                        if(allowance >= amount){
                            return _transfer(sender, recipient, amount);
                        }else{
                            #err(#insufficientAllowance);
                        }
                    };
                    case _ {#err(#insufficientAllowance);};
                };
            };
            case _ {
                #err(#insufficientAllowance);
            };
        };
    };

    public shared (msg) func increaseAllowance(spender: Principal, addValue: Nat): async Result.Result<Bool, Types.TokenError> {
        var existingAllowance: Nat = _allowance(msg.caller, spender);
        if (_approve(msg.caller, spender, existingAllowance + addValue)){
            #ok(true);
        }else{
            #err(#unknownFail);
        }
    };

    public shared (msg) func decreaseAllowance(spender: Principal, subValue: Nat): async Result.Result<Bool, Types.TokenError> {
        var existingAllowance: Nat = _allowance(msg.caller, spender);
        if (existingAllowance < subValue){
            return #err(#insufficientAllowance);
        };
        if (_approve(msg.caller, spender, existingAllowance - subValue)){
            return #ok(true);
        }else{
            return #err(#unknownFail);
        };
    };

    public shared (msg) func mint(amount: Nat): async Result.Result<Nat, Types.TokenError> {
        return _mint(msg.caller, amount);
    };

    public shared (msg) func burn(amount: Nat): async Result.Result<Nat, Types.TokenError> {
        return _burn(msg.caller, amount);
    };

    
}