// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Script.sol";

import {OssifiableProxy} from "@lido/proxy/OssifiableProxy.sol";
import {ERC20BridgedPermit} from "@lido/token/ERC20BridgedPermit.sol";
import {ERC20RebasableBridgedPermit} from "@lido/token/ERC20RebasableBridgedPermit.sol";
import {TokenRateOracle} from "@lido/optimism/TokenRateOracle.sol";
import {L2ERC20ExtendedTokensBridge} from "@lido/optimism/L2ERC20ExtendedTokensBridge.sol";
import {OptimismBridgeExecutor} from "@bridge/bridges/OptimismBridgeExecutor.sol";
import {Address} from "./Address.sol";

contract DeployL2 is Script, Address {
    address public owner = 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d;
    address public messenger = 0x4200000000000000000000000000000000000007;
    address public l1TokenNonRebasable = 0xB82381A3fBD3FaFA77B3a7bE693342618240067b; /// l1 wsteth
    address public l1TokenRebasable = 0x3e3FE7dBc6B4C189E7128855dD526361c49b40Af; /// l1 steth
    address public guardian; /// can be address(0)

    uint256 public tokenRateOutdatedDelay = 86400;
    uint256 public maxAllowedL2ToL1ClockLag = 172800;
    uint256 public maxAllowedTokenRateDeviationPerDayBp = 500;
    uint256 public oldestRateAllowedInPauseTimeSpan = 86400;
    uint256 public minTimeBetweenTokenRateUpdates = 3600;
    uint256 public tokenRate = 1000368694572477596 * 10 ** 9; /// wstETH/stETH (normalised for 27 decimals)
    uint256 public delay = 0; // The delay before which an actions set can be executed
    uint256 public gracePeriod = 86400; // The time period after a delay during which an actions set can be executed
    uint256 public minimumDelay = 0; //The minimum bound a delay can be set to
    uint256 public maximumDelay = 1; //The maximum bound a delay can be set to

    TokenRateOracle public oracleImpl;
    OssifiableProxy public oracleProxy;

    ERC20BridgedPermit public wstETHImpl;
    OssifiableProxy public wstETHProxy;

    ERC20RebasableBridgedPermit public stETHImpl;
    OssifiableProxy public stETHProxy;

    L2ERC20ExtendedTokensBridge public bridgeImpl;
    OssifiableProxy public bridgeProxy;

    OptimismBridgeExecutor public bridgeExecutor;

    function run() external broadcast {
        /// Get predicted addresses
        (, address predictedL1Pusher,, address predictedL1Bridge) = _getL1PredictedAddressess(0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e, 25);
        (, address predictedOracle,,,, address predictedStETH,, address predictedL2Bridge,) = _getL2PredictedAddressess(0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e, 9);

        oracleImpl = new TokenRateOracle(messenger, predictedL2Bridge,  predictedL1Pusher, tokenRateOutdatedDelay, maxAllowedL2ToL1ClockLag, maxAllowedTokenRateDeviationPerDayBp, oldestRateAllowedInPauseTimeSpan, minTimeBetweenTokenRateUpdates);
        oracleProxy = new OssifiableProxy(
            address(oracleImpl),
            owner,
            abi.encodeWithSelector(
                bytes4(keccak256("initialize(address,uint256,uint256)")),
                owner,
                tokenRate,
                block.timestamp
            )
        );

        wstETHImpl = new ERC20BridgedPermit("wstETH", "WSTETH", "0", 18, predictedL2Bridge);
        wstETHProxy = new OssifiableProxy(
            address(wstETHImpl),
            owner,
            abi.encodeWithSelector(
                bytes4(keccak256("initialize(string,string,string)")),
                "wstETH",
                "WSTETH",
                "0"
            )
        );

        stETHImpl = new ERC20RebasableBridgedPermit("stETH", "STETH", "0", 18, address(wstETHProxy), predictedOracle, predictedL2Bridge);
        stETHProxy = new OssifiableProxy(
            address(stETHImpl),
            owner,
            abi.encodeWithSelector(
                bytes4(keccak256("initialize(string,string,string)")),
                "stETH",
                "STETH",
                "0"
            )
        );

        bridgeImpl = new L2ERC20ExtendedTokensBridge(messenger, predictedL1Bridge, l1TokenNonRebasable, l1TokenRebasable, address(wstETHProxy), address(stETHProxy));
        bridgeProxy = new OssifiableProxy(
            address(bridgeImpl),
            owner,
            abi.encodeWithSelector(
                bytes4(keccak256("initialize(address)")),
                owner
            )
        );

        bridgeExecutor = new OptimismBridgeExecutor(messenger, owner, delay, gracePeriod, minimumDelay, maximumDelay, guardian);
    }

    /// HELPERS ///

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function _getL1PredictedAddressess(address _sender, uint256 _nonce) internal pure returns (address a, address b, address c, address d) {
        a = _addressFrom(_sender, _nonce);
        b = _addressFrom(_sender, _nonce + 1);
        c = _addressFrom(_sender, _nonce + 2);
        d = _addressFrom(_sender, _nonce + 3);
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