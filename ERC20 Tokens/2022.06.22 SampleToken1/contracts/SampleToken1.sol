// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Token2
 * @author jackgale.eth
 * @dev a sample token incorporating additional functionality to mint and burn tokens and pause all transfers.
 */

contract SampleERC20 is Context, AccessControlEnumerable, ERC20, ERC20Pausable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    string public status;
    uint256 public tokenSupply;
    uint256 public netMintBurn;

    constructor() ERC20("Karmic Credit", "KRC") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);
        _mint(msg.sender, 1000000); //Not including decimalisation
        status = "No tokens have been minted or burned.";
        tokenSupply = tokenSupply + 1000000;
    }

    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, msg.sender), "Error: You must have minter role to mint");
        _mint(to, amount);
        tokenSupply = tokenSupply + amount;
        netMintBurn = netMintBurn + amount;
        if (netMintBurn > 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been minted.";
            status = string.concat(prefix, suffix);
        } else if (netMintBurn < 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been burned.";
            status = string.concat(prefix, suffix);
        } else { }
    }

    function burn(address from, uint256 amount) public virtual {
        require(hasRole(BURNER_ROLE, msg.sender), "Error: You must have burner role to burn");
        burn(from, amount);
        tokenSupply = tokenSupply - amount;
        netMintBurn = netMintBurn - amount;
        if (netMintBurn > 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been minted.";
            status = string.concat(prefix, suffix);
        } else if (netMintBurn < 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been burned.";
            status = string.concat(prefix, suffix);
        } else { }
    }

    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "Error: You must have pauser role to pause");
        pause();
    }

    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
        unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}