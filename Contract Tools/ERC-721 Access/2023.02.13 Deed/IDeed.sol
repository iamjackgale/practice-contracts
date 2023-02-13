// SPDX-License-Identifier: MIT

// @title IKey.sol
// @author jackgale.eth
// @dev Interface for Deed.sol, an NFT deed to objectify contract ownership.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IDeed is IERC721 {

    // @dev Allows any external contract to use the mint function, though this method is access controlled in the contract to Minters only.
    function mint(address recipient) external returns (uint);
}