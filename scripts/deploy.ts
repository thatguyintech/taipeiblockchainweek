import { ethers } from "hardhat";

async function main() {
  console.log(`deploying TBWCoin...`);
  const TBWCoin = await ethers.getContractFactory("TBWCoin");
  const coin = await TBWCoin.deploy();
  await coin.deployed();
  console.log(`deployed!`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
