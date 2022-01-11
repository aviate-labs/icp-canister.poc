import Array "mo:base/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import CRC32 "mo:hash/CRC32";
import Float "mo:base/Float";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import AId "mo:principal/blob/AccountIdentifier";

import Ledger "Ledger";
import LedgerC "LedgerCandid";
import XDR "XDR";

shared({caller = owner}) actor class ICP(
    ledgerCandid : Principal,
) = this {
    private let ledger  : Ledger.Interface  = actor(Ledger.CANISTER_ID);
    private let ledgerC : LedgerC.Interface = actor(Principal.toText(ledgerCandid));
    private let cycles  : XDR.Interface     = actor(XDR.CANISTER_ID);

    public func accountId() : async Text {
        AId.toText(aId());
    };

    private func aId() : AId.AccountIdentifier {
        AId.fromPrincipal(Principal.fromActor(this), null);
    };

    public func balance() : async Ledger.ICP {
        await ledger.account_balance({
            account = aId();
        });
    };

    public func cyclesPerICP() : async Float {
        let resp = await cycles.get_icp_xdr_conversion_rate();
        Float.fromInt(Nat64.toNat(resp.data.xdr_permyriad_per_icp)) / 10_000;
    };

    public shared({caller}) func transfer(amount : Ledger.ICP, to : Text) : async Ledger.TransferResult {
        assert(caller == owner);
        let aId : AId.AccountIdentifier = switch(AId.fromText(to)) {
            case (#err(_)) {
                assert(false);
                loop {};
            };
            case (#ok(a)) a;
        };
        await ledger.transfer({
            memo            = 1;
            amount          = amount;
            fee             = { e8s = 10_000 };
            from_subaccount = null;
            to              = aId;
            created_at_time = null;
        });
    };

    public shared func tipOfChainDetails() : async (Ledger.BlockIndex, LedgerC.Transaction) {
        let tip = await ledgerC.tip_of_chain();
        switch (tip) {
            case (#Err(_)) {
                assert(false);
                loop {};
            };
            case (#Ok(t)) {
                let block = await ledgerC.block(t.tip_index);
                switch (block) {
                    case (#Err(_)) {
                        assert(false);
                        loop {};
                    };
                    case (#Ok(r)) {
                        switch (r) {
                            case (#Err(_)) {
                                assert(false);
                                loop {};
                            };
                            case (#Ok(b)) {
                                (t.tip_index, b.transaction);
                            };
                        };
                    };
                };
            };
        };
    };
};
