// SPDX-License-Identifier: MIT

// @title test_Deed.js
// @author jackgale.eth
// @dev Testing file for Deed.sol

const { ethers } = require("hardhat")
const { expect, assert } = require("chai");

describe("Deed", function () {
    let user, contractFactory, contract;
    
    beforeEach(async function () {
        user = await ethers.Wallet.createRandom()
        userAddress = user.address
        contractFactory = await ethers.getContractFactory("Deed")
        contract = await contractFactory.deploy()
        ownerAddress = await contract.deployTransaction["from"]
        userBalance = await contract.balanceOf(userAddress)
        userBalanceInt = ethers.utils.formatUnits(userBalance) * (10**18)
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
    })

    // >>> OWNER ACTIONS <<<

    it("(1) Should recognise owner's balance of 0 NFT after deployment:", async function () {
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
        await assert.equal(ownerBalanceInt,0)
    })

    it("(2) Should recognise owner's balance of 1 NFT after mint:", async function () {
        await contract.mint(ownerAddress)
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
        await assert.equal(ownerBalanceInt,1)
    })

    it("(3) Should revert attempt to mint second NFT to owner:", async function () {
        await contract.mint(ownerAddress)
        await expect(contract.mint(ownerAddress)).to.be.revertedWith("Recipient already has a Deed NFT.")
    })

    it("(4) Should recognise owner's balance of 0 NFT after mint and burn", async function () {
        await contract.mint(ownerAddress)
        await contract.burn(0)
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
        await assert.equal(ownerBalanceInt,0)
    })

    // >>> USER INTERACTIONS <<<

    it("(5) Should recognise user's balance of 0 NFT after deployment", async function () {
        await assert.equal(userBalanceInt,0)
    })

    it("(6) Should recognise user's balance of 1 NFT after mint", async function () {
        await contract.mint(userAddress)
        userBalance = await contract.balanceOf(userAddress)
        userBalanceInt = ethers.utils.formatUnits(userBalance) * (10**18)
        await assert.equal(userBalanceInt,1)
    })

    it("(7) Should not recognise user's balance of 2 NFT after 2 mints", async function () {
        await contract.mint(userAddress)
        await expect(contract.mint(userAddress)).to.be.revertedWith("Recipient already has a Deed NFT.")
    })

    // >>> ACCESS <<<

    it("(8) Should allow owner to transfer ownership to user", async function () {
        await contract.transferOwnership(userAddress)
        await expect(contract.mint(userAddress)).to.be.revertedWith("Ownable: caller is not the owner")
    })
})