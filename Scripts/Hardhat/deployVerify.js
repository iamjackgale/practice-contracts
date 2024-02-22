// SPDX-License-Identifier: MIT
// @title deployVerify.js
// @author jackgale.eth
// @dev Basic deployment of a single compiled smart contract using a single wallet and RPC and Hardhat, followed by verification of that contract on Etherscan.
// Adapted from FreeCodeCamp Solidity & Javascript Blockchain Course:
// @source See: https://github.com/PatrickAlphaC/hardhat-simple-storage-fcc/blob/main/scripts/deploy.js

const hre = require("hardhat");
const { ethers } = require("hardhat");
const fs = require("fs-extra");
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.
const demo = process.env.SEPOLIA_RPC_KEY

async function main() {
  // Get provider and signer
  const deployer = await new ethers.Wallet(process.env.PRIVATE_KEY_1)

  // Deploy contract.
  const contractFactory = await ethers.getContractFactory("DisperseEth"); // Insert contract name as stated in .sol file.
  console.log("Deploying contract...");
  const disperseContract = await contractFactory.deploy(); //Set contract name from within .sol file.
  console.log("Deploy initiated...");
  await disperseContract.waitForDeployment();
  console.log("Deployed contract to: " + disperseContract.target);

  // Verify contract.
  if (await network.config.chainId == "11155111" && process.env.ETHERSCAN_API_KEY) {
    // Insert relevant chainId and API_KEY.
    await disperseContract.deploymentTransaction().wait(2);
    await verify(disperseContract.target, []); // Insert contract arguments from within .sol file. Default is [].
  }
}

async function verify(contractAddress, args) {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already verified");
    } else {
      console.log(e);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // yarn hardhat run --network sepolia scripts/hardhat/deployVerify.js