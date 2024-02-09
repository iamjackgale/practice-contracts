const fs = require("fs-extra");
const { ethers } = require("hardhat");
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1;
const PRIVATE_KEY_2 = process.env.PRIVATE_KEY_2;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(
    network = "sepolia",
    SEPOLIA_RPC_KEY
  );

const signerWallet = new ethers.Wallet(PRIVATE_KEY_1, alchemyProvider);
const signer = signerWallet.connect(alchemyProvider);
const receiverWallet = new ethers.Wallet(PRIVATE_KEY_2, alchemyProvider);
const receiver = receiverWallet.connect(alchemyProvider);

const wait = (n) => new Promise((resolve) => setTimeout(resolve, n));
var waitTime = 0

async function main() {
    startBalance = (await alchemyProvider.getBalance(signer.address)).toString();
    startBalance2 = (await alchemyProvider.getBalance(receiver.address)).toString();
    console.log("dev wallet 1 balance at start: " + (startBalance / 1e18));
    console.log("dev wallet 2 balance at start: " + (startBalance2 / 1e18));
    const tx = {
        from: signerWallet.address,
        to: receiverWallet.address,
        value: ethers.parseEther("0.0009")
    }
    await signer.sendTransaction(tx).then((transaction) => {
        console.dir(transaction.hash)
    })
    currentBalance = (await alchemyProvider.getBalance(signer.address)).toString();
    currentBalance2 = (await alchemyProvider.getBalance(receiver.address)).toString();
    while (startBalance2 === currentBalance2) {
        waitTime += 5;
        console.log("transaction pending: waiting 5 seconds");
        await wait(5000);
        console.log("total wait time: " + waitTime + "seconds");
        currentBalance = (await alchemyProvider.getBalance(signer.address)).toString();
        currentBalance2 = (await alchemyProvider.getBalance(receiver.address)).toString();
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

// yarn hardhat run Scripts/Hardhat/sendEther.js