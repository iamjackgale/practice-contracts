// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @title bank.sol
 * @author jackgale.eth
 * @dev Create a simple ERC20 standard vault for ether, and a token that is exchanged for Ether deposited in the contract 1:1
 */
contract Bank is ERC20, ERC20Burnable {
    mapping(address => uint256) public balances;

    constructor(string memory tokenName, string memory tokenSymbol)
        ERC20("Ether Deposit Token", "EDT")
    {}

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public payable {
        require(balances[msg.sender] >= _amount, "Insufficient funds.");
        balances[msg.sender] -= _amount;
        (bool sent, ) = msg.sender.call{value: _amount}("sent");
        require(sent, "Failed to Complete");
    }

    function withdrawAll() public payable {
        balances[msg.sender] -= balances[msg.sender];
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("sent");
        require(sent, "Failed to Complete");
    }

    function getBal() public view returns (uint256) {
        return (address(this).balance);
    }
}
