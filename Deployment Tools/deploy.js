// SPDX-License-Identifier: MIT
// @title deploy.js
// @author jackgale.eth
// @dev Basic deployment of a single compiled smart contract using a single wallet and RPC.
// Adapted from FreeCodeCamp Solidity & Javascript Blockchain Course:
// @source See: https://github.com/PatrickAlphaC/ethers-simple-storage-fcc/blob/00cf598a7532a11e09138a341cf0789802ebe4c3/deploy.js

const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config(); // Assumes .env for RPC_URL and PRIVATE_KEY

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL);
  let wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  wallet = await wallet.connect(provider);
  const abi = fs.readFileSync("", "utf8"); // Insert contract abi file for first arg.
  const binary = fs.readFileSync("", "utf8"); // Insert contract binary file for first arg.

  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying, please wait...");
  const contract = await contractFactory.deploy();
  await contract.deployTransaction.wait(1);
  console.log("Contract Deployed!");
  console.log("Contract Address: " + contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
