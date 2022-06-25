// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title SampleVault1.sol
 * @author jackgalet.eth
 * @dev Create a sample vault, capable of receiving deposit and withdrawal requests and being topped up, to increase the asset of the vault token holders

 Note: could not achieve effective deployment on Remix, as approvals were repeatedly unsucessful.
 */

contract SampleVault1 is ERC20 {
    using SafeMath for uint256;

    //address public depositToken; //want = depositToken

    //constructor(string memory tokenName, string memory tokenSymbol, address _depositToken) ERC20(tokenName, tokenSymbol) {
    constructor(string memory tokenName, string memory tokenSymbol)
        ERC20(tokenName, tokenSymbol)
    {
        //depositToken = _depositToken;
    }

    function balance() public view returns (uint) {
        balanceOf(address(this));
        //return IERC20(depositToken).balanceOf(address(this));
    }

    function depositAll() external {
        deposit(balanceOf(msg.sender));
    }

    function deposit(uint _amount) public {
        uint256 _pool = balance();
        //IERC20(depositToken).approve(msg.sender, _amount);
        //IERC20(depositToken).transferFrom(msg.sender, address(this), _amount);
        transferFrom(msg.sender, address(this), _amount);
        uint256 _after = balance();
        _amount = _after.sub(_pool);
        uint256 shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount.mul(totalSupply())).div(_pool);
        }
        _mint(msg.sender, shares);
    }

    function withdrawAll() external {
        withdraw(balanceOf(msg.sender));
    }

    function withdraw(uint _shares) public {
        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);
        //IERC20(depositToken).transfer(msg.sender, r);
        transfer(msg.sender, r);
    }

    function topup(uint _amount) public {
        //IERC20(depositToken).approve(msg.sender, _amount);
        //IERC20(depositToken).transferFrom(msg.sender, address(this), _amount);
        transferFrom(msg.sender, address(this), _amount);
    }
}
