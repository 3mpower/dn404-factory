// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./utils/SoladyTest.sol";
import {DNFactory} from "src/DN404Factory.sol";
import {DN404Cloneable} from "src/DN404Cloneable.sol";
import {DN404Mirror} from "dn404/DN404Mirror.sol";

contract DNFactoryTest is SoladyTest {
    DNFactory factory;
    address alice = address(111);
    address bob = address(42069);

    //Access variables from .env file via vm.envString("varname")
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    //string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    function setUp() public {
        vm.createSelectFork(MAINNET_RPC_URL, 19227633);
        vm.prank(alice);
        factory = new DNFactory();
    }

    function testDeploy() public {
        address dnAddress = factory.deployDN(
            "DN404",
            "DN",
            "https://test.com/",
            100e18,
            1e18,
            1e18
        );

        assertEq(dnAddress, address(0), "Contract deployment failed");

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));
        DN404Mirror dnMirror = DN404Mirror(payable(dn.mirrorERC721()));

        // DN404
        assertEq(dn.name(), "DN404", "Name does not match");
        assertEq(dn.symbol(), "DN", "Symbol does not match");
        assertEq(dn.totalSupply(), 100e18, "Total supply does not match");

        // DN404Mirror
        assertEq(
            dnMirror.tokenURI(0),
            "https://test.com/",
            "Token URI does not match"
        );
        assertEq(dnMirror.name(), "DN404", "Name does not match");
        assertEq(dnMirror.symbol(), "DN", "Symbol does not match");
        assertEq(dnMirror.totalSupply(), 100e18, "Total supply does not match");
    }

    function testWithdraw() public {
        address dnAddress = factory.deployDN(
            "DN404",
            "DN",
            "https://test.com/",
            100e18,
            1e18,
            1e18
        );

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));

        uint256 currentTime = block.timestamp;
        vm.warp(currentTime + 60);

        vm.prank(dn.owner());
        dn.withdraw();
    }

    function _sum(uint256[] storage array) internal view returns (uint80 sum) {
        for (uint256 i = 0; i < array.length; i++) {
            sum += uint80(array[i]);
        }
    }
}
