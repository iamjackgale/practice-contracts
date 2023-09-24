const fs = require("fs-extra");
const ethers = require("ethers");
require("dotenv").config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const SEPOLIA_RPC_KEY = process.env.SEPOLIA_RPC_KEY;

const alchemyProvider = new ethers.AlchemyProvider(``
    (network = "sepolia"),
    SEPOLIA_RPC_KEY
  );

const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

async function main() {
    balance = (await alchemyProvider.getBalance(signer.address)).toString();
    block = (await alchemyProvider.getBlockNumber()).toString();
    console.log("dev wallet balance on " + network + " at block " + block + ": " + balance);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run scripts/checkBalance.js