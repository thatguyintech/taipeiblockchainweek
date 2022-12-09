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
      blockGasLimit: 10_000_000,
    }
  },
  defaultNetwork: "goerli",
};

export default config;
