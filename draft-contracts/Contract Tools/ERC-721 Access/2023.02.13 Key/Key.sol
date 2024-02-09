// SPDX-License-Identifier: MIT

// @title Key.sol
// @author jackgale.eth
// @dev sample ERC-721 NFT key designed to objectify permissions.

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Key is ERC721Burnable, AccessControl {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");

    constructor() ERC721("Vault Key", "KEY") {
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        mint(msg.sender);
    }

    function addMinter(address minter) public onlyRole(ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }

    function removeMinter(address minter) public onlyRole(ADMIN_ROLE) {
        require(hasRole(MINTER_ROLE,minter), "Selected wallet does not have minter role.");
        _revokeRole(MINTER_ROLE, minter);
    }

    function mint(address recipient) public onlyRole(MINTER_ROLE) returns(uint) {
        require((balanceOf(recipient) < 1), "Recipient already has a Key NFT.");
        uint newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _tokenIds.increment();
        return newItemId;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC721) returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }
}