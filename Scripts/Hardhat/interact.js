// SPDX-License-Identifier: MIT

// @title interact.js
// @author jackgale.eth
// @dev template smart contract interaction script for Goerli testnet, using Alchemy RPC and with no operations included.
// Adapted from Alchemy tutorial:
// @source See: https://docs.alchemy.com/docs/interacting-with-a-smart-contract

require("dotenv").config();

const GOERLI_RPC_KEY = process.env.GOERLI_RPC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS; // Ensure correct contract(s) specified in .env

// Contract Local ABI
const contract = require("../artifacts/contracts/XXX.sol/XXX.json"); // Add contract directory and contract json

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(
  (network = "goerli"),
  GOERLI_RPC_KEY
);

// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// Contract
const bankEarnVaultContract = new ethers.Contract(
  CONTRACT_ADDRESS,
  contract.abi,
  signer
);

// Operative Function

async function main() {
  // Insert operative code
}

main();
