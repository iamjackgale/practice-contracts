// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @title SampleToken3
 * @author jackgale.eth
 * @dev a sample token built on OpenZeppelin's libary of stock contracts for use with other sample contracst. Includes basic minting and burning functionality.
 */

contract SampleToken is ERC20, ERC20Burnable {
    constructor() ERC20("SampleToken", "ST") {
        _mint(msg.sender, 100 * (10**uint256(decimals()))); //100 18-decimal tokens
    }

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }

    function _burn(uint256 amount) public virtual {
        burn(amount);
    }
}
