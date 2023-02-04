// SPDX-License-Identifier: MIT

// @title test_NFTFactory1.js
// @author jackgale.eth
// @dev testing file for NFTFactory1.sol

const { ethers } = require("hardhat");
const { expect, assert } = require("chai");

describe("NFTFactory1", function () {
  let contractFactory, contract, owner;

  beforeEach(async function () {
    contractFactory = await ethers.getContractFactory("NFTFactory1");
    contract = await contractFactory.deploy();
    owner = await contract.owner();
    await contract.mint("testURI1");
  });

  it("Should have symbol: 'sNFT'", async function () {
    const currentSymbol = await contract.symbol();
    const expectedSymbol = "sNFT";
    assert.equal(currentSymbol.toString(), expectedSymbol);
  });

  it("Should have name: 'Sample Collection'", async function () {
    const currentName = await contract.name();
    const expectedName = "Sample Collection";
    assert.equal(currentName.toString(), expectedName);
  });

  it("Should show ownerOf minted tokens as owner", async function () {
    const ownerOf = await contract.ownerOf(0);
    assert.equal(ownerOf.toString(), owner);
  });

  it("Should show balanceOf owner as number of minted tokens", async function () {
    await contract.mint("testURI2");
    await contract.mint("testURI3");
    const balanceOfOwner = await contract.balanceOf(owner.toString());
    assert.equal(balanceOfOwner, 3);
  });

  it("Should show testURI1 for tokenURI of owner's minted token", async function () {
    const tokenURI = await contract.tokenURI(0);
    assert.equal(tokenURI.toString(), "testURI1");
  });

  it("Should show balanceOf owner as zero after burning tokens", async function () {
    await contract.burn(0);
    const balanceOfOwner = await contract.balanceOf(owner.toString());
    assert.equal(balanceOfOwner, 0);
  });
});
