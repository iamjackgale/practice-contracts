// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title wallet.sol
 * @author jackgale.eth
 * @dev a simple contract designed to hold a deposit of an authorised amount of Ether, receive payments and allow the user to withdraw any
 * deposits or payments received
 */

contract Wallet {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    function approve(address spender, uint256 amount) external {
        allowances[msg.sender][spender] = amount;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external {
        assert(allowances[from][msg.sender] >= amount); //Assert is used here to test for internal errorrs or check for invariants. As the
        //transfer amount should always be greater than the approved allowance, the contract throws a panic error if this assertion is False.
        allowances[from][msg.sender] -= amount;
        balances[from] -= amount;
        balances[to] += amount;
    }

    function withdraw(uint256 amount) external {
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}
