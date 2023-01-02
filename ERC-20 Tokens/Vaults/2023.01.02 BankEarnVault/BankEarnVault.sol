// SPDX-License-Identifier: MIT

// @title BankEarnVault.sol
// @author jackgale.eth
// @dev bank vault contract with added earning functionality on deposits. Actions user deposits/withdrawals and mints/burns transferrable ERC-20 deposit receipts as evidence of deposits.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BankEarnVault is ERC20 {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address _deployer;
    address _currencyAddress;
    IERC20 currency;

    uint totalDeposits;
    uint earningsNotAccrued;
    uint lastEarnBlock;

    constructor(
        address __currencyAddress
    ) ERC20("Bank Earning Vault Deposit Tokens", "DEPOSIT") {
        _deployer = msg.sender;
        _currencyAddress = __currencyAddress;
        currency = IERC20(_currencyAddress);
        totalDeposits = 0;
        earningsNotAccrued = 0;
        lastEarnBlock = 0;
    }

    function deployer() public view returns (address) {
        return _deployer;
    }

    function currencyAddress() public view returns (address) {
        return _currencyAddress;
    }

    function currencyBalance(
        address holderAddress
    ) public view returns (uint balance) {
        return currency.balanceOf(holderAddress);
    }

    function depositAll() public payable {
        deposit(currency.balanceOf(msg.sender));
    }

    function deposit(uint currencyAmount) public payable {
        require(
            currency.balanceOf(msg.sender) > 0,
            "Caller holds no applicable currency."
        );
        earn();
        uint tokensMinted;
        if ((currency.balanceOf(address(this)) - earningsNotAccrued) == 0) {
            tokensMinted = currencyAmount;
        } else {
            tokensMinted = (currencyAmount.mul(totalDeposits)).div(
                (currency.balanceOf(address(this)) - earningsNotAccrued)
            );
        }
        currency.transferFrom(msg.sender, address(this), currencyAmount);
        _mint(msg.sender, tokensMinted);
        totalDeposits += currencyAmount;
    }

    function withdrawAll() public payable {
        withdraw(balanceOf(msg.sender));
    }

    function withdraw(uint tokenAmount) public payable {
        require(balanceOf(msg.sender) > 0, "Caller holds no deposit tokens.");
        earn();
        uint currencyWithdrawn = tokenAmount
            .mul(currency.balanceOf(address(this)) - earningsNotAccrued)
            .div(totalDeposits);
        _burn(msg.sender, tokenAmount);
        currency.transfer(msg.sender, currencyWithdrawn);
        totalDeposits -= currencyWithdrawn;
    }

    function topup(uint currencyAmount) public payable {
        require(
            currency.balanceOf(msg.sender) > 0,
            "Caller holds no applicable currency."
        );
        earn();
        currency.transferFrom(msg.sender, address(this), currencyAmount);
        earningsNotAccrued += currencyAmount;
    }

    function displayEarningsNotAccrued() public view returns (uint earnings) {
        return earningsNotAccrued;
    }

    function earn() internal {
        uint blocksElapsed = block.number - lastEarnBlock;
        lastEarnBlock = block.number;
        uint earningsAccrued = (earningsNotAccrued / 2556750) * blocksElapsed;
        earningsNotAccrued -= earningsAccrued;
    }
}
