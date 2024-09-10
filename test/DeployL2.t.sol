// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {TestUtils} from "./utils/TestUtils.t.sol";

import {DeployL2} from "@script/DeployL2.s.sol";

contract DeployL2Test is TestUtils {
    function setUp() public override {
        forkNetwork("OZEAN_RPC_URL");
        super.setUp();

        DeployL2 deployL2 = new DeployL2();
        deployL2.run();
    }

    function testInit() public {
        uint256 x;
        assertEq(x, 0);
    }
}