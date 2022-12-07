// SPDX-License-Identifier: MIT
// @title deployVerify.js
// @author jackgale.eth
// @dev Basic deployment of a single compiled smart contract using a single wallet and RPC and Hardhat, followed by verification of that contract on Etherscan.
// Adapted from FreeCodeCamp Solidity & Javascript Blockchain Course:
// @source See: https://github.com/PatrickAlphaC/hardhat-simple-storage-fcc/blob/main/scripts/deploy.js

const fs = require("fs-extra");
require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

async function main() {
  // Deploy contract.
  const contractFactory = await ethers.getContractFactory(""); // Set contract name from within .sol file.
  console.log("Deploying contract...");
  const contract = await contractFactory.deploy();
  await contract.deployed();
  console.log("Deployed contract to: " + contract.address);

  // Verify contract.
  if (network.config.chainId == chainId && process.env.API_KEY) {
    // Insert relevant chainId and API_KEY.
    await contract.deployTransaction.wait(6);
    await verify(contract.address, []); // Insert contract arguments from within .sol file. Default is [].
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
