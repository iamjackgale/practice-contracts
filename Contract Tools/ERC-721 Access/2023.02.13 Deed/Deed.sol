// SPDX-License-Identifier: MIT

// @title Deed.sol
// @author jackgale.eth
// @dev ERC-721 contract to mint an NFT deed to object contract ownership.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Deed is ERC721Burnable, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Contract Deed", "DEED") {}

    function mint(address recipient) public onlyOwner returns(uint) {
        require((_tokenIds.current() < 1), "Recipient already has a Deed NFT.");
        uint newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _tokenIds.increment();
        return newItemId;
    }
}