// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    constructor() ERC721("SampleNFT1", "sNFT1") {
        _mint(msg.sender, 1);
    }
}

//See testnet deployment here: https://goerli.etherscan.io/address/0x191b4dca2c266f676003236122ee91c1edf0b63b
