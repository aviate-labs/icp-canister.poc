// MIT License
// Copyright (c) 2021 quintolet
// https://github.com/quintolet/ledger-candid

use candid::CandidType;
use dfn_candid::{candid, candid_one};
use dfn_core::{api::call_with_cleanup, over, over_async};
use dfn_protobuf::protobuf;
use ic_nns_constants::LEDGER_CANISTER_ID;
use ic_types::CanisterId;
use ledger_canister::{protobuf::TipOfChainRequest, Block, BlockArg, BlockHeight, BlockRes, TipOfChainRes};
use serde::{Deserialize, Serialize};

#[export_name = "canister_update block"]
fn block() {
    over_async(candid_one, |height: u64| get_block(height))
}

async fn get_block(height: u64) -> Result<Result<Block, CanisterId>, String> {
    let BlockRes(res) =
        call_with_cleanup(LEDGER_CANISTER_ID, "block_pb", protobuf, BlockArg(height))
            .await
            .map_err(|e| format!("Failed to fetch block {}", e.1))?;
    match res.ok_or("Block not found")? {
        Ok(raw_block) => {
            let block = raw_block.decode().unwrap();
            Ok(Ok(block))
        }
        Err(canister_id) => Ok(Err(canister_id)),
    }
}

#[derive(Serialize, Deserialize, CandidType, Clone, Hash, Debug, PartialEq, Eq)]
pub struct TipOfChain {
    pub certification: Option<Vec<u8>>,
    pub tip_index    : BlockHeight,
}

#[export_name = "canister_update tip_of_chain"]
fn tip_of_chain() {
    over_async(candid, |()| get_tip_of_chain())
}

async fn get_tip_of_chain() -> Result<TipOfChain, String> {
    let result: TipOfChainRes = call_with_cleanup(
        LEDGER_CANISTER_ID,
        "tip_of_chain_pb",
        protobuf,
        TipOfChainRequest {},
    )
    .await
    .map_err(|e| format!("Failed to get tip of chain {}", e.1))?;
    Ok(TipOfChain {
        certification: result.certification,
        tip_index: result.tip_index,
    })
}

#[export_name = "canister_query __get_candid_interface_tmp_hack"]
fn expose_candid() {
    over(candid, |_: ()| {
        include_str!("ledger.did").to_string()
    })
}
