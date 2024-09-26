import { HardhatUserConfig, task } from "hardhat/config";
import '@openzeppelin/hardhat-upgrades';
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
// Ensure that we have all the environment variables we need.

const MAINNET_RPC_URL = "http://127.0.0.1:8545";
const chainIds = {
  hardhat: 31337,
  bsc: 56,
  bscTest: 97
};


const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1,
      } ,
      viaIR: false
    }
  },
  defaultNetwork: "hardhat",
  networks: { 
    hardhat: {
      chainId: chainIds.hardhat
    }
  }
};
export default config;
