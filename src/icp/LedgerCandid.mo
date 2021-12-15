import Ledger "Ledger";

module {
    public type Block = {
        parent_hash : Hash;
        timestamp   : Ledger.Timestamp;
        transaction : Transaction;
    };

    public type CanisterId = Principal;

    public type Hash = ?{
        inner: Blob;
    };

    // NOTE: this is not a Blob, like in the other ledger interface!
    public type AccountIdentifier = Text;

    public type Transaction = {
        transfer        : Transfer;
        memo            : Ledger.Memo;
        created_at_time : Ledger.Timestamp;
    };

    public type Transfer = {
        #Burn : {
            from   : AccountIdentifier;
            amount : Ledger.ICP;
        };
        #Mint : {
            to     : AccountIdentifier;
            amount : Ledger.ICP;
        };
        #Send : {
            from   : AccountIdentifier;
            to     : AccountIdentifier;
            amount : Ledger.ICP;
        };
    };

    public type TipOfChain = {
        certification : ?Blob;
        tip_index     : Ledger.BlockIndex;
    };

    public type Interface = actor {
        block        : (blockHeight : Nat64) -> async Ledger.Result<Ledger.Result<Block, CanisterId>, Text>;
        tip_of_chain : ()                    -> async Ledger.Result<TipOfChain, Text>;
    };
};
