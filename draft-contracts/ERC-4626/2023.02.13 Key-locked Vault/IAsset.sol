// SPDX-License-Identifier: MIT

// @title iAsset.sol
// @author jackgale.eth
// @dev interface for sample asset to allow external minting.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAsset is IERC20 {

    // @dev Allows any contract to interface with asset.sol to mint sample ERC-20 tokens.
    function mint(address caller, uint amount) external;
}