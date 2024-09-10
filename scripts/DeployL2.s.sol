// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";

import {OssifiableProxy} from "@lido/proxy/OssifiableProxy.sol";
import {ERC20BridgedPermit} from "@lido/token/ERC20BridgedPermit.sol";

/*
- wstETHERC20BridgePermit proxy / impl
- stETHERC20RebasableBridgePermit proxy / impl
- Token Rate Oracle proxy / impl
- L2ERC20ExtendedTokensBridge proxy / impl
- Op Gov Bridge executor
*/
contract DeployL2 is Script {
    address public optimismMessenger = 0x13931872294360cAc551BA3801f061c4C86F0725;

    ERC20BridgedPermit public wstETHImpl;
    OssifiableProxy public wstETHProxy;

    function run() external broadcast {
        /*
        /// @param messenger_ L2 messenger address being used for cross-chain communications
        /// @param l2ERC20TokenBridge_ the bridge address that has a right to updates oracle.
        /// @param l1TokenRatePusher_ An address of account on L1 that can update token rate.
        /// @param tokenRateOutdatedDelay_ time period when token rate can be considered outdated.
        /// @param maxAllowedL2ToL1ClockLag_ A time difference between received l1Timestamp and L2 block.timestamp
        ///         when token rate can be considered outdated.
        /// @param maxAllowedTokenRateDeviationPerDayBp_ Allowed token rate deviation per day in basic points.
        ///        Can't be bigger than BASIS_POINT_SCALE.
        /// @param oldestRateAllowedInPauseTimeSpan_ Maximum allowed time difference between the current time
        ///        and the last received token rate update that can be set during a pause.
        /// @param minTimeBetweenTokenRateUpdates_ Minimum delta time between two
        ///        L1 timestamps of token rate updates.
        */

        /// wstETH impl
        wstETHImpl = new ERC20BridgedPermit();

        /// wstETH proxy

        
    }

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }
}