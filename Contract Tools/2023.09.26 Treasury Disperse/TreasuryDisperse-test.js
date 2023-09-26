const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("TreasuryDisperseTest", function () {

    let sender, receiver1, receiver2, receiver3, tcAddresses, weth, wethAddress, contract, contractAddress
    const provider = ethers.provider

    before(async function() {
        [ sender, receiver1, receiver2, receiver3 ] = await ethers.getSigners();
        tcAddresses = [sender.address, receiver1.address, receiver2.address];
        const wethFactory = await ethers.getContractFactory("WETH");
        weth = await wethFactory.deploy();
        wethAddress = weth.target;
        const contractFactory = await ethers.getContractFactory("TreasuryDisperse");
        contract = await contractFactory.deploy(weth, tcAddresses);
        contractAddress = contract.target
    })

    it("(1) Should return all of the tcAddresses using the getSignerAddress() view function", async function() {
        let address1 = await contract.getSignerAddress(0);
        let address2 = await contract.getSignerAddress(1);
        let address3 = await contract.getSignerAddress(2);
        expect(address1).to.equal(tcAddresses[0]);
        expect(address2).to.equal(tcAddresses[1]);
        expect(address3).to.equal(tcAddresses[2]);
    })

    it("(2) Should return the address of the weth contract when calling getWrappedAddress()", async function() {
        wethAddress2 = await contract.getWrappedAddress();
        expect(wethAddress2).to.equal(wethAddress);
    })

    it("(3) return a different weth address using getWrappedAddress() view function after updating with replaceWethAddress() function", async function() {
        let initialAddress = await contract.getWrappedAddress();
        await contract.replaceWrappedAddress(receiver1.address);
        let replacedAddress = await contract.getWrappedAddress();
        await contract.replaceWrappedAddress(wethAddress);
        expect(initialAddress).to.equal(wethAddress)
        expect(replacedAddress).to.equal(receiver1.address);
        expect(initialAddress).to.not.equal(replacedAddress)
    })

    it("(4) Should replace specified tcAddress using replaceSignerAddress() function", async function() {
        let startAddress = await contract.getSignerAddress(0);
        await contract.replaceSignerAddress(0, receiver3.address);
        let endAddress = await contract.getSignerAddress(0);
        expect(startAddress).to.not.equal(endAddress);
    })

    it("(5) Should add another tcAddress using addAddress() function", async function() {
        await contract.addAddress(sender.address);
        expect(await contract.getSignerAddress(3)).to.equal(sender.address);
    })

    it("(6) Should remove an existing tcAddress using removeSignerAddress() function", async function() {
        await contract.removeSignerAddress(1);
        expect(await contract.getSignerAddress(0)).to.equal(receiver3.address);
        expect(await contract.getSignerAddress(1)).to.equal(sender.address);
        expect(await contract.getSignerAddress(2)).to.equal(receiver2.address);
    })

    it("(7) Should show different native balances after disperseNative() for sender and receivers", async function () {
        await contract.connect(sender).disperseNative({value: ethers.parseEther("300")});
        const finalBalanceSender = await provider.getBalance(sender);
        expect((finalBalanceSender).toString()).to.be.lessThan(ethers.parseEther("9800"));
        const finalBalanceReceiver = await provider.getBalance(receiver2);
        expect((finalBalanceReceiver).toString()).to.equal(ethers.parseEther("10100"));
    })

    it("(8) Should show different native balances after disperseWeth() for sender and receivers", async function () {
        await weth.connect(sender).deposit({value: ethers.parseEther("300")});
        const initialBalanceSender = await provider.getBalance(sender);
        await weth.connect(sender).approve(contractAddress, ethers.parseEther("300"));
        await contract.connect(sender).disperseWrapped(ethers.parseEther("300"));
        const finalBalanceSender = await provider.getBalance(sender);
        expect((finalBalanceSender).toString()).to.be.lessThan(ethers.parseEther("9600"));
        const finalBalanceReceiver = await provider.getBalance(receiver2);
        expect((finalBalanceReceiver).toString()).to.equal(ethers.parseEther("10200"));
    })

    it("(9) Should show greater native balances after disperseResidue() for receiver", async function() {
        const initialBalanceReceiver = await provider.getBalance(receiver2);
        await weth.connect(sender).deposit({value: ethers.parseEther("100")});
        await weth.connect(sender).approve(contractAddress, ethers.parseEther("100"));
        await weth.connect(sender).transferFrom(sender.address, contractAddress, ethers.parseEther("100"));
        await sender.sendTransaction({from: sender.address, to: contractAddress, value: ethers.parseEther("200")});
        await contract.connect(sender).disperseResidue();
        const finalBalanceReceiver = await provider.getBalance(receiver2);
        expect(finalBalanceReceiver).to.be.greaterThan(initialBalanceReceiver);
    })
})

// yarn hardhat test test/TreasuryDisperse-test.js