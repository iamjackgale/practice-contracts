const fs = require("fs-extra");
const { ethers } = require("hardhat");
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const PRIVATE_KEY_2 = process.env.PRIVATE_KEY_2;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(
    network = "sepolia",
    SEPOLIA_RPC_KEY
  );

const signerWallet = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
const signer = signerWallet.connect(alchemyProvider);
const receiverWallet = new ethers.Wallet(PRIVATE_KEY_2, alchemyProvider);
const receiver = receiverWallet.connect(alchemyProvider);

async function main() {
    balance = (await alchemyProvider.getBalance(signer.address)).toString();
    balance2 = (await alchemyProvider.getBalance(receiver.address)).toString();
    console.log("dev wallet balance at start: " + balance);
    console.log("dev wallet 2 balance at start: " + balance2);
    const tx = {
        from: signerWallet.address,
        to: receiverWallet.address,
        value: ethers.parseEther("0.05")
    }
    await signer.sendTransaction(tx).then((transaction) => {
        console.dir(transaction)
    })
    balance = (await alchemyProvider.getBalance(signer.address)).toString();
    balance2 = (await alchemyProvider.getBalance(receiver.address)).toString();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run scripts/sendEther.js