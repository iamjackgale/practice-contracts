// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/WETH/IWETH.sol";

contract WETHHandler {

    IWETH weth;
    IERC20 weth20;

    event wethMinted(address sender, uint256 value);
    event wethApproved (address sender, uint256 value);
    event wethUnwrapped(address sender, uint256 value);
    event Log(string functionType, uint gas);

    // Pass WETH address as constructor 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9
    constructor(address _weth) {
        weth = IWETH(_weth);
        weth20 = IERC20(_weth);
    }

    function balanceOf(address sender) public view returns (uint256) {
        return weth20.balanceOf(sender);
    }

    function wrapEth() public payable {
        require(msg.value > 0, "No value transferred!");
        weth.deposit{value : msg.value}();
        weth.transfer(msg.sender, weth20.balanceOf(address(this)));
        emit wethMinted(msg.sender, msg.value);
    }

    // Ensure approved first
    function unwrapWeth(uint256 value) public {
        weth.transferFrom(msg.sender, address(this), value);
        weth.withdraw(value);
        payable(msg.sender).transfer(value);
        emit wethUnwrapped(msg.sender, value);
    }

    receive() external payable {
        emit Log("Receive", gasleft());
    }

    fallback() external payable {
        emit Log("Fallback", gasleft());
    }
}