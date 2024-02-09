# Bank Vault Contract Specification

A bank vault smart contract with two core features:

1. Holding customer deposits (in exchange for a deposit receipt); and
2. Accruing earnings/interest on customer deposits.

This includes:

- BankVault.sol - which does not include interest/earnings; and
- BankEarnVault.sol - which does include interest/earnings.

Each vault relies on the selection of a currency for use by the vault, which is called as constructor argument on deployment. For the purposes of the test vaults, we have adopted the Currency.sol ERC-20 token.

## Currency Token

For testing purposes, it is in some places necessary to use an ERC-20 token, rather than the native token of the relevant chain (e.g. ETH). To assist, the Currency.sol contract implements a basic ERC-20 testing token, to test the functionality of the BankVault.sol contract.

**Note that Currency.sol must be deployed before BankVault.sol to use the deployed address of the currency as the constructor for the vault.**

## Methods

The Bank Vault contracts come with a range of standard functionality:

### deposit(currnecyAmount) and depositAll()

Standard deposit functions which transfers the user's assets into the bank vault, and mints a deposit token to reflect the value of the deposit.

Where earning functionality is included, every deposit method triggers an earn() call, and total deposits are tracked using the following:

    totalDeposits += amount

The number of tokens minted must change to reflect the amount of currency already held by the contract, such that:

    tokensMinted = currencyAmount * totalDeposits / (currency.balanceOf(address(this)) - earningsNotAccrued)

### withdraw(tokenAmount) and withdrawAll()

Standard withdraw functions which burns the user's deposit tokens, and returns the proportional amount of the user's assets from the bank vault.

Where earning functionality is included, every withdraw method triggers an earn() call, and amount of currency for withdrawal is calculated as:

    currencyWithdrawn = tokenAmount * (currency.balanceOf(address(this)) - earningsNotAccrued) / totalDeposits

### topUp(amount)

Special deposit function which does not mint deposit tokens, and uses the deposited funds to pay out as earnings/interest on user deposits.

Every top up method triggers an earn() call, and the total amount of funds deposited for top ups is tracked using the following:

    earningsNotAccrued += amount

The amount of top up is divided into earnings accrued and earnings not yet accrued, using the following logic:

    currencyAvailableForWithdrawal = currency.balanceOf(address(this)) - earningsNotAccrued

### earn()

The earn mechanism has several core aspects:

    // Identify blocks elapsed since last earn, and reset counter.
    blocksElapsed = block.number - lastEarnBlock;
    lastEarnBlock = block.number;

    // Calculate earnings to accrue given blocks elapsed, and subtract from earnings not accrued.
    earningsAccrued = earningsNotAccrued / 2,556,750 * blocksElapsed;
    earningsNotAccrued -= earningsAccrued;

Works on an assumption of 7,000 blocks per day, or 2,556,750 blocks per year.
