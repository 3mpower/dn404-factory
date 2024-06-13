// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./utils/SoladyTest.sol";
import {DNFactory} from "src/DN404Factory.sol";
import {DN404Cloneable} from "src/DN404Cloneable.sol";
import {DN404Mirror} from "dn404/DN404Mirror.sol";
import "forge-std/console.sol";

contract DNFactoryTest is SoladyTest {
    DNFactory factory;
    address alice = address(111);
    address bob = address(42069);

    //Access variables from .env file via vm.envString("varname")
    // string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    //string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    function setUp() public {
        // vm.createSelectFork(MAINNET_RPC_URL, 19227633);
        vm.prank(alice);
        vm.deal(alice, 20 ether);
        factory = new DNFactory();
    }

    function testDeploy() public {
        address dnAddress = factory.deployDN("DN404", "DN", "https://test.com/", 100e18, 1e18, 1e18);

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));
        DN404Mirror dnMirror = DN404Mirror(payable(dn.mirrorERC721()));

        // DN404
        assertEq(dn.name(), "DN404", "Name does not match");
        assertEq(dn.symbol(), "DN", "Symbol does not match");
        assertEq(dn.maxSupply(), 100e18, "DN404 total supply does not match");

        // DN404Mirror
        assertEq(dnMirror.name(), "DN404", "Name does not match");
        assertEq(dnMirror.symbol(), "DN", "Symbol does not match");
    }

    function testMint() public {
        address dnAddress = factory.deployDN("DN404", "DN", "https://test.com/", 100e18, 1 ether, 0);

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));
        DN404Mirror dnMirror = DN404Mirror(payable(dn.mirrorERC721()));

        dn.mint{value: 10 * 1 ether}(bob, 10e18);
        assertEq(dn.balanceOf(bob), 10e18, "Balance does not match");
        assertEq(dnMirror.balanceOf(bob), 10, "Balance does not match");
        assertEq(dnMirror.totalSupply(), 10, "Total supply does not match");
    }

    function testRefund() public {
        address dnAddress = factory.deployDN("DN404", "DN", "https://test.com/", 100e18, 1e18, 0);

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));
        vm.prank(alice);
        console.log("Before alice balance: ", alice.balance);
        dn.mint{value: 10 * 1.2 ether}(bob, 10e18);
        assertEq(dn.balanceOf(bob), 10e18, "Balance does not match");

        uint256 balanceAfter = alice.balance;
        assertEq(balanceAfter, 10 ether, "Refund does not match");
        console.log("After alice balance: ", balanceAfter);
    }

    function testWithdraw() public {
        address dnAddress = factory.deployDN("DN404", "DN", "https://test.com/", 100e18, 1e18, 1e18);

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));

        uint256 currentTime = block.timestamp;
        vm.warp(currentTime + 60);

        vm.prank(dn.owner());
        dn.withdraw();
    }

}
