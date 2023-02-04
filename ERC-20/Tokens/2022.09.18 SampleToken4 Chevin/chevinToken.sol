// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title chevinToken.sol
 * @author jackgale.eth
 * @dev a sample token built on OpenZeppelin's libary of stock contracts for use with other sample contracst. Includes basic minting, burning and pausing functionality, and limiting minting/pausing to the contract owner.
 */

contract SampleToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    constructor() ERC20("Chevin", "CHV") {
        _mint(msg.sender, 100 * (10**uint256(decimals()))); //100 18-decimal tokens
    }

    function mint(address to, uint256 amount) public virtual onlyOwner {
        _mint(to, amount);
    }

    function pause() public virtual onlyOwner {
        _pause();
    }

    function unpause() public virtual onlyOwner {
        _unpause();
    }

    //Having issues with conflict between ERC20 and ERC20Pausable definitions of _beforeTokenTransfer
    //Suggest overriding both with function in top level contract: https://forum.openzeppelin.com/t/typeerror-derived-contract-must-override-function-beforetokentransfer/2469/6
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        ERC20Pausable._beforeTokenTransfer(from, to, amount);
    }
}
