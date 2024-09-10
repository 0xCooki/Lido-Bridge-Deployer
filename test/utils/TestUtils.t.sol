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

    function _addressFrom(address _origin, uint256 _nonce) internal pure returns (address _address) {
        bytes memory _data;
        if (_nonce == 0x00) {
            _data = abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x80));
        } else if (_nonce <= 0x7f) {
            _data = abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, uint8(_nonce));
        } else if (_nonce <= 0xff) {
            _data = abi.encodePacked(bytes1(0xd7), bytes1(0x94), _origin, bytes1(0x81), uint8(_nonce));
        } else if (_nonce <= 0xffff) {
            _data = abi.encodePacked(bytes1(0xd8), bytes1(0x94), _origin, bytes1(0x82), uint16(_nonce));
        } else if (_nonce <= 0xffffff) {
            _data = abi.encodePacked(bytes1(0xd9), bytes1(0x94), _origin, bytes1(0x83), uint24(_nonce));
        } else {
            _data = abi.encodePacked(bytes1(0xda), bytes1(0x94), _origin, bytes1(0x84), uint32(_nonce));
        }
        bytes32 _hash = keccak256(_data);
        assembly {
            mstore(0, _hash)
            _address := mload(0)
        }
    }
}
