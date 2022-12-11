import { ethers } from "hardhat";

async function main() {
  // Deploy Token (ERC20)
  console.log(`deploying TBWCoin...`);
  const TBWCoin = await ethers.getContractFactory("TBWCoin");
  const coin = await TBWCoin.deploy();
  await coin.deployed();
  console.log(`deployed!`);

  // Deploy NFT (ERC721)
  console.log(`deploying TBWNFT...`);
  const TBWNFT = await ethers.getContractFactory("TBWNFT");
  const nft = await TBWNFT.deploy();
  await nft.deployed();
  console.log(`deployed!`);

  // Deploy Staking Contract
  console.log(`deploying Staking contract...`);
  const TBWStaker = await ethers.getContractFactory("TBWStaker");
  const nftAddress = nft.address;
  console.log("nftAddress: ", nftAddress);
  const rewardTokenAddress = coin.address;
  console.log("rewardTokenAddress: ", rewardTokenAddress);
  const rewardWalletAddress = await coin.bank();
  console.log("rewardWalletAddress: ", rewardWalletAddress);
  const staker= await TBWStaker.deploy(nftAddress, rewardTokenAddress, rewardWalletAddress, 1);
  await staker.deployed();
  console.log("staker address: ", staker.address);
  console.log(`deployed!`);

  // Test the staking contract
  console.log("approving the staking contract to stake NFTs...");
  await nft.approve(staker.address, 0)

  console.log("try staking...");
  console.log("nft tokenid 0 is owned by: ", await nft.ownerOf(0));
  await staker.stake([0]);
  console.log("waiting 10 seconds...");
  await sleep(10000);
  console.log("tokens earned: ", await staker.available(rewardWalletAddress));
  console.log("waiting 10 seconds...");
  await sleep(10000);
  console.log("tokens earned: ", await staker.available(rewardWalletAddress));
  console.log("waiting 10 seconds...");
  await sleep(10000);
  console.log("tokens earned: ", await staker.available(rewardWalletAddress));
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
