// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {TestUtils} from "./utils/TestUtils.t.sol";
import {DeployL1} from "@script/DeployL1.s.sol";

contract DeployL1Test is TestUtils {
    address public deployer = 0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e;
    uint256 public l1Nonce = 21;

    DeployL1 public deployL1;

    function setUp() public override {
        forkNetwork("SEPOLIA_RPC_URL");
        super.setUp();

        deployL1 = new DeployL1();
        deployL1.run();
    }

    function testInit() public prank(deployer) {
        assertEq(address(deployL1.notifier()), _addressFrom(deployer, l1Nonce));
        assertEq(address(deployL1.pusher()), _addressFrom(deployer, ++l1Nonce));
        assertEq(address(deployL1.l1BridgeImpl()), _addressFrom(deployer, ++l1Nonce));
        assertEq(address(deployL1.l1BridgeProxy()), _addressFrom(deployer, ++l1Nonce));
    }
}
