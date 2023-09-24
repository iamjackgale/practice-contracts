const fs = require("fs-extra");
const { ethers } = require("hardhat");
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(
    network = "sepolia",
    SEPOLIA_RPC_KEY
  );

const signerWallet = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
const signer = signerWallet.connect(alchemyProvider);

const contractAddress = "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"
const contractABI = [{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"guy","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"dst","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"dst","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Withdrawal","type":"event"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"guy","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"deposit","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"src","type":"address"},{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}]
const contract = new ethers.Contract(contractAddress, contractABI, alchemyProvider)

async function main() {
    
    const wethBalance1 = (await contract.connect(signer).balanceOf(signer.address)).toString()
    console.log("balance at start: " + wethBalance1)
    
    console.log("Sending first transaction.")
    const transaction = await contract.connect(signer).deposit({value: ethers.parseEther("0.05")});
    await transaction.wait([confirms = 2]);
    console.log("First transaction complete.")
    
    const wethBalance2 = (await contract.connect(signer).balanceOf(signer.address)).toString()
    console.log("balance after first transaction: " + wethBalance2)
    
    console.log("Sending second transaction.")
    const transaction2 = await contract.connect(signer).withdraw(ethers.parseEther("0.05"));
    await transaction2.wait([confirms = 2]);
    console.log("Second transaction complete.")
    
    const wethBalance3 = (await contract.connect(signer).balanceOf(signer.address)).toString()
    console.log("balance at end: " + wethBalance3)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run scripts/useWeth.js