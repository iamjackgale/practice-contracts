// SPDX-License-Identifier: MIT

// @title IKey.sol
// @author jackgale.eth
// @dev interface for Key.sol, a sample NFT key to objectify permissions.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IKey is IERC721 {

    // @dev Allows any external contract to use the mint function, though this method is access controlled in the contract to Minters only.
    function mint(address recipient) external returns (uint);
}