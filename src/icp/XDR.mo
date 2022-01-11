module {
    public let CYCLES_PER_XDR : Nat  = 1_000_000_000_000; // 1T
    public let CANISTER_ID    : Text = "rkp4c-7iaaa-aaaaa-aaaca-cai";

    public type IcpXdrConversionRate = {
        timestamp_seconds     : Nat64;
        // This value has 4 decimal values!
        xdr_permyriad_per_icp : Nat64;
    };

    public type IcpXdrConversionRateCertifiedResponse = {
        data        : IcpXdrConversionRate;
        hash_tree   : Blob;
        certificate : Blob;
    };

    public type Interface = actor {
        get_icp_xdr_conversion_rate : query () -> async (IcpXdrConversionRateCertifiedResponse);
    };
};
