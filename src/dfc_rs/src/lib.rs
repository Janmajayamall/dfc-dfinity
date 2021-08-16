use ic_cdk::{storage, export::{Principal, candid::{CandidType, Deserialize}}};
use ic_cdk_macros::*;
use std::collections::{BTreeMap, BTreeSet};
use uuid::Uuid;

type PrincipalIdMap = BTreeMap<Principal, Uuid>;
type ProfileMap = BTreeMap<Principal, Profile>;
type FlagContentMap = BTreeMap<Uuid, Content>


#[derive(Clone, Debug, Default, CandidType, Deserialize)]
struct Profile {
    pub username: String,   
}

#[derive(Clone, Debug, Default, CandidType, Deserialize)]
struct Content {
    pub url: String,
    pub principal: Principal,
}


#[update]
fn register_user(username: String) {
    // insert necessary username checks!

    let principal_id = ic_cdk::reflection::caller();
    let principal_id_map = storage::get_mut::<PrincipalIdMap>();
    principal_id_map.insert(principal_id_map, username);

    // if let None == principal_id_map.get(&principal_id) {
    // }
}

#[updates]
fn flag_content(url: String) {
    // insert necessary checks for url!

    let principal_id = ic_cdk::reflection::caller();
    let flag_content_map = storage::get_mut::<FlagContentMap>();
    let flag_content = Content {
        url,
        principal: principal_id
    };
    flag_content_map.insert(Uuid::new_v4(), flag_content);
}

