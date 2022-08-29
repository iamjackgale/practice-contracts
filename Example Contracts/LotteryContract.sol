// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address[] public players; //dynamic array

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable { //whenever a function allows the contract to receive Ether, it must be labelled as "payable"
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, players))); //keccak256 is a global function to generate random numbers. Keccak256 is the class of function.
    } //note that keccak256 really can't be trusted, so is only used internally

    function pickWinner() public payable {
        uint index = random() % players.length; //% is the 'modulo' operator - which (e.g. a % b) returns the remainder when you divide a by b. It is used to get an index of the players list.
        address payable winner = payable(players[index]);
        address payable thisContract = payable(address(this));
        winner.transfer(thisContract.balance);
    }
}