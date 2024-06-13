// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {LibClone} from "solady/utils/LibClone.sol";
import {DN404Cloneable} from "./DN404Cloneable.sol";

contract DNFactory {
    error FailedToInitialize();

    address public immutable implementation;

    constructor() {
        DN404Cloneable dn = new DN404Cloneable();
        implementation = address(dn);
    }

    function deployDN(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        uint256 maxSupply_,
        uint256 mintPrice_,
        uint96 teamAllocation_
    ) external returns (address tokenAddress) {
        tokenAddress = LibClone.cloneDeterministic(implementation, keccak256(abi.encodePacked(name_)));
        (bool success,) = tokenAddress.call(
            abi.encodeWithSelector(
                DN404Cloneable.initialize.selector, name_, symbol_, baseURI_, maxSupply_, mintPrice_, teamAllocation_
            )
        );

        if (!success) revert FailedToInitialize();
    }
}
