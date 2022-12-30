const { ethers } = require("hardhat");
const { expect, assert } = require("chai");

describe("Currency", function () {
  let contractFactory, contract, deployer;

  beforeEach(async function () {
    contractFactory = await ethers.getContractFactory("Currency");
    contract = await contractFactory.deploy();
    deployer = await contract.deployer();
  });

  it("(1) deployer() returns deployer", async function () {
    returnedDeployer = await contract.deployer();
    assert.equal(returnedDeployer, deployer);
  });

  it("(2) first minted tokens equal totalSupply", async function () {
    await contract.mint(deployer, 100);
    const currentAmount = await contract.totalSupply();
    assert.equal(currentAmount, 100);
  });

  it("(3) first minted tokens for caller equal balanceOf", async function () {
    await contract.mint(deployer, 100);
    const currentAmount = await contract.balanceOf(deployer);
    assert.equal(currentAmount, 100);
  });
});
