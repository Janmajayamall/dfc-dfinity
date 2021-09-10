export const idlFactory = ({ IDL }) => {
  const UserId = IDL.Principal;
  const Profile = IDL.Record({ 'username' : IDL.Text, 'userId' : UserId });
  const ProfileError = IDL.Variant({
    'userAlreadyExists' : UserId,
    'usernameAlreadyExists' : IDL.Text,
    'profileDoesNotExists' : IDL.Principal,
  });
  const Result = IDL.Variant({ 'ok' : Profile, 'err' : ProfileError });
  const SubscriptionUserProfileEvent = IDL.Variant({
    'didRegisterNewUser' : IDL.Record({
      'userId' : UserId,
      'profile' : Profile,
    }),
  });
  const SubscribeUserProfileEventsData = IDL.Record({
    'callback' : IDL.Func([SubscriptionUserProfileEvent], [], ['oneway']),
  });
  return IDL.Service({
    'getAllUsers' : IDL.Func([], [IDL.Vec(Profile)], []),
    'getMyPrincipal' : IDL.Func([], [IDL.Principal], []),
    'getUserProfile' : IDL.Func([UserId], [Result], ['query']),
    'publishUserProfileEvent' : IDL.Func(
        [SubscriptionUserProfileEvent],
        [],
        ['oneway'],
      ),
    'registerUser' : IDL.Func([IDL.Text], [Result], []),
    'subscribeUserProfileEvents' : IDL.Func(
        [SubscribeUserProfileEventsData],
        [],
        ['oneway'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
