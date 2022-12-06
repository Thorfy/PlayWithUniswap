import { ethers } from "hardhat";
const TOTAL_SUPPLY = ethers.utils.parseEther("100000000");

async function main() {
  const Token = await ethers.getContractFactory("MyToken");    
  const token = await Token.deploy(
    "My Token",
    TOTAL_SUPPLY,
    "MTK"  
  );
  await token.deployed();

}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});