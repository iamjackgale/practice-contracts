// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title SampleStrategy
 * @author jackgalet.eth
 * @dev Create a sample vault, capable of receiving deposit and withdrawal requests and being topped up, to increase the asset of the vault token holders
 */

contract SampleStrategy {
    using SafeMath for uint256;

    // Tokens used
    address public depositToken; // want = depositToken
    address public vault; // current vault

    constructor(address _want, address _vault) {
        want = _want;
        vault = _vault;
        giveApproval();
    }

    //Doesn't need deposit, withdraw or harvest methods, as funds aren't deposited or handled

    function giveApproval() internal {
        IERC20(depositToken).approve(address(this), type(uint).max); // type(uint).max returns the maximum possible value for type uint
    }

    function removeApproval() internal {
        IERC20(depositToken).approve(address(this), 0); // reset approval to zero
    }
}
