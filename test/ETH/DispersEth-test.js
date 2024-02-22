const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("DisperseEth", function () {

    let sender, receiver1, receiver2, receiver3, receiver4, contract
    const provider = ethers.provider

    before(async function() {
        [ sender, receiver1, receiver2, receiver3, receiver4 ] = await ethers.getSigners();
        const contractFactory = await ethers.getContractFactory("DisperseEth");
        contract = await contractFactory.deploy();
    })

    it("(1) Should disperse ETH to a single address and single value", async function() {
        const startBalance = await provider.getBalance(receiver1);
        console.log("Start balance = " + startBalance.toString());
        const value = "0.1";
        console.log("Testing Disperse:");
        await contract.connect(sender).disperse([receiver1.address], [ethers.parseEther(value)],{value: ethers.parseEther(value)});
        console.log("Dispersed!");
        const endBalance = await provider.getBalance(receiver1);
        console.log("End balance = " + endBalance.toString());
        expect(endBalance).to.equal(startBalance+ethers.parseEther(value));
    })

    it("(2) Should disperse ETH to many addresses with different values", async function() {
        const startBalance1 = await provider.getBalance(receiver1);
        const startBalance2 = await provider.getBalance(receiver2);
        const startBalance3 = await provider.getBalance(receiver3);
        const startBalance4 = await provider.getBalance(receiver4);
        const startTotal = startBalance1 + startBalance2 + startBalance3 + startBalance4;
        console.log("Start balances = " + startBalance1.toString() + ", " + startBalance2.toString() + ", " + startBalance3.toString() + ", " + startBalance4.toString());
        const total = 0.6;
        const values = [
            (total/10*1).toString(),
            (total/10*2).toString(),
            (total/10*3).toString(),
            (total/10*4).toString()
        ];
        console.log("Values are: " + values[0] + ", " + values[1] + ", " + values[2] + ", " + values[3])
        console.log("Testing Disperse:");
        await contract.connect(sender).disperse([receiver1.address, receiver2.address, receiver3.address, receiver4.address], [ethers.parseEther(values[0]), ethers.parseEther(values[1]), ethers.parseEther(values[2]), ethers.parseEther(values[3])],{value: ethers.parseEther(total.toString())});
        console.log("Dispersed!");
        const endBalance1 = await provider.getBalance(receiver1);
        const endBalance2 = await provider.getBalance(receiver2);
        const endBalance3 = await provider.getBalance(receiver3);
        const endBalance4 = await provider.getBalance(receiver4);
        const endTotal = endBalance1 + endBalance2 + endBalance3 + endBalance4
        console.log("End balances = " + endBalance1.toString() + ", " + endBalance2.toString() + ", " + endBalance3.toString() + ", " + endBalance4.toString());
        expect(endTotal).to.equal(startTotal + ethers.parseEther(total.toString()));
    })
});