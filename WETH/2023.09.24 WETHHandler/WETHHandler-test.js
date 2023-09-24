const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("TestTest", function () {

    let receiver, sender, contract

    before(async function() {
        [ receiver, sender ] = await ethers.getSigners();
        const wethFactory = await ethers.getContractFactory("WETH");
        weth = await wethFactory.deploy();
        const contractFactory = await ethers.getContractFactory("Test");
        contract = await contractFactory.deploy(weth);
    })

    it("Should return a zero value for initial contract balanceOf() of sender", async function () {
        const amount = await contract.connect(sender).balanceOf(sender.address);
        console.log("balance of sender wallet: " + await amount.toString());
        expect(amount).to.equal(0);
    })

    it("Should return a zero value for initial supplyOf() WETH", async function() {
        const amount = await weth.connect(sender).totalSupply();
        console.log("totalSupply() of WETH contract: " + await amount.toString());
        expect(amount).to.equal(0);
    })

    it("Should return the deposit value as balanceOf() of sender in contract after deposit() transaction", async function () {
        await weth.connect(sender).deposit({value: ethers.parseEther("0.05")});
        const amount = await contract.connect(sender).balanceOf(sender.address);
        console.log("balance of sender wallet: " + await amount.toString());
        expect(await amount.toString()).to.equal("50000000000000000");
    })

    it("Should return the deposit value as totalSupply() of WETH after deposit() transaction", async function () {
        await weth.connect(sender).deposit({value: ethers.parseEther("0.05")});
        const amount = await weth.connect(sender).totalSupply();
        console.log("totalSupply() of WETH contract: " + await amount.toString());
        expect(await amount.toString()).to.equal("100000000000000000");
    })

    it("Should return the deposit value as balanceOf() of sender after wrapEth() transaction", async function () {
        await contract.connect(sender).wrapEth({value: ethers.parseEther("0.05")});
        const amount = await weth.connect(sender).totalSupply();
        console.log("balance of sender wallet: " + await amount.toString());
        expect(await amount.toString()).to.equal("150000000000000000");
    })

    it("Should return the deposit value as totalySupply() of WETH after wrapEth() transaction", async function () {
        await contract.connect(sender).wrapEth({value: ethers.parseEther("0.05")});
        const amount = await weth.connect(sender).totalSupply();
        console.log("totalSupply() of WETH wallet: " + await amount.toString());
        expect(await amount.toString()).to.equal("200000000000000000");
    })

    it("Should return a zero value for balanceOf() of sender after wrapEth(), approve() and unwrapWeth()", async function () {
        const value = ethers.parseEther("0.05");
        await contract.connect(sender).wrapEth({value: value});
        await weth.connect(sender).approve(contract, value);
        await contract.connect(sender).unwrapWeth(value);
        const amount = await contract.connect(sender).balanceOf(sender.address);
        console.log("balance of sender wallet: " + await amount.toString());
        expect((await amount).toString()).to.equal("200000000000000000");
    })
})

// yarn hardhat test test/test-test.js