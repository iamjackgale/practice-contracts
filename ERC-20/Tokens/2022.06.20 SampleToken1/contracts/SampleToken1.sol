// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("JackGaleToken", "JG") {
        //ERC20 arguments are ("token name", "token initials")
        _mint(msg.sender, 10 * (1000000**uint256(decimals()))); //_mint arguments are (mint recipient, number of tokens minted)
    }
}
