// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Inbox {
    string public message; //automatically stored with the contract on chain. local variables are stored in the contract but not on chain

    constructor(string memory initialMessage) public {
        //constructor function - auto called once immediately on deployment
        message = initialMessage;
    }

    function setMessage(string memory newMessage) public {
        //public private view constant pure payable etc are "function type declarations"
        message = newMessage;
    }
}
