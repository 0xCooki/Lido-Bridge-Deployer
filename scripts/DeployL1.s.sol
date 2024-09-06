// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";

import {TokenRateNotifier} from "@lido/lido/TokenRateNotifier.sol";

/*
- Rate Notifier - this seems to hook directly into Lido core, which poses a challenge
- Token Rate Pusher (could probs be consolidated but whatever)
- Bridge proxy
- Bridge impl
*/

contract DeployL1 is Script {
    function run() external broadcast {
        address owner;
        /// Token Rate Notifier
        TokenRateNotifier notifier = new TokenRateNotifier(
            owner,

        );
    }

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }
}