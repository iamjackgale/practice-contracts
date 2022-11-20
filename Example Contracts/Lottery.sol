// SPDX-License-Identifier: GPL-3.0
// @title Lottery.sol

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address[] public players; //dynamic array

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        //whenever a function allows the contract to receive Ether, it must be labelled as "payable"
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encode(block.difficulty, block.timestamp, players)
                )
            ); //keccak256 is a global function to generate random numbers. Keccak256 is the class of function.
    } //note that keccak256 really can't be trusted (is only pseudo-random), so is only used internally.

    function pickWinner() public restricted {
        //note that modified added before {}
        uint256 index = random() % players.length; //% is the 'modulo' operator - which (e.g. a % b) returns the remainder when you divide a by b. It is used to get an index of the players list.
        address payable winner = payable(players[index]);
        address payable thisContract = payable(address(this));
        winner.transfer(thisContract.balance);
        players = new address[](0); //reset dynamic array to new empty array so that contract can run infinitely. Second set of paranthesis says initial size should be zero. If sum is entered, it will create an array of length sum, where each entry is an empty address (e.g. 0x00000).
    }

    modifier restricted() {
        //modified allows code to be replicated in different functions without duplicating
        require(msg.sender == manager); //only manager can run function.
        _; //replaces remaining function code in place of _;
    }

    function getPlayers() public view returns (address[] memory) {
        //note that from 0.5., you should add the memory keyword for parameters as with "address[]" here
        //make it so that you can access all addresses at once, not just one by one
        return players;
    }
}
