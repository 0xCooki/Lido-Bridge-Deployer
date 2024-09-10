// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {TestUtils} from "./utils/TestUtils.t.sol";
import {DeployL1, TokenRateNotifier} from "@script/DeployL1.s.sol";

contract DeployL1Test is TestUtils {
    function setUp() public override {
        forkNetwork("SEPOLIA_RPC_URL");
        super.setUp();

        DeployL1 deployL1 = new DeployL1();
        deployL1.run();
    }

    function testInit() public prank(0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e) {
        uint256 x;
        assertEq(x, 0);
    }
}
