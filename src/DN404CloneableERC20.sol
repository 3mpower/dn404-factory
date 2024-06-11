// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {DN404} from "dn404/DN404.sol";
import {DN404Mirror} from "dn404/DN404Mirror.sol";
import {Ownable} from "solady/auth/Ownable.sol";
import {LibString} from "solady/utils/LibString.sol";
import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
import {Clone} from "solady/utils/Clone.sol";

contract DN404Cloneable is DN404, Ownable, Clone {
    error MaxSupplyExceeded();
    error NotEnoughEth();

    string private _name;
    string private _symbol;
    string private _baseURI;
    uint256 private _maxSupply;
    uint256 private _mintPrice;
    bool private initialized = true;

    function initialize(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        uint256 maxSupply_,
        uint256 mintPrice_,
        uint96 initialTokenSupply,
        address initialSupplyOwner
    ) external payable {
        if (initialized) revert();
        initialized = true;

        _initializeOwner(tx.origin);

        _name = name_;
        _symbol = symbol_;
        _maxSupply = maxSupply_;
        _mintPrice = mintPrice_;
        _baseURI = baseURI_;

        address mirror = address(new DN404Mirror(msg.sender));
        _initializeDN404(initialTokenSupply, initialSupplyOwner, mirror);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function _tokenURI(
        uint256 tokenId
    ) internal view override returns (string memory result) {
        if (bytes(_baseURI).length != 0) {
            result = string(
                abi.encodePacked(_baseURI, LibString.toString(tokenId))
            );
        }
    }

    function setMintPrice(uint256 newPrice) public onlyOwner {
        _mintPrice = newPrice;
    }

    function mintPrice() public view returns (uint256) {
        return _mintPrice;
    }

    function mint(address to, uint256 amount) public payable {
        uint256 requiredAmount = _mintPrice * amount;
        if (msg.value < requiredAmount) revert NotEnoughEth();
        if (totalSupply() + amount > _maxSupply) revert MaxSupplyExceeded();
        _mint(to, amount);
    }

    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function setBaseURI(string calldata baseURI_) public onlyOwner {
        _baseURI = baseURI_;
    }

    function withdraw() public onlyOwner {
        SafeTransferLib.safeTransferAllETH(msg.sender);
    }
}
