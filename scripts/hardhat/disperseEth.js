const fs = require("fs-extra");
const { ethers } = require("hardhat");
const { BigNumber } = require("bignumber.js")
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1;
const PRIVATE_KEY_2 = process.env.PRIVATE_KEY_2;
const PRIVATE_KEY_3 = process.env.PRIVATE_KEY_3;
const PRIVATE_KEY_4 = process.env.PRIVATE_KEY_4;
const PRIVATE_KEY_5 = process.env.PRIVATE_KEY_5;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(
    network = "sepolia",
    SEPOLIA_RPC_KEY
  );

const signerWallet = new ethers.Wallet(PRIVATE_KEY_1, alchemyProvider);
const signer = signerWallet.connect(alchemyProvider);

const contractAddress = "0xE2C89CE311AD7466A6D527A30d8aDb1258002D66";
const contractArtifact = "artifacts/contracts/ETH/DisperseEth.sol/DisperseEth.json"

const valueNumber = new BigNumber(0.000100010000000001 * 1e18)
const value = valueNumber.toString()

const wait = (n) => new Promise((resolve) => setTimeout(resolve, n));
var waitTime = 0

async function main() {
    const contract = new ethers.Contract(
        contractAddress,
        contractArtifact.abi,
        signer
    );
    await contract.disperse()

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run Scripts/Hardhat/disperseEth.js