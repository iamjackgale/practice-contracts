// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @title bank.sol
 * @author jackgale.eth
 * @dev Create a simple ERC20 standard token that is exchanged for Ether deposited in the contract 1:1
 */
contract Bank is ERC20, ERC20Burnable {
    constructor(string memory tokenName, string memory tokenSymbol)
        ERC20("Ether Deposit Token", "EDT")
    {}

    function deposit() public payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public payable {
        require(
            _amount > 0,
            "You must state a value to transfer greater than zero."
        );
        require(
            balanceOf(msg.sender) > 0,
            "You must have funds deposited to withdraw."
        );
        require(balanceOf(msg.sender) >= _amount, "Insufficient funds.");
        burn(_amount);
        (bool sent, ) = msg.sender.call{value: _amount}("sent");
        require(sent, "Failed to Complete");
    }

    function withdrawAll() public payable {
        require(
            balanceOf(msg.sender) > 0,
            "You must have funds deposited to withdraw."
        );
        uint256 _amount = balanceOf(msg.sender);
        burn(_amount);
        (bool sent, ) = msg.sender.call{value: _amount}("sent");
        require(sent, "Failed to Complete");
    }
}
