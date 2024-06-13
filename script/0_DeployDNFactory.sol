// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {DNFactory} from "src/DN404Factory.sol";
import "forge-std/Script.sol";

contract SimpleDN404Script is Script {
    function run() public {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPK);
        new DNFactory();

        vm.stopBroadcast();
    }
}
