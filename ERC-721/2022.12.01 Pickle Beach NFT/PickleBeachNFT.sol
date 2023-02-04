// SPDX-License-Identifier: MIT

// @title PickleBeachNFT.sol
// @author jackgale.eth
// @dev my first personalised NFT, which simply mints my stock profile picture as an NFT to the caller.

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract PickleBeachNFT is ERC721URIStorage {
    constructor() ERC721("PickleBeachNFT", "PICKLES") {
        _mint(msg.sender, 1);
        _setTokenURI(
            1,
            "https://ipfs.io/ipfs/QmNxJvbjJxy4v5p4zMf4CgfyLBECxq8unMrMLXytv7VZeB"
        );
    }
}
