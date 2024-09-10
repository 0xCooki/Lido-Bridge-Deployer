// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract TestUtils is Test {
    address public alice;
    address public bob;

    function setUp() public virtual {
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        vm.deal(alice, 10000 ether);
        vm.deal(bob, 10000 ether);
    }

    modifier prank(address _user) {
        vm.startPrank(_user);
        _;
        vm.stopPrank();
    }

    function forkNetwork(string memory _key) public {
        string memory rpcURL = vm.envString(_key);
        uint256 mainnetFork = vm.createFork(rpcURL);
        vm.selectFork(mainnetFork);
    }
}
