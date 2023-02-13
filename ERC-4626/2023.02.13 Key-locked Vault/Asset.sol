// SPDX-License-Identifier: MIT

// @title Asset.sol
// @author jackgale.eth
// @dev sample asset for use with test vault contracts.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IAsset.sol";

contract Asset is ERC20, IAsset {
    address _deployer;

    constructor() ERC20("Currency Token", "$$$") {
        _deployer = msg.sender;
    }

    function deployer() public view returns (address) {
        return _deployer;
    }

    function mint(address caller, uint amount) public {
        _mint(caller, amount);
    }
}