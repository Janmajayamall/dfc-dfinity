 dfx canister call dfc createProfile '("newUser")'
 dfx canister call dfc flagContent '(variant {twitter},"1415168029764186116")'
 dfx canister call dfc flagContent '(variant {twitter},"1410462056495542277")'
 dfx canister call dfc addComment '("0", "this is the comment")'
 dfx canister call dfc addComment '("0", "this is 2nd the comment")'
 dfx canister call dfc addComment '("1", "this is a comment on 2nd content")'
 dfx canister call dfc addComment '("1", "this is second content comment")'
 dfx canister call dfc addRating '("0", true)'
 dfx canister call dfc addRating '("1", false)'