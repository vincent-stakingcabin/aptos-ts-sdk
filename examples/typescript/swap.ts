/* eslint-disable no-console */
/* eslint-disable max-len */

/**
 * Example to demonstrate creating and adding to liquidity pools, swapping between two fungible asset.
 *
 * Steps:
 * 1. Create two accounts (Alice and Bob)
 * 2. Fund Alice and Bob
 * 3. Create a FA with Alice as the owner
 * 4. Create another FA with Bob as the owner
 * 5. Create a liquidity pool with Alice's FA and Bob's FA
 * 6. Swap between Alice's FA and Bob's FA
 */
import "dotenv";
import {
  Account,
  AccountAddress,
  Aptos,
  AptosConfig,
  Bool,
  Ed25519PrivateKey,
  Network,
  NetworkToNetworkName,
  U64,
  ViewRequestData,
} from "@aptos-labs/ts-sdk";
import { createInterface } from "readline";
// Default to devnet, but allow for overriding
const APTOS_NETWORK: Network = NetworkToNetworkName[process.env.APTOS_NETWORK] || Network.DEVNET;

const readline = createInterface({
  input: process.stdin,
  output: process.stdout,
});

const getOptimalLpAmount = async (
  aptos: Aptos,
  swap: AccountAddress,
  token1Addr: AccountAddress,
  token2Addr: AccountAddress,
): Promise<void> => {
  const payload: ViewRequestData = {
    function: `${swap.toString()}::router::optimal_liquidity_amounts`,
    functionArguments: [token1Addr.toString(), token2Addr.toString(), false, "200000", "300000", "200", "300"],
  };
  const result = await aptos.view({ payload });
  console.log("Optimal LP amount: ", result);
};

const addLiquidity = async (
  aptos: Aptos,
  swap: AccountAddress,
  deployer: Account,
  token1Addr: AccountAddress,
  token2Addr: AccountAddress,
): Promise<string> => {
  const rawTxn = await aptos.generateTransaction({
    sender: deployer.accountAddress.toString(),
    data: {
      function: `${swap.toString()}::router::add_liquidity_entry`,
      functionArguments: [
        token1Addr,
        token2Addr,
        new Bool(false),
        new U64(200000),
        new U64(300000),
        new U64(200),
        new U64(300),
      ],
    },
  });
  const pendingTxn = await aptos.signAndSubmitTransaction({ signer: deployer, transaction: rawTxn });
  const response = await aptos.waitForTransaction({ transactionHash: pendingTxn.hash });
  console.log("Add liquidity succeed. - ", response.hash);
  return response.hash;
};

const swapAssets = async (
  aptos: Aptos,
  swap: AccountAddress,
  deployer: Account,
  fromToken: AccountAddress,
  toToken: AccountAddress,
  amountIn: number,
  amountOutMin: number,
  recipient: AccountAddress,
): Promise<string> => {
  const rawTxn = await aptos.generateTransaction({
    sender: deployer.accountAddress.toString(),
    data: {
      function: `${swap.toString()}::router::swap_entry`,
      functionArguments: [new U64(amountIn), new U64(amountOutMin), fromToken, toToken, new Bool(false), recipient],
    },
  });
  const pendingTxn = await aptos.signAndSubmitTransaction({ signer: deployer, transaction: rawTxn });
  const response = await aptos.waitForTransaction({ transactionHash: pendingTxn.hash });
  console.log("Swap succeed. - ", response.hash);
  return response.hash;
};

const getAssetType = async (aptos: Aptos, owner: Account): Promise<any> => {
  const data = await aptos.getFungibleAssetMetadata({
    options: {
      where: {
        creator_address: { _eq: owner.accountAddress.toStringLong() },
      },
    },
  });

  if (data.length !== 2) throw new Error("Expected two Fungible Assets.");

  console.log("Fungible Asset: ", data);
  return {
    cat: data[0].asset_type,
    dog: data[1].asset_type,
  };
};

const getFaBalance = async (aptos: Aptos, owner: Account, assetType: string): Promise<number> => {
  const data = await aptos.getCurrentFungibleAssetBalances({
    options: {
      where: {
        owner_address: { _eq: owner.accountAddress.toStringLong() },
        asset_type: { _eq: assetType },
      },
    },
  });

  return data[0].amount;
};

const createLiquidityPool = async (
  aptos: Aptos,
  swap: AccountAddress,
  deployer: Account,
  dogCoinAddr: AccountAddress,
  catCoinAddr: AccountAddress,
): Promise<string> => {
  const rawTxn = await aptos.generateTransaction({
    sender: deployer.accountAddress.toString(),
    data: {
      function: `${swap.toString()}::router::create_pool`,
      functionArguments: [dogCoinAddr, catCoinAddr, new Bool(false)],
    },
  });
  const pendingTxn = await aptos.signAndSubmitTransaction({ signer: deployer, transaction: rawTxn });
  const response = await aptos.waitForTransaction({ transactionHash: pendingTxn.hash });
  console.log("Creating liquidity pool successful. - ", response.hash);
  return response.hash;
};

const initLiquidityPool = async (aptos: Aptos, swap: AccountAddress, deployer: Account): Promise<string> => {
  const rawTxn = await aptos.generateTransaction({
    sender: deployer.accountAddress.toString(),
    data: {
      function: `${swap.toString()}::liquidity_pool::initialize`,
      functionArguments: [],
    },
  });
  const pendingTxn = await aptos.signAndSubmitTransaction({ signer: deployer, transaction: rawTxn });
  const response = await aptos.waitForTransaction({ transactionHash: pendingTxn.hash });
  console.log("Init LP Pool success. - ", response.hash);
  return response.hash;
};

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const createFungibleAsset = async (aptos: Aptos, admin: Account): Promise<void> => {
  await new Promise<void>((resolve) => {
    readline.question(
      "Follow the steps to publish the Dog and Cat Coin module with Admin's address, and press enter. \n" +
        "1. cd to /aptos-ts-sdk/examples/typescript/facoin folder \n" +
        "2. run 'aptos move publish --named-address FACoin=[admin] --profile=[admin] \n" +
        "   Note: [admin] is the same profile you used to publish your 'swap' package",
      () => {
        resolve();
      },
    );
  });
};

/**
 *  Admin mint the coin
 */
const mintCoin = async (aptos: Aptos, admin: Account, amount: number | bigint, coinName: string): Promise<string> => {
  const rawTxn = await aptos.generateTransaction({
    sender: admin.accountAddress.toString(),
    data: {
      function: `${admin.accountAddress.toString()}::${coinName}::mint`,
      functionArguments: [admin.accountAddress, new U64(amount)],
    },
  });
  const pendingTxn = await aptos.signAndSubmitTransaction({ signer: admin, transaction: rawTxn });
  const response = await aptos.waitForTransaction({ transactionHash: pendingTxn.hash });
  console.log(`Minting ${coinName} coin successful. - `, response.hash);
  return response.hash;
};

const example = async () => {
  console.log(
    "This example will create a main user account called 'Admin', it will be used to deploy Liquidity pool and two new fungible assets. \n" +
      "After creating the Dog and Cat coin, and the liquidity pool, it will swap one token for another. \n" +
      "Note: This example requires you to have the 'swap' module published before running. \n" +
      "If you haven't published the 'swap' module, please publish the package using \n" +
      "'aptos move create-resource-account-and-publish-package --seed 0 --address-name=swap --named-addresses deployer=[admin] --profile [admin]' first. \n" +
      "[admin] is the account profile you will be using for this example. \n",
  );

  // Prerequisite check
  if (process.argv.length !== 4) {
    console.log("Required usage: pnpm swap [swap_address] [user_private_key]");
    process.exit(1);
  }

  const aptosConfig = new AptosConfig({ network: APTOS_NETWORK });
  const aptos = new Aptos(aptosConfig);
  // Create three accounts
  const swapAddress = AccountAddress.fromHexInput(process.argv[2]);
  const admin = Account.fromPrivateKeyAndAddress({
    privateKey: new Ed25519PrivateKey(process.argv[3]),
    address: swapAddress,
  });

  console.log("====== Account info ======\n");
  console.log(`Admin's address is: ${admin.accountAddress.toString()}`);
  console.log(`Swap address is: ${swapAddress.toString()}`);
  // Fund Admin account
  await aptos.fundAccount({ accountAddress: admin.accountAddress.toString(), amount: 100_000_000 });

  console.log("\n====== Create Fungible Asset -> (Dog and Cat coin) ======\n");
  await createFungibleAsset(aptos, admin);
  const assetTypes = await getAssetType(aptos, admin);
  const dogCoinAddr = AccountAddress.fromHexInput(assetTypes.dog.toString());
  const catCoinAddr = AccountAddress.fromHexInput(assetTypes.cat.toString());
  console.log(`Cat FACoin asset type: ${catCoinAddr}`);
  console.log(`Dog FACoin asset type: ${dogCoinAddr}`);

  console.log("\n====== Mint Dog and Cat Coin ======\n");
  console.log("minting 20_000_000 Dog coin...");
  await mintCoin(aptos, admin, 20_000_000, "dog");
  console.log("minting 30_000_000 Cat coin...");
  await mintCoin(aptos, admin, 30_000_000, "cat");

  console.log("\n====== Current Balance ======\n");
  console.log(`Admin's Dog coin balance: ${await getFaBalance(aptos, admin, dogCoinAddr.toString())}.`);
  console.log(`Admin's Cat coin balance: ${await getFaBalance(aptos, admin, catCoinAddr.toString())}.`);

  console.log("\n====== Create Liquidity Pool ======\n");
  console.log("initializing Lquidity Pool......");
  await initLiquidityPool(aptos, swapAddress, admin);
  console.log("Creating liquidity pool......");
  await createLiquidityPool(aptos, swapAddress, admin, dogCoinAddr, catCoinAddr);
  console.log("Getting optimal LP amount......");
  await getOptimalLpAmount(aptos, swapAddress, dogCoinAddr, catCoinAddr);
  console.log("Adding liquidity......");
  await addLiquidity(aptos, swapAddress, admin, dogCoinAddr, catCoinAddr);
  console.log("Done.");

  console.log("\n====== Swap 100 Dog coins for Cat coins ======\n");
  console.log("Swaping 100 Dog coin to Cat coin......");
  await swapAssets(aptos, swapAddress, admin, dogCoinAddr, catCoinAddr, 100, 1, admin.accountAddress);
  console.log("Swap finished.");

  console.log("\n====== Current Balance ======\n");
  console.log(`Admin's Dog coin balance: ${await getFaBalance(aptos, admin, dogCoinAddr.toString())}.`);
  console.log(`Admin's Cat coin balance: ${await getFaBalance(aptos, admin, catCoinAddr.toString())}.`);

  readline.close();
};

example();
