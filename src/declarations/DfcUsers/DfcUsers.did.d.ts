import type { Principal } from '@dfinity/principal';
export interface Profile { 'username' : string, 'userId' : UserId }
export type ProfileError = { 'userAlreadyExists' : UserId } |
  { 'usernameAlreadyExists' : string } |
  { 'profileDoesNotExists' : Principal };
export type Result = { 'ok' : Profile } |
  { 'err' : ProfileError };
export interface SubscribeUserProfileEventsData {
  'callback' : [Principal, string],
}
export type SubscriptionUserProfileEvent = {
    'didRegisterNewUser' : { 'userId' : UserId, 'profile' : Profile }
  };
export type UserId = Principal;
export interface _SERVICE {
  'getAllUsers' : () => Promise<Array<Profile>>,
  'getMyPrincipal' : () => Promise<Principal>,
  'getUserProfile' : (arg_0: UserId) => Promise<Result>,
  'publishUserProfileEvent' : (arg_0: SubscriptionUserProfileEvent) => Promise<
      undefined
    >,
  'registerUser' : (arg_0: string) => Promise<Result>,
  'subscribeUserProfileEvents' : (
      arg_0: SubscribeUserProfileEventsData,
    ) => Promise<undefined>,
}
