require("dotenv").config(); //Assumes .env for RPC_URL, PRIVATE_KEY and API_KEY.

async function main() {
  // Verify contract.
  if (network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) { // Insert relevant chainId and API_KEY.
    await verify("0xE2C89CE311AD7466A6D527A30d8aDb1258002D66", []); // Insert contract arguments from within .sol file. Default is [].
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

// yarn hardhat run scripts/hardhat/verify.js --network sepolia