import { ethers } from "hardhat";
const TOTAL_SUPPLY = ethers.utils.parseEther("100000000");
const ROUTER = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
const FACTORY = "0x6725f303b657a9451d8ba641348b6761a6cc7a17";
const WBNB = "0xae13d989dac2f0debff460ac112a837c89baa7cd";

async function main() {
  const [owner] = await ethers.getSigners();

  const Token = await ethers.getContractFactory("MyToken");    
  const token = await Token.deploy(
    "My Token",
    TOTAL_SUPPLY,
    "MTK"  
  );
  await token.deployed();

  const router = await ethers.getContractAt("IPancakeRouter02", ROUTER);
  
  await token.approve(router.address, TOTAL_SUPPLY);

  let response = await router.addLiquidityETH(
        token.address,
        ethers.utils.parseEther("10"),
        owner.address,
        Date.now() + (60 * 10),
        { value: ethers.utils.parseEther("0.01"), gasLimit: 7600000 }
      );

  response.wait(1);

  let factory = await ethers.getContractAt("IUniswapV2Factory", FACTORY);

  let liquidityPoolAddress = ethers.constants.AddressZero;

  // Wait until the address to returned (I don't know why because I wait confirmations...)
  while (liquidityPoolAddress == ethers.constants.AddressZero) {
    liquidityPoolAddress = await factory.getPair(token.address, WBNB);
  } 

  console.log(`Liquidity pool address : ${liquidityPoolAddress}`);

  await token.setLiquidityPool(liquidityPoolAddress);

  console.log(`Liquidity pool set successfully`);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});