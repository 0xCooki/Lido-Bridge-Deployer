// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Script.sol";

import {TokenRateNotifier} from "@lido/lido/TokenRateNotifier.sol";
import {OpStackTokenRatePusher} from "@lido/optimism/OpStackTokenRatePusher.sol";
import {L1LidoTokensBridge} from "@lido/optimism/L1LidoTokensBridge.sol";
import {OssifiableProxy} from "@lido/proxy/OssifiableProxy.sol";
import {Address} from "./Address.sol";

contract DeployL1 is Script, Address {
    address public owner = 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d;
    address public lidoCore = 0x3e3FE7dBc6B4C189E7128855dD526361c49b40Af; /// @dev steth
    address public l1TokenNonRebasable = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b; /// @dev wsteth
    address public optimismMessenger = 0x13931872294360cAc551BA3801f061c4C86F0725;
    address public accountingOracle = 0xd497Be005638efCf09F6BFC8DAFBBB0BB72cD991;

    uint32 public gaslimitForPushing = 300000;

    TokenRateNotifier public notifier;
    OpStackTokenRatePusher public pusher;
    L1LidoTokensBridge public l1BridgeImpl;
    OssifiableProxy public l1BridgeProxy;

    function run() external broadcast {
        /// Get predicted addresses
        (, address predictedOracle,, address predictedWstETH,, address predictedStETH,, address predictedBridge,) = _getL2PredictedAddressess(0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e, 9);

        /// Rate notifier
        notifier = new TokenRateNotifier(owner, lidoCore);

        /// Rate pusher
        pusher = new OpStackTokenRatePusher(optimismMessenger, l1TokenNonRebasable, accountingOracle, predictedOracle, gaslimitForPushing);

        /// Bridge Impl and Proxy
        l1BridgeImpl = new L1LidoTokensBridge(optimismMessenger, predictedBridge, l1TokenNonRebasable, lidoCore, predictedWstETH, predictedStETH, accountingOracle);
        l1BridgeProxy = new OssifiableProxy(
            address(l1BridgeImpl), 
            owner, 
            abi.encodeWithSelector(
                bytes4(keccak256("initialize(address)")),
                owner
            )
        );
    }

    /// HELPERS ///

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function _getL2PredictedAddressess(address _sender, uint256 _nonce) internal pure returns (address a, address b, address c, address d, address e, address f, address g, address h, address i) {
        a = _addressFrom(_sender, _nonce);
        b = _addressFrom(_sender, _nonce + 1);
        c = _addressFrom(_sender, _nonce + 2);
        d = _addressFrom(_sender, _nonce + 3);
        e = _addressFrom(_sender, _nonce + 4);
        f = _addressFrom(_sender, _nonce + 5);
        g = _addressFrom(_sender, _nonce + 6);
        h = _addressFrom(_sender, _nonce + 7);
        i = _addressFrom(_sender, _nonce + 8);
    }
}