// SPDX-License-Identifier: MIT

// @title KaleidoscopeGenerator.sol
// @author jackgale.eth
// @dev ERC-721 NFT factory for generating Kaleidoscope NFTs
// @deployed Goerli 0x4789085cC5d90458166Ebebb37c049327661112c

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KaleidoscopeGenerator is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Kaleidoscoped(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("KaleidoscopeGenerator", "KALEIDOSCOPE") {}

    function mint(string memory _tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        emit Kaleidoscoped(newItemId, _tokenURI);
        _tokenIds.increment();
        return newItemId;
    }
}
