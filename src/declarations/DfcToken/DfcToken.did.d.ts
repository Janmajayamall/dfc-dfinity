import type { Principal } from '@dfinity/principal';
export type Result = { 'ok' : bigint } |
  { 'err' : TokenError };
export type Result_1 = { 'ok' : boolean } |
  { 'err' : TokenError };
export type TokenError = { 'insufficientBalance' : null } |
  { 'unknownFail' : null } |
  { 'insufficientAllowance' : null } |
  { 'notAdmin' : null };
export interface _SERVICE {
  'allowance' : (arg_0: Principal, arg_1: Principal) => Promise<bigint>,
  'balanceOf' : () => Promise<bigint>,
  'burn' : (arg_0: bigint) => Promise<Result>,
  'decimals' : () => Promise<bigint>,
  'decreaseAllowance' : (arg_0: Principal, arg_1: bigint) => Promise<Result_1>,
  'increaseAllowance' : (arg_0: Principal, arg_1: bigint) => Promise<Result_1>,
  'mindAndReward' : (arg_0: bigint) => Promise<Result>,
  'mint' : (arg_0: bigint) => Promise<Result>,
  'name' : () => Promise<string>,
  'symbol' : () => Promise<string>,
  'totalSupply' : () => Promise<bigint>,
  'transfer' : (arg_0: Principal, arg_1: bigint) => Promise<Result>,
  'transferFrom' : (
      arg_0: Principal,
      arg_1: Principal,
      arg_2: bigint,
    ) => Promise<Result>,
}
