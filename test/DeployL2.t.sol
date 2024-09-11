// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {TestUtils} from "./utils/TestUtils.t.sol";
import {DeployL2} from "@script/DeployL2.s.sol";

contract DeployL2Test is TestUtils {
    address public deployer = 0xa2ef4A5fB028b4543700AC83e87a0B8b4572202e;
    uint256 public l1Nonce = 21;
    uint256 public l2Nonce = 0;

    DeployL2 public deployL2;

    function setUp() public override {
        forkNetwork("OZEAN_RPC_URL");
        super.setUp();

        deployL2 = new DeployL2();
        deployL2.run();
    }

    function testInit() public {
        assertEq(address(deployL2.oracleImpl()), _addressFrom(deployer, l2Nonce));
        assertEq(address(deployL2.oracleProxy()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.wstETHImpl()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.wstETHProxy()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.stETHImpl()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.stETHProxy()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.bridgeImpl()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.bridgeProxy()), _addressFrom(deployer, ++l2Nonce));
        assertEq(address(deployL2.bridgeExecutor()), _addressFrom(deployer, ++l2Nonce));
    }
}
