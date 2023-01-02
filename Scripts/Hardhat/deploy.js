// SPDX-License-Identifier: GPL-3.0
// @title deploy.js
// @author jackgale.eth
// @dev Basic deployment of a single compiled smart contract using a single wallet and RPC and Hardhat.
// Adapted from FreeCodeCamp Solidity & Javascript Blockchain Course:
// @source See: https://github.com/PatrickAlphaC/hardhat-simple-storage-fcc/blob/main/scripts/deploy.js

const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config(); // Assumes .env for RPC_URL and PRIVATE_KEY

async function main() {
  // Deploy contract.
  const contractFactory = await ethers.getContractFactory(""); // Insert contract name as stated in .sol file.
  console.log("Deploying contract...");
  const contract = await contractFactory.deploy();
  await contract.deployed();
  console.log("Deployed contract to: " + contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
