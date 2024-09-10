// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {TestUtils} from "./utils/TestUtils.t.sol";

import {DeployL1} from "@script/DeployL1.s.sol";

contract DeployL1Test is TestUtils {
    function setUp() public override {
        forkNetwork("SEPOLIA_RPC_URL");
        super.setUp();

        DeployL1 deployL1 = new DeployL1();
        deployL1.run();
    }

    function testInit() public {
        uint256 x;
        assertEq(x, 0);
    }
}