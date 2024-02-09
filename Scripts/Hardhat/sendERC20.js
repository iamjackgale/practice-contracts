const fs = require("fs-extra");
const { ethers } = require("hardhat");
const { BigNumber } = require("bignumber.js")
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1;
const PRIVATE_KEY_2 = process.env.PRIVATE_KEY_2;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(
    network = "sepolia",
    SEPOLIA_RPC_KEY
  );

const addressLINK = ethers.getAddress("0x779877A7B0D9E8603169DdbD7836e478b4624789");

const signerWallet = new ethers.Wallet(PRIVATE_KEY_1, alchemyProvider);
const signer = signerWallet.connect(alchemyProvider);
const receiverWallet = new ethers.Wallet(PRIVATE_KEY_2, alchemyProvider);
const receiver = receiverWallet.connect(alchemyProvider);

const valueNumber = new BigNumber(0.000100010000000001 * 1e18)
const value = valueNumber.toString()

const wait = (n) => new Promise((resolve) => setTimeout(resolve, n));
var waitTime = 0

async function main() {
    const abiLINK = await require('./abiLINK.json');
    const contract = new ethers.Contract(
        addressLINK,
        abiLINK.abi,
        signer
    );
    startBalance = (await contract.balanceOf(signer.address)).toString();
    startBalance2 = (await contract.balanceOf(receiver.address)).toString();
    console.log("dev wallet 1 balance at start: " + (startBalance / 1e18));
    console.log("dev wallet 2 balance at start: " + (startBalance2 / 1e18));
    
    const tx = await contract.connect(signer).transfer(receiver.address, value)
    console.log("transaction hash: " + tx.hash)
    
    currentBalance = (await contract.balanceOf(signer.address)).toString();
    currentBalance2 = (await contract.balanceOf(receiver.address)).toString();
    while (startBalance2 === currentBalance2) {
        waitTime += 5;
        console.log("transaction pending: waiting 5 seconds");
        await wait(5000);
        console.log("total wait time: " + waitTime + "seconds");
        currentBalance = (await contract.balanceOf(signer.address)).toString();
        currentBalance2 = (await contract.balanceOf(receiver.address)).toString();
    }
    console.log("dev wallet 1 balance at end: " + (currentBalance / 1e18));
    console.log("dev wallet 2 balance at end: " + (currentBalance2 / 1e18));
    console.log("amount sent: " + ((currentBalance2 - startBalance2) / 1e18));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run Scripts/Hardhat/sendERC20.js