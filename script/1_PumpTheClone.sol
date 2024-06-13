// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {DNFactory} from "src/DN404Factory.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract SimpleDN404Script is Script {
    address factory = 0xaFf32cdE2E3fbb053953afEeC9b988414d04AfA0;

    function run() public {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPK);

        DNFactory dnFact = DNFactory(factory);
        address clone = dnFact.deployDN("DN404Clone2", "DNCL2", "https://test.com/", 100e18, 0.1 ether, 1e18);
        console.log("Deployed DN404Clone at: ", clone);
        vm.stopBroadcast();
    }
}
