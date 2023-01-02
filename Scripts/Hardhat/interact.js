// SPDX-License-Identifier: MIT

// @title interact.js
// @author jackgale.eth
// @dev template smart contract interaction script for Goerli testnet, using Alchemy RPC and with no operations included.
// Adapted from Alchemy tutorial:
// @source See: https://docs.alchemy.com/docs/interacting-with-a-smart-contract

require("dotenv").config();

const GOERLI_RPC_KEY = process.env.GOERLI_RPC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

// Contract Local ABI
const contract = require("../artifacts/contracts/BankEarnVault.sol/BankEarnVault.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(
  (network = "goerli"),
  GOERLI_RPC_KEY
);

// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// Contract
const contract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

// Operative Function

async function main() {
  // Operations
}

main();
