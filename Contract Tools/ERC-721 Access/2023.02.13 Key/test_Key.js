// SPDX-License-Identifier: MIT

// @title test_Key.js
// @author jackgale.eth
// @dev Testing file for Key.sol

const { ethers } = require("hardhat")
const { expect, assert } = require("chai");

describe("Key", function () {
    let addr1, contractFactory, contract;
    
    beforeEach(async function () {
        addr1 = await ethers.Wallet.createRandom()
        contractFactory = await ethers.getContractFactory("Key")
        contract = await contractFactory.deploy()
        ownerAddress = await contract.deployTransaction["from"]
    })

    it("(1) Should recognise addr1's balance of 0 NFT after deployment", async function () {
        addrBalance = await contract.balanceOf(addr1.address)
        addrBalanceInt = ethers.utils.formatUnits(addrBalance) * (10**18)
        await assert.equal(addrBalanceInt,0)
    })

    it("(2) Should recognise addr1's balance of 1 NFT after mint", async function () {
        await contract.mint(addr1.address)
        addrBalance = await contract.balanceOf(addr1.address)
        addrBalanceInt = ethers.utils.formatUnits(addrBalance) * (10**18)
        await assert.equal(addrBalanceInt,1)
    })

    it("(3) Should not recognise addr1's balance of 2 NFT after 2 mints", async function () {
        await contract.mint(addr1.address)
        await expect(contract.mint(addr1.address)).to.be.revertedWith("Recipient already has a Key NFT.")
    })

    it("(4) Should recognise owner's balance of 0 NFT after burn", async function () {
        await contract.burn(0)
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
        await assert.equal(ownerBalanceInt,0)
    })

    it("(5) Should not facilitate transfers between users", async function () {
        await contract.transferFrom(ownerAddress,addr1.address,0)
        addrBalance = await contract.balanceOf(addr1.address)
        addrBalanceInt = ethers.utils.formatUnits(addrBalance) * (10**18)
        await assert.equal(addrBalanceInt,0)
        ownerBalance = await contract.balanceOf(ownerAddress)
        ownerBalanceInt = ethers.utils.formatUnits(ownerBalance) * (10**18)
        await assert.equal(ownerBalanceInt,1)
    })

    it("(6) Should allow owner to add minter because of admin role", async function () {
        await expect(contract.addMinter(addr1.address)).to.not.be.reverted
    })

    it("(7) Should not allow admin to remove role from addr1 which it doesn't have", async function () {
        await expect(contract.removeMinter(addr1.address)).to.be.revertedWith("Selected wallet does not have minter role.")
    })

    it("(8) Should allow admin to remove its own roles", async function () {
        await expect(contract.removeMinter(ownerAddress)).to.not.be.reverted
    })
})