// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";

import {TokenRateNotifier} from "@lido/lido/TokenRateNotifier.sol";
import {OpStackTokenRatePusher} from "@lido/optimism/OpStackTokenRatePusher.sol";

/*
- Rate Notifier - this seems to hook directly into Lido core
- Token Rate Pusher 
- Bridge proxy / impl
*/
contract DeployL1 is Script {
    address public owner = 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d;
    address public lidoCore = 0x3e3FE7dBc6B4C189E7128855dD526361c49b40Af;

    address public optimismMessenger = 0x13931872294360cAc551BA3801f061c4C86F0725;
    address public wstETH = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b;
    address public accountingOracle = 0xd497Be005638efCf09F6BFC8DAFBBB0BB72cD991;
    address public tokenRateOracle = 0xB34F2747BCd9BCC4107A0ccEb43D5dcdd7Fabf89; /// @dev corresponds to the address on the L2
    uint32 public gaslimitForPushing = 300000;

    TokenRateNotifier public notifier;
    OpStackTokenRatePusher public pusher;

    function run() external broadcast {
        /// Rate notifier
        notifier = new TokenRateNotifier(owner, lidoCore);
        /// Rate pusher
        pusher = new OpStackTokenRatePusher(optimismMessenger, wstETH, accountingOracle, tokenRateOracle, gaslimitForPushing);

        ///

    }

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }
}