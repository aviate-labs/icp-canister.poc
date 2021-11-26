import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import AccountIdentifier "mo:principal/AccountIdentifier";

import Ledger "Ledger";

actor class ICP() = this {
    private let ledger : Ledger.Interface = actor("ryjl3-tyaaa-aaaaa-aaaba-cai");

    public func balance() : async Ledger.ICP {
        await ledger.account_balance({
            account = Blob.fromArray(AccountIdentifier.fromPrincipal(Principal.fromActor(this), null));
        });
    };  
};
