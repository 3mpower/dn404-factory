// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import {DNFactory} from "src/DN404Factory.sol";
import {DN404Cloneable} from "src/DN404Cloneable.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract SimpleDN404Script is Script {
    address dnAddress = 0xC56aAada39F4F7776aae1C7B1a724A1c6ff9B4E6;

    function run() public {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPK);
        // address owner = vm.addr(deployerPK);

        DN404Cloneable dn = DN404Cloneable(payable(dnAddress));
        // address clone = dnFact.deployDN("DN404Clone2", "DNCL2", "https://test.com/", 100e18, 0.1 ether, 1e18);
        dn.mint{value: 0.000004 ether}(0xe93cf8114d86b5Df30c1401E29d743461e07d8D1, 4e18);
        vm.stopBroadcast();
    }
}
