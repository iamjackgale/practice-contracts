// SPDX-License-Identifier: MIT

// @title NFTFactory1.sol
// @author jackgale.eth
// @dev ERC-721 NFT factory for generating NFTs with a specified URI, including burn methods.

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTFactory1 is ERC721URIStorage, ERC721Burnable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("Sample Collection", "sNFT") {}

    function mint(string memory _tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        _tokenURIs[newItemId] = _tokenURI;
        emit NFTMinted(newItemId, _tokenURI);
        _tokenIds.increment();
        return newItemId;
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

    function _burn(
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}
