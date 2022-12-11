import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [ process.env.PRIVATE_KEY! ],
      blockGasLimit: 20_000_000,
      gasPrice: 2_000_000_000,
    },
    mumbai: {
      url: process.env.ALCHEMY_MUMBAI_URL,
      accounts: [ process.env.PRIVATE_KEY! ],
      blockGasLimit: 20_000_000,
      gasPrice: 2_000_000_000,
    }
  },
};

export default config;
