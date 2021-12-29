import hre, { ethers } from "hardhat";
import { IERC20Minimal__factory } from "../../../typechain";
import { BigNumber as BN } from "ethers";

const DEAD_ADDRESS = "0x0000000000000000000000000000000000000001";
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const DEFAULT_DECIMALS = 18;

interface TokenData {
  tokenAddress: string;
  tokenWhaleAddress?: string;
  feederPool?: string;
}

const getToken = (tokenSymbol: string): TokenData => {
  switch (tokenSymbol) {
    case "MTA":
      return {
        tokenAddress: "0xf501dd45a1198c2e1b5aef5314a68b9006d842e0"
      };
    case "mUSD":
      return {
        tokenAddress: "0xe840b73e5287865eec17d250bfb1536704b43b21",
        tokenWhaleAddress: "0x4393b9c542bf79e5235180d6da1915c0f9bc02c3"
      };

    case "DAI":
      return {
        tokenAddress: "0x8f3cf7ad23cd3cadbd9735aff958023239c6a063",
        tokenWhaleAddress: "0x49854708A8c42eEB837A97Dd97D597890CEb1334"
      };
    case "imUSD":
      return {
        tokenAddress: "0x5290Ad3d83476CA6A2b178Cd9727eE1EF72432af"
      };

    case "imUSDVault":
      return {
        tokenAddress: "0x32aBa856Dc5fFd5A56Bcd182b13380e5C855aa29"
      };

    case "FRAX":
      return {
        tokenAddress: "0x104592a158490a9228070E0A8e5343B499e125D0",
        tokenWhaleAddress: "0xAE0f77C239f72da36d4dA20a4bBdaAe4Ca48e03F",
        feederPool: "0xb30a907084ac8a0d25dddab4e364827406fd09f0"
      };

    default:
      throw new Error(`Token ${tokenSymbol} not supported`);
  }
};

const sendToken = async (token: string, amount: any, from: string, to: string): Promise<any> => {
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [from]
  });
  const [signer] = await ethers.getSigners();
  const sender = hre.ethers.provider.getSigner(from);

  await signer.sendTransaction({
    to: from,
    value: ethers.utils.parseEther("1")
  });

  return await IERC20Minimal__factory.connect(token, sender).transfer(to, amount);
};

const fundWallet = async (token: string, amount: any, to: string) => {
  const { tokenAddress, tokenWhaleAddress } = getToken(token);
  await sendToken(tokenAddress, amount, tokenWhaleAddress!, to);
};

const calcMinOut = (amount: BN, slippage: number): BN => {
  const value = simpleToExactAmount(1 - slippage);
  const minOut = amount.mul(value).div(ethers.BigNumber.from(10).pow(DEFAULT_DECIMALS));
  return minOut;
};

const simpleToExactAmount = (amount: number | string | BN, decimals: number | BN = DEFAULT_DECIMALS): BN => {
  // Code is largely lifted from the guts of web3 toWei here:
  // https://github.com/ethjs/ethjs-unit/blob/master/src/index.js
  let amountString = amount.toString();
  const decimalsBN = BN.from(decimals);

  if (decimalsBN.gt(100)) {
    throw new Error(`Invalid decimals amount`);
  }

  const scale = BN.from(10).pow(decimals);
  const scaleString = scale.toString();

  // Is it negative?
  const negative = amountString.substring(0, 1) === "-";
  if (negative) {
    amountString = amountString.substring(1);
  }

  if (amountString === ".") {
    throw new Error(`Error converting number ${amountString} to precise unit, invalid value`);
  }

  // Split it into a whole and fractional part
  // eslint-disable-next-line prefer-const
  let [whole, fraction, ...rest] = amountString.split(".");
  if (rest.length > 0) {
    throw new Error(`Error converting number ${amountString} to precise unit, too many decimal points`);
  }

  if (!whole) {
    whole = "0";
  }
  if (!fraction) {
    fraction = "0";
  }

  if (fraction.length > scaleString.length - 1) {
    throw new Error(`Error converting number ${amountString} to precise unit, too many decimal places`);
  }

  while (fraction.length < scaleString.length - 1) {
    fraction += "0";
  }

  const wholeBN = BN.from(whole);
  const fractionBN = BN.from(fraction);
  let result = wholeBN.mul(scale).add(fractionBN);

  if (negative) {
    result = result.mul("-1");
  }

  return result;
};

export { fundWallet, getToken, simpleToExactAmount, DEAD_ADDRESS, ZERO_ADDRESS, calcMinOut };
