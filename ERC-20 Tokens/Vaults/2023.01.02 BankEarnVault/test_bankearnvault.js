const {ethers} = require("hardhat")
const {expect,assert} = require("chai")
const { waffle } = require("hardhat");
const { deployContract } = waffle;

describe("BankEarnVault", function () {
    
    let currency, contract, deployer

    beforeEach(async function () {
        currencyFactory = await ethers.getContractFactory("Currency")
        currency = await currencyFactory.deploy()
        contractFactory = await ethers.getContractFactory("BankEarnVault")
        contract = await contractFactory.deploy(currency.address)
        deployer = await contract.deployer()
        await currency.mint(deployer,100)
    })

    it("(1) deployer() returns deployer.", async function () {
        returnedDeployer = await contract.deployer()
        assert.equal(returnedDeployer, deployer)
    })

    it("(2) currencyAddress() returns deployment address of currency.", async function () {
        currencyAddress = await contract.currencyAddress()
        assert.equal(currencyAddress, currency.address)
    })

    it("(3) currencyBalance(owner) returns amount minted to owner.", async function () {
        currencyBalance = await contract.currencyBalance(deployer)
        assert.equal(currencyBalance,100)
    })

    it("(4) deposit() results in correct amounts for currency.balanceOf(deployer) and balanceOf(deployer).", async function () {
        await currency.approve(contract.address,50)
        await contract.deposit(50)
        currencyBalance = await contract.currencyBalance(deployer)
        //contractBalance = await contract.balanceOf(deployer)
        assert.equal(currencyBalance,50) //|| assert.equal(contractBalance,50)
    })

    it("(5) depositAll() results in nothing for currency.balanceOf(deployer) and full amount of minted currency for balanceOf(deployer).", async function () {
        await currency.approve(contract.address,currency.balanceOf(deployer))
        await contract.depositAll()
        currencyBalance = await contract.currencyBalance(deployer)
        contractBalance = await contract.balanceOf(deployer)
        assert.equal(currencyBalance,0) || assert.equal(contractBalance,100)
    })

    it("(6) withdraw() results in correct amount for currency.balanceOf(deployer) and balanceOf(deployer).", async function () {
        await currency.approve(contract.address,100)
        await contract.depositAll()
        await contract.withdraw(50)
        currencyBalance = await contract.currencyBalance(deployer)
        contractBalance = await contract.balanceOf(deployer)
        assert.equal(currencyBalance,50) || assert.equal(contractBalance,50)
    })

    it("(7) withdrawAll() results in nothing for balanceOf(deployer) and correct amount for currency.balanceOf(deployer).", async function () {
        await currency.approve(contract.address,100)
        await contract.deposit(100)
        await contract.withdrawAll()
        currencyBalance = await contract.currencyBalance(deployer)
        contractBalance = await contract.balanceOf(deployer)
        assert.equal(
            currencyBalance, 100
            || contractBalance, 0
        )
    })

    it("(8) won't facilitate withdrawals where deposit tokens have been transferred away from the depositor.", async function () {
        await currency.approve(contract.address,100)
        await contract.deposit(100)
        await contract.transfer("0x0000000000000000000000000000000000000001",100)
        await expect(contract.withdrawAll()).to.be.revertedWith("Caller holds no deposit tokens.");
    })

    it("(9) accepts topup and display in displayEarningsNotAccrued().", async function() {
        mint = await currency.mint(deployer, 110)
        approve = await currency.approve(contract.address,110)
        topup = await contract.topup(100)
        earningsNotAccrued = await contract.displayEarningsNotAccrued()
        assert.equal(earningsNotAccrued, 100)
    })
})