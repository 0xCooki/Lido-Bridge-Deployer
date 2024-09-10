// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";

import {TokenRateNotifier} from "@lido/lido/TokenRateNotifier.sol";
import {OpStackTokenRatePusher} from "@lido/optimism/OpStackTokenRatePusher.sol";
import {L1LidoTokensBridge} from "@lido/optimism/L1LidoTokensBridge.sol";
import {OssifiableProxy} from "@lido/proxy/OssifiableProxy.sol";

/*
- Rate Notifier - this seems to hook directly into Lido core
- Token Rate Pusher 
- Bridge proxy / impl
*/
contract DeployL1 is Script {
    /// Rate notifier
    address public owner = 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d;
    address public lidoCore = 0x3e3FE7dBc6B4C189E7128855dD526361c49b40Af; /// @dev steth

    /// Rate pusher
    address public optimismMessenger = 0x13931872294360cAc551BA3801f061c4C86F0725;
    address public wstETH = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b;
    address public accountingOracle = 0xd497Be005638efCf09F6BFC8DAFBBB0BB72cD991;
    address public tokenRateOracle = address(0); /// @dev corresponds to the address on the L2 - so this must come later (or via create2)
    uint32 public gaslimitForPushing = 300000;
    
    /// Bridge
    address public l2TokenBridge = address(0); /// @dev also corresponds to the address on the L2 
    address public l1TokenNonRebasable = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b; /// @dev wsteth
    /// address public l1TokenRebasable = lidoCore;
    address public l2TokenNonRebasable = address(0); /// @dev wstETH on the L2
    address public l2TokenRebasable = address(0);    /// @dev stETH om the L2
    /// address public accountingOracle = accountingOracle;

    TokenRateNotifier public notifier;
    OpStackTokenRatePusher public pusher;
    L1LidoTokensBridge public l1BridgeImpl;
    OssifiableProxy public l1BridgeProxy;

    function run() external broadcast {
        /// Get predicted addresses

        /// Rate notifier
        notifier = new TokenRateNotifier(owner, lidoCore);

        /// Rate pusher
        pusher = new OpStackTokenRatePusher(optimismMessenger, wstETH, accountingOracle, tokenRateOracle, gaslimitForPushing);

        /// Bridge impl
        l1BridgeImpl = new L1LidoTokensBridge(optimismMessenger, l2TokenBridge, l1TokenNonRebasable, lidoCore, l2TokenNonRebasable, l2TokenRebasable, accountingOracle);

        /// Bridge proxy
        l1BridgeProxy = new OssifiableProxy(address(l1Bridge), owner, "");
    }

    /// HELPERS ///

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function _getPredictedAddressess() internal returns (address) {
        /// token rate oracle
        /// l2TokenBridge
        /// l2TokenNonRebasable
        /// l2TokenRebasable
    }
}