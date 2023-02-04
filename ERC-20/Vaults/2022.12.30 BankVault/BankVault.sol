// SPDX-License-Identifier: MIT

// @title BankVault.sol
// @author jackgale.eth
// @dev simple bank vault contract which actions user deposits/withdrawals and mints/burns transferrable ERC-20 deposit receipts as evidence of deposits.

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//import "@openzeppelin/contracts/access/Ownable.sol";

contract BankVault is ERC20 {
    address _deployer;
    address _currencyAddress;
    IERC20 currency;

    constructor(
        address __currencyAddress
    ) ERC20("Bank Vault Deposit Tokens", "DEPOSIT") {
        _deployer = msg.sender;
        _currencyAddress = __currencyAddress;
        currency = IERC20(_currencyAddress);
    }

    function deployer() public view returns (address) {
        return _deployer;
    }

    function currencyAddress() public view returns (address) {
        return _currencyAddress;
    }

    function currencyBalance() public view returns (uint balance) {
        return currency.balanceOf(msg.sender);
    }

    // Deposit / withdraw methods not currently access controlled, but will need to move to production

    function depositAll() public {
        deposit(currency.balanceOf(msg.sender));
    }

    function deposit(uint amount) public {
        require(
            currency.balanceOf(msg.sender) != 0,
            "Caller holds no applicable currency."
        );
        currency.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function withdrawAll() public {
        withdraw(balanceOf(msg.sender));
    }

    function withdraw(uint amount) public {
        if (balanceOf(msg.sender) == 0) {
            revert("Caller holds no deposit tokens.");
        }
        _burn(msg.sender, amount);
        currency.transfer(msg.sender, amount);
    }
}
