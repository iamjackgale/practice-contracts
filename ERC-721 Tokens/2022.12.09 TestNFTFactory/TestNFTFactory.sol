// SPDX-License-Identifier: MIT

// @title TestNFTFactory.sol
// @author jackgale.eth
// @dev ERC-721 NFT factory for generating test NFTs

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestNFTFactory is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event TestNFTDeployed(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("jackgale.eth Test NFTs", "tNFT") {}

    function mint(string memory _tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        emit TestNFTDeployed(newItemId, _tokenURI);
        _tokenIds.increment();
        return newItemId;
    }
}
