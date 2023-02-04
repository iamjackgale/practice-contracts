// SPDX-License-Identifier: MIT

// @title FactoryERC1155.sol
// @author jackgale.eth
// @dev ERC-1155 NFT factory for generating NFT collections with variables URIs set by the Owner.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FactoryERC1155 is ERC1155URIStorage, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    string[] public names;
    uint[] public ids;

    mapping(string => uint) public nameToId;
    mapping(uint => string) public idToName;
    mapping(uint => string) private tokenURIs;

    event NFTMinted(uint256 indexed tokenId, string tokenURI);

    constructor() ERC1155("") {
        for (uint id = 0; id < ids.length; id++) {
            nameToId[names[id]] = ids[id];
            idToName[ids[id]] = names[id];
        }
    }

    function uri(
        uint256 tokenId
    ) public view override(ERC1155URIStorage) returns (string memory) {
        return ERC1155URIStorage.uri(tokenId);
    }

    function setURI(string memory newURI) public onlyOwner {
        _setURI(newURI);
    }

    function mint(
        address account,
        uint _id,
        uint256 amount
    ) public onlyOwner returns (uint) {
        _mint(account, _id, amount, "");
        emit NFTMinted(_id, uri(_id));
        return _id;
    }
}