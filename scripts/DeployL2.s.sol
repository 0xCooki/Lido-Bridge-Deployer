// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Script.sol";

import {OssifiableProxy} from "@lido/proxy/OssifiableProxy.sol";
import {ERC20BridgedPermit} from "@lido/token/ERC20BridgedPermit.sol";
import {ERC20RebasableBridgedPermit} from "@lido/token/ERC20RebasableBridgedPermit.sol";
import {TokenRateOracle} from "@lido/optimism/TokenRateOracle.sol";
import {L2ERC20ExtendedTokensBridge} from "@lido/optimism/L2ERC20ExtendedTokensBridge.sol";
import {OptimismBridgeExecutor} from "@bridge/bridges/OptimismBridgeExecutor.sol";

contract DeployL2 is Script {
    address public owner = 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d;

    /// wstETH
    address l2ERC20ExtendedTokensBridgeOnL2 = address(0); /// Proxy L2ERC20ExtendedTokensBridge on l2 

    /// stETH
    address tokenToWrapFrom; /// address(wstETHProxy)
    address tokenRateOracle; /// address(oracleProxy)
    address bridge; /// = l2ERC20ExtendedTokensBridgeOnL2 

    /// Oracle
    address messenger = 0x4200000000000000000000000000000000000007;
    //address l2ERC20TokenBridge; /// l2ERC20ExtendedTokensBridgeOnL2
    address l1TokenRatePusher = address(0); /// L1 rate pusher address
    uint256 tokenRateOutdatedDelay = 86400;
    uint256 maxAllowedL2ToL1ClockLag = 172800;
    uint256 maxAllowedTokenRateDeviationPerDayBp = 500;
    uint256 oldestRateAllowedInPauseTimeSpan = 86400;
    uint256 minTimeBetweenTokenRateUpdates = 3600;

    /// Bridge
    //address messenger;
    address l1TokenBridge = address(0); /// corresponding L1 bridge
    address l1TokenNonRebasable; /// l1 wsteth
    address l1TokenRebasable; /// l1 steth
    address l2TokenNonRebasable; /// l2 wsteth proxy
    address l2TokenRebasable; /// l2 steth proxy

    /// Executor
    /// address ovmL2CrossDomainMessenger; messenger
    /// address ethereumGovernanceExecutor; owner
    uint256 delay = 0; // The delay before which an actions set can be executed
    uint256 gracePeriod = 86400; // The time period after a delay during which an actions set can be executed
    uint256 minimumDelay = 0; //The minimum bound a delay can be set to
    uint256 maximumDelay = 1; //The maximum bound a delay can be set to
    address guardian; /// can be address(0)

    ERC20BridgedPermit public wstETHImpl;
    OssifiableProxy public wstETHProxy;

    ERC20RebasableBridgedPermit public stETHImpl;
    OssifiableProxy public stETHProxy;

    TokenRateOracle public oracleImpl;
    OssifiableProxy public oracleProxy;

    L2ERC20ExtendedTokensBridge public bridgeImpl;
    OssifiableProxy public bridgeProxy;

    OptimismBridgeExecutor public bridgeExecutor;

    /// @dev Assuming the proxies don't need any calldata
    function run() external broadcast {
        /// Get predicted addresses

        wstETHImpl = new ERC20BridgedPermit("wstETH", "WSTETH", "0", 18, l2ERC20ExtendedTokensBridgeOnL2);
        wstETHProxy = new OssifiableProxy(address(wstETHImpl), owner, "");

        stETHImpl = new ERC20RebasableBridgedPermit("stETH", "STETH", "0", 18, address(wstETHProxy), tokenRateOracle, l2ERC20ExtendedTokensBridgeOnL2);
        stETHProxy = new OssifiableProxy(address(stETHImpl), owner, "");

        oracleImpl = new TokenRateOracle(messenger, l2ERC20ExtendedTokensBridgeOnL2, l1TokenRatePusher, tokenRateOutdatedDelay, maxAllowedL2ToL1ClockLag, maxAllowedTokenRateDeviationPerDayBp, oldestRateAllowedInPauseTimeSpan, minTimeBetweenTokenRateUpdates);
        oracleProxy = new OssifiableProxy(address(oracleImpl), owner, "");

        bridgeImpl = new L2ERC20ExtendedTokensBridge(messenger, l1TokenBridge, l1TokenNonRebasable, l1TokenRebasable, address(wstETHProxy), address(stETHProxy));
        bridgeProxy = new OssifiableProxy(address(bridgeImpl), owner, "");

        bridgeExecutor = new OptimismBridgeExecutor(messenger, owner, delay, gracePeriod, minimumDelay, maximumDelay, guardian);
    }

    /// HELPERS ///

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function _getPredictedAddressess() internal returns (address, address, address, address) {
        /// bridge proxy on L2
        /// L1 rate pusher
        /// L1 bridge
        /// wsteh proxy
        /// steth proxy
        
    }
}