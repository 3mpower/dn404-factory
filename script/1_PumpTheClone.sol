// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {DNFactory} from "src/DN404Factory.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract SimpleDN404Script is Script {
    address factory = 0xAf7178dbEe273Cd78a9cFa3CA1Ea561BC9E7ce74;

    function run() public {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPK);

        DNFactory dnFact = DNFactory(factory);
        address clone = dnFact.deployDN("DN404Clone3", "DNCL3", "https://test.com/", 100e18, 0.000001 ether, 1e18);
        console.log("Deployed DN404Clone at: ", clone);
        vm.stopBroadcast();
    }
}
