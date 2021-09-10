export const idlFactory = ({ IDL }) => {
  const TokenError = IDL.Variant({
    'insufficientBalance' : IDL.Null,
    'unknownFail' : IDL.Null,
    'insufficientAllowance' : IDL.Null,
    'notAdmin' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Nat, 'err' : TokenError });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Bool, 'err' : TokenError });
  return IDL.Service({
    'allowance' : IDL.Func(
        [IDL.Principal, IDL.Principal],
        [IDL.Nat],
        ['query'],
      ),
    'balanceOf' : IDL.Func([], [IDL.Nat], ['query']),
    'burn' : IDL.Func([IDL.Nat], [Result], []),
    'decimals' : IDL.Func([], [IDL.Nat], ['query']),
    'decreaseAllowance' : IDL.Func([IDL.Principal, IDL.Nat], [Result_1], []),
    'increaseAllowance' : IDL.Func([IDL.Principal, IDL.Nat], [Result_1], []),
    'mindAndReward' : IDL.Func([IDL.Nat], [Result], []),
    'mint' : IDL.Func([IDL.Nat], [Result], []),
    'name' : IDL.Func([], [IDL.Text], ['query']),
    'symbol' : IDL.Func([], [IDL.Text], ['query']),
    'totalSupply' : IDL.Func([], [IDL.Nat], ['query']),
    'transfer' : IDL.Func([IDL.Principal, IDL.Nat], [Result], []),
    'transferFrom' : IDL.Func(
        [IDL.Principal, IDL.Principal, IDL.Nat],
        [Result],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
