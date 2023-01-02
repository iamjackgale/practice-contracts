# Hardhat Development Environment

A basic Hardhat development environment for testing deployment of contracts using Hardhat.

This uses the Goerli Ethereum testnet, together with an Alchemy Goerli RPC to access the blockchain and the Etherscan.io API to verify the deployed contracts.

## Set Up Notes

Follow the below notes when setting up an new Hardhat development environment.

### Hardhat Environment

This Hardhat environment was set up using Yarn with the following commands:

1. _yarn init_ - to create a new project folder;
2. _yarn add --dev hardhat_ - to install Hardhat;
3. _yarn hardhat_ - to initiate a Hardhat project; and
4. _yarn add @openzeppelin/contracts_ - to add OpenZeppelin's default contract template suite.

Where you retrieve a list of dependencies in a package.json file for a particular project, you should also ensure they are installed with the following command:

    yarn install

### Hardhat Configuration

The Hardhat configuration was set up with the following changes:

1. Add "dotenv" to access the .env environment variables file;
2. Add "hardhat-etherscan" to access Etherscan.io;
3. Set constants for each of the environment variables being imported from the .env file;
4. Set Hardhat as the default network;
5. Add the Goerli Ethereum network's URL, wallet and chain ID;
6. Add the Etherscan.io API key; and
7. Set the Solidity version as V. 0.8.17.

### Environment Variables

The .env environment variables were set up for:

1. the Alchemy Goerli RPC URL;
2. the private key of the deploying wallet; and
3. the Etherscan API Key.

## Deployment

To run the deploy script on Goerli, use the following command:

_yarn hardhat run scripts/deployVerify.js --network goerli_

_yarn hardhat run scripts/deploy.js --network goerli_

### Deployment Scripts

The deployment script was taken from the standard deployVerify.js file on my [GitHub page](https://github.com/iamjackgale/practice-contracts/blob/main/Deployment%20Scripts/Hardhat/deployVerify.js).

This requires the insertion of the contract name in the .sol file and the relevant chain ID.

### Flatten

To help with ensuring the contract can be verified by a block explorer, you may first want to flatten the contract, to include all of its dependencies in the file.

First, generate a new file for the flattened contract called _flattened.sol_, using the following command:

_yarn hardhat flatten > flattened.sol_

## Verification

Verification through Hardhat is [recommended](https://forum.openzeppelin.com/t/how-to-verify-a-contract-on-etherscan-bscscan-polygonscan/14225) recommended, so it is worth familiarising yourself with the process for verification on the [Hardhat Docs](https://hardhat.org/hardhat-runner/plugins/nomiclabs-hardhat-etherscan).

The steps are:

1. Install _hardhat-etherscan_;
2. Import the plugin into the hardhat config file with a _require_ statement;
3. Add the etherscan section into the _module.exports_ object in the hardhat config file;
4. If there are complex arguments, add a arguments.js file; and
5. Run the following command:

_yarn hardhat verify --constructor-args arguments.js DEPLOYED_CONTRACT_ADDRESS --network goerli_

## Hardhat Functionality

Hardhat has a range of other built-in functionality, including:

### List of Networks

To access a list of all the networks supported by _hardhat-etherscan_, use the following command:

_yarn hardhat verify --list-networks_

## Add-ons

There are a huge range of interesting and useful add-ons for Hardhat which improve the development experience.

### Hardhat Gas Reporter

To get feedback on gas usage by contract deployments and methods during testing, use the hardhat-gas-reporter extension, which attaches to all tests.

To install, run the following console command:

    yarn add hardhat-gas-reporter

To use, add the following in the hardhat.config file:

    require("hardhat-gas-reporter")

    ...

    gasReporter: {
        enabled: true
    }

Then simple run your tests with the following console command to see the report appended to the testing response:

    yarn hardhat test

#### Output Report File

To go one step further, you can generate an output report file to save the details for later use. Simply add the following to the hardhat.config file:

    gasReporter: {
        enabled: true,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "ETH",
        coinmarketcap: COINMARKETCAP_API_KEY,
    },

It's then recommended to add the "gas-report.txt" file to your .gitignore file. The "noColors" key deals with issues in report coloring in the txt file format. The "currency" key converts the reports output into the selected currency by picking up live currency data from the Coinmarketcap API.

### Solidity Coverage

Extension to check how much of your draft contract is covered by your current array of tests, to flag any areas that you have not covered in testing. To install, just run:

    yarn add --dev solidity-coverage

To configure, simply add:

    require("solidity-coverage")

No other configuration settings are needed.
