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

    event DNTransfer(address indexed from, address indexed to, uint256 tokenId);
    // event MintLog(address indexed to, uint256 amount);
    // 0x31f718d8f292caffaa57a35771124aaafd9ae788b83c2859405627d6de9b6c3e

    bytes32 constant _NFT_TRANSFER_EVENT_SIGNATURE = 0x31f718d8f292caffaa57a35771124aaafd9ae788b83c2859405627d6de9b6c3e;

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
        uint96 teamAllocation_
    ) external {
        if (initialized) revert();
        initialized = true;

        _initializeOwner(tx.origin);

        _name = name_;
        _symbol = symbol_;
        _maxSupply = maxSupply_;
        _mintPrice = mintPrice_;
        _baseURI = baseURI_;

        address mirror = address(new DN404Mirror(msg.sender));
        _initializeDN404(teamAllocation_, tx.origin, mirror);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function _tokenURI(uint256 tokenId) internal view override returns (string memory result) {
        if (bytes(_baseURI).length != 0) {
            result = string(abi.encodePacked(_baseURI, LibString.toString(tokenId)));
        }
    }

    function setMintPrice(uint256 newPrice) public onlyOwner {
        _mintPrice = newPrice;
    }

    function mintPrice() public view returns (uint256) {
        return _mintPrice;
    }

    function mint(address to, uint256 amount) public payable {
        if (totalSupply() + amount > _maxSupply) revert MaxSupplyExceeded();
        _mint(to, amount);
        refundIfOver(_mintPrice * (amount / 1e18));
        // emit MintLog(to, amount);
    }

    function refundIfOver(uint256 price) private {
        if (msg.value < price) revert NotEnoughEth();

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
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

    /// @dev Override this function to return true if `_afterNFTTransfers` is used.
    /// This is to help the compiler avoid producing dead bytecode.
    function _useAfterNFTTransfers() internal pure override(DN404) returns (bool) {
        return true;
    }

    /// @dev Hook that is called after a batch of NFT transfers.
    /// The lengths of `from`, `to`, and `ids` are guaranteed to be the same.
    function _afterNFTTransfers(address[] memory from, address[] memory to, uint256[] memory ids)
        internal
        override(DN404)
    {
        for (uint256 i = 0; i < ids.length; i++) {
            emit DNTransfer(from[i], to[i], ids[i]);
        }
    }

    // function logNftTransfer(address from, address to, uint256 tokenId) public {
    //     assembly {
    //         // Emit the {Transfer} event.
    //         mstore(0x00, tokenId)
    //         mstore(0x20, from)
    //         log3(0x00, 0x20, _NFT_TRANSFER_EVENT_SIGNATURE, 0, shr(96, shl(96, to)))
    //     }
    // }
}
