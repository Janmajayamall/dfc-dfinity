use ic_cdk::{storage, export::{Principal, candid::{CandidType, Deserialize}}};
use ic_cdk_macros::*;
use std::collections::{BTreeMap, BTreeSet};
use uuid::Uuid;

type PrincipalIdMap = BTreeMap<Principal, Uuid>;
type ProfileMap = BTreeMap<Principal, Profile>;
type FlagContentMap = BTreeMap<Uuid, Content>;


#[derive(Clone, Debug, Default, CandidType, Deserialize)]
struct Profile {
    pub username: String,   
}

#[derive(Clone, Debug, Default, CandidType, Deserialize)]
struct Content {
    pub id: String,
    pub url: String,
    pub principal: Principal,
    pub created_at: String,
    pub comments: BTreeMap<Uuid, Comment>
}


#[derive(Clone, Debug, CandidType, Deserialize)]
struct Comment {
    pub id: String,
    pub principal: Principal,
    pub text: String,
    pub username: String,
    pub created_at: String,
    pub ratings: BTreeMap<Principal, Rating>
}


#[derive(Clone, Debug, Default, CandidType, Deserialize)]
struct Rating {
    pub principal: Principal,
    pub rating: bool
}


#[update]
fn register_user(username: String) {
    // insert necessary username checks!

    let principal_id = ic_cdk::api::caller();
    let principal_id_map = storage::get_mut::<PrincipalIdMap>();
    principal_id_map.insert(principal_id_map, username);

    // if let None == principal_id_map.get(&principal_id) {
    // }
}

#[update]
fn flag_content(url: String) {
    // insert necessary checks for url!
    // check whether url has already been flagged or not

    let principal_id = ic_cdk::api::caller();
    let flag_content_map = storage::get_mut::<FlagContentMap>();
    let id = Uuid::new_v4();
    let flag_content = Content {
        id: id.clone(),
        url: url,
        principal: principal_id,
        created_at: Utc::now(),
        comments: []
    };
    flag_content_map.insert(Uuid::new_v4(), flag_content);
}

#[query]
fn get_content() -> Vec<Content> {
    let flag_content_map = storage::get::<FlagContentMap>();
    return Vec::from_iter(flag_content_map.iter());
}

#[query]
fn testing() {
    flag_content(String::from("This is it"));
    let content = get_content();
    ic_cdk::print("?{}", content);
}