import hre from "hardhat";
import axios from "axios";
import { expect } from "chai";
const { ethers } = hre; //check
import { BigNumber } from "bignumber.js";
import { deployAndEnableConnector } from "../../../scripts/tests/deployAndEnableConnector";
import { buildDSAv2 } from "../../../scripts/tests/buildDSAv2";
import { encodeSpells } from "../../../scripts/tests/encodeSpells";
import { getMasterSigner } from "../../../scripts/tests/getMasterSigner";
import { addresses } from "../../../scripts/tests/mainnet/addresses";
import { addLiquidity } from "../../../scripts/tests/addLiquidity";
import { abis } from "../../../scripts/constant/abis";
import { ConnectV2UniswapV3AutoRouter__factory } from "../../../typechain";
import er20abi from "../../../scripts/constant/abi/basics/erc20.json";
import type { Signer, Contract } from "ethers";
import { CurrencyAmount, Token, TradeType, Currency, Percent } from "@uniswap/sdk-core";
import { AlphaRouter } from "@uniswap/smart-order-router";
const provider = new ethers.providers.JsonRpcProvider("https://mainnet.infura.io/v3/47722f74a0264bd98bdc66c7f0177333");
const router = new AlphaRouter({ chainId: 1, provider });

describe("Auto Router", function () {
  const connectorName = "Auto-Router-test";

  let dsaWallet0: Contract;
  let wallet0: Signer, wallet1: Signer;
  let masterSigner: Signer;
  let instaConnectorsV2: Contract;
  let connector: Contract;

  before(async () => {
    await hre.network.provider.request({
      method: "hardhat_reset",
      params: [
        {
          forking: {
            // @ts-ignore
            jsonRpcUrl: hre.config.networks.hardhat.forking.url
          }
        }
      ]
    });
    [wallet0, wallet1] = await ethers.getSigners();

    masterSigner = await getMasterSigner();
    instaConnectorsV2 = await ethers.getContractAt(abis.core.connectorsV2, addresses.core.connectorsV2);
    connector = await deployAndEnableConnector({
      connectorName,
      contractArtifact: ConnectV2UniswapV3AutoRouter__factory,
      signer: masterSigner,
      connectors: instaConnectorsV2
    });
    console.log("Connector address", connector.address);
  });

  it("Should have contracts deployed.", async function () {
    expect(!!instaConnectorsV2.address).to.be.true;
    expect(!!connector.address).to.be.true;
    expect(!!(await masterSigner.getAddress())).to.be.true;
  });

  describe("DSA wallet setup", function () {
    it("Should build DSA v2", async function () {
      dsaWallet0 = await buildDSAv2(await wallet0.getAddress());
      expect(!!dsaWallet0.address).to.be.true;
    });

    it("Deposit ETH and DAI into DSA wallet", async function () {
      await wallet0.sendTransaction({
        to: dsaWallet0.address,
        value: ethers.utils.parseEther("10")
      });
      await addLiquidity("dai", dsaWallet0.address, ethers.utils.parseEther("10"));
      // console.log(dsaWallet0.address);
      const daiToken = await ethers.getContractAt(
        er20abi,
        "0x6b175474e89094c44da98b954eedeac495271d0f" // dai address
      );

      expect(await daiToken.balanceOf(dsaWallet0.address)).to.be.gte(10);
      // expect(await ethers.provider.getBalance(dsaWallet0.address)).to.be.gte(ethers.utils.parseEther("10"));
    });
  });

  describe("Main", function () {
    it("should swap the tokens", async function () {
      const buyTokenAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"; //usdc
      const sellTokenAddress = "0x6b175474e89094c44da98b954eedeac495271d0f"; //dai
      const sellTokenDecimals = 18;
      const buyTokenDecimals = 6;
      const amount = 1;

      const srcAmount = new BigNumber(amount).times(new BigNumber(10).pow(sellTokenDecimals)).toFixed(0);
      const DAI = new Token(1, sellTokenAddress, sellTokenDecimals);
      const USDC = new Token(1, buyTokenAddress, buyTokenDecimals);
      const daiAmount = CurrencyAmount.fromRawAmount(DAI, srcAmount);
      const route = await router.route(daiAmount, USDC, TradeType.EXACT_OUTPUT, {
        recipient: dsaWallet0.address,
        slippageTolerance: new Percent(5, 100),
        deadline: 100
      });
      console.log(route);
      const calldata = route?.methodParameters?.calldata;
      console.log(route?.quote.numerator);
      const unitAmt = "1000149";
      const spells = [
        {
          connector: connectorName,
          method: "sell",
          args: [buyTokenAddress, sellTokenAddress, srcAmount, unitAmt, calldata, 0]
        }
      ];
      const tx = await dsaWallet0.connect(wallet0).cast(...encodeSpells(spells), await wallet1.getAddress());
      const receipt = await tx.wait();
      expect(await ethers.provider.getBalance(dsaWallet0.address)).to.be.lte(ethers.utils.parseEther("9"));
    });
  });
});
