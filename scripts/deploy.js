const hre = require("hardhat");

async function main() {
  const initBalance = 10000;

  // Get the Points smart contract
  const DegenToken = await hre.ethers.getContractFactory("DegenToken");

  // Deploy it
  const tokens = await DegenToken.deploy(initBalance);
  await tokens.waitForDeployment();

  // Display the contract address
  console.log(`Points token deployed to ${tokens.target}`);
}

// Hardhat recommends this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
