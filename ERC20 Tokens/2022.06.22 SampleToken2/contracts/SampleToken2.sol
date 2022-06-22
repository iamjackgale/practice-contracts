// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Import base contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title SampleToken2
 * @author jackgale.eth
 * @dev a sample token built on OpenZeppelin's libary of stock contracts. 
        
        This builds on the first sample by incorporating additional functionality to mint and burn tokens and pause all transfers. To do so, it incorporates access control through the Roles module. 
 
        It also incorporates three customer trackers: "status", "netMintBurn" and "isItPaused". netMintBurn tracks the amount of minting and burning that has taken place to give a net figure for total minting/burning (i.e. total minted - total burned = netMintBurn). status utilises netMintBurn to give a statement of the total number of tokens minted or burned in the life of the token, which updates with each mint or burn. isItPaused is changed where the contract is paused (and resumed when unpaused), to allow users to read whether the contract is paused.
 */

//create SampleToken2 as a derivative of the above OpenZeppelin modules
contract SampleToken2 is
    Context,
    AccessControlEnumerable,
    ERC20,
    ERC20Pausable,
    ERC20Burnable
{
    //set role constants building on AccessControlEnumerable.sol
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    //set tracker variables
    string public status;
    string public isItPaused;
    uint256 public tokenSupply;
    uint256 public netMintBurn;

    constructor() ERC20("SampleToken2", "ST2") {
        //give deployer all roles on deployment
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);

        //mint 1,000,000 tokens and provide to deployer
        _mint(msg.sender, 1000000); //Not including decimalisation

        //set initial tracker values
        status = "No tokens have been minted or burned.";
        isItPaused = "Tokens are fully operational and not paused.";
        tokenSupply = tokenSupply + 1000000;
    }

    //incorporate basic mint function from ERC20.sol
    function mint(address to, uint256 amount) public virtual {
        require(
            hasRole(MINTER_ROLE, msg.sender), //check to ensure caller has relevant role
            "Error: You must have minter role to mint"
        );
        _mint(to, amount); //if so, mint

        //update netMintBurn calculation in light of mint
        tokenSupply = tokenSupply + amount;
        netMintBurn = netMintBurn + amount;

        //set status depending on impact of mint
        if (netMintBurn > 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been minted.";
            status = string.concat(prefix, suffix);
        } else if (netMintBurn < 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been burned.";
            status = string.concat(prefix, suffix);
        } else {}
    }

    //incorporate basic burn function from ERC20Burnable.sol
    function burn(address from, uint256 amount) public virtual {
        require(
            hasRole(BURNER_ROLE, msg.sender), //check to ensure caller has relevant role
            "Error: You must have burner role to burn"
        );
        burn(from, amount); //if so, burn

        //update netMintBurn calculation in light of burn
        tokenSupply = tokenSupply - amount;
        netMintBurn = netMintBurn - amount;

        //set status depending on impact of burn
        if (netMintBurn > 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been minted.";
            status = string.concat(prefix, suffix);
        } else if (netMintBurn < 0) {
            string memory prefix = Strings.toString(netMintBurn);
            string memory suffix = " new tokens have been burned.";
            status = string.concat(prefix, suffix);
        } else {}
    }

    //incorporate basic pause function from ERC20Pauseable.sol
    function pause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()), //check to ensure caller has relevant role
            "Error: You must have pauser role to pause"
        );
        pause(); //if so, pause
        isItPaused = "Tokens are paused. You will not be able to transfer until unpaused."; //update pause tracker variable
    }

    //incorporate basic unpause function from ERC20Pauseable.sol
    function unpause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()), //check to ensure caller has relevant role
            "Error: You must have pauser role to unpause"
        );
        unpause(); //if so, unpause
        isItPaused = "Tokens are fully operational and not paused."; //update pause tracker variable
    }

    //Amend inherited token transfer procedure from ERC20.sol to check for whether the contract is paused before any transfers
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount); //super calls the inherited function from higher up the inheritence heirarchy
    }
}
