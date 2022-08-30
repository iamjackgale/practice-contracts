pragma solidity ^0.4.17;

contract Inbox {
    string public message; //automatically stored with the contract on chain. local variables are stored in the contract but not on chain

    constructor(string initialMessage) public {
        //constructor function - auto called once immediately on deployment
        message = initialMessage;
    }

    function setMessage(string newMessage) public {
        //public private view constant pure payable etc are "function type declarations"
        message = newMessage;
    }
}
