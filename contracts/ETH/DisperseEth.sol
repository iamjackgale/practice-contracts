// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract DisperseEth {

    function disperse(address[] calldata addresses, uint256[] calldata values) public payable {
        for (uint256 i=0; i < addresses.length; i++)
            payable(addresses[i]).transfer(values[i]);
        uint256 balance = address(this).balance;
        if (balance > 0)
            payable(msg.sender).transfer(balance);
    }
}