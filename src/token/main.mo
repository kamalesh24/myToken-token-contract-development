import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    Debug.print("Hello");
    var owner: Principal = Principal.fromText("wwiiz-jfsqj-yjsl4-usyku-qlutq-nqzf5-gaxja-3ud3y-duan2-7krp4-pae");
    var totalSupply : Nat = 1000000000;
    var symbol: Text = "KAML";   

    private stable var balanceEntries: [(Principal, Nat)] = []; 

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); // (init size, how to map, hash func)
    if(balances.size() < 1){
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal): async Nat {
        let balance: Nat = switch (balances.get(who)) {
            case null 0;
            case (?res) res; 
        };

        return balance;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    public shared(msg) func payOut(): async Text {
        // Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller) == null){
            let amt = 10000;
            let result = await transfer(msg.caller, amt);
            return result;
        } else {
            return "Already Claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amt: Nat) : async Text{
        let fromBalance = await balanceOf(msg.caller);
        if(fromBalance > amt){
            balances.put(msg.caller, fromBalance-amt);

            let toBalance: Nat = await balanceOf(to);
            balances.put(to, toBalance+amt);
            return "Success";
        } else{
            return "Insufficient tokens";
        }
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade(){
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if(balances.size() < 1){
            balances.put(owner, totalSupply);
        };
    };
}