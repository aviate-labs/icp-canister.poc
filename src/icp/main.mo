import Array "mo:base/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import CRC32 "mo:hash/CRC32";
import Principal "mo:base/Principal";
import AccountIdentifier "mo:principal/AccountIdentifier";

import Ledger "Ledger";

actor class ICP() = this {
    private let ledger : Ledger.Interface = actor("ryjl3-tyaaa-aaaaa-aaaba-cai");

    public func balance() : async Ledger.ICP {
        let accountId = AccountIdentifier.fromPrincipal(Principal.fromActor(this), null);

        await ledger.account_balance({
            account = Blob.fromArray(Array.append<Nat8>(
                Binary.BigEndian.fromNat32(CRC32.checksum(accountId)),
                accountId,
            ));
        });
    };  
};
