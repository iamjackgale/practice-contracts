require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {},
      },
      {
        version: "0.8.19",
        settings: {},
      },
      {
        version: "0.7.5",
        settings: {},
      },
      {
        version: "0.4.18",
        settings: {},
      },
    ]
  },
  networks: {
    goerli: {
      chainId: 5,
      url: process.env.GOERLI_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2, process.env.PRIVATE_KEY_3],
      gas: "auto",
      gasPrice: "auto"
    },
    sepolia: {
      chainId: 11155111,
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2, process.env.PRIVATE_KEY_3],
      gas: "auto",
      gasPrice: "auto"
    },
    gnosis: {
      chainId: 100,
      url: process.env.GNOSIS_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2, process.env.PRIVATE_KEY_3],
      gas: "auto",
      gasPrice: "auto"
    },
    fantom: {
      chainId: 250,
      url: process.env.FANTOM_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2, process.env.PRIVATE_KEY_3],
      gas: "auto",
      gasPrice: "auto"
    }
  },
  etherscan: {
    apiKey: process.env.GNOSISSCAN_API_KEY,//process.env.ETHERSCAN_API_KEY,
    additionalNetworks: {
      fantom: process.env.GNOSISSCAN_API_KEY,
    }
  },
};
