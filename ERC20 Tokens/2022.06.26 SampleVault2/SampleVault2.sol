// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title SampleVault2.sol
 * @author jackgalet.eth
 * @dev Create a sample vault, capable of receiving deposit and withdrawal requests and being topped up, to increase the asset of the vault token holders
 */

contract SampleVault1 is ERC20 {
    using SafeMath for uint256;

    // Tokens used
    address public depositToken;
    IERC20 public dToken;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        address _depositToken
    ) public ERC20(tokenName, tokenSymbol) {
        depositToken = _depositToken;
        dToken = IERC20(depositToken);
    }

    function availableToDeposit() public view returns (uint) {
        return dToken.balanceOf(msg.sender);
    }

    function balance() public view returns (uint) {
        return dToken.balanceOf(address(this));
    }

    function depositAll() external {
        deposit(dToken.balanceOf(msg.sender));
    }

    function deposit(uint _amount) public {
        uint256 _pool = balance();
        dToken.approve(address(this), _amount);
        dToken.transferFrom(msg.sender, address(this), _amount);
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
        dToken.transfer(msg.sender, r);
    }

    /*
    function inCaseTokensGetStuck(address _token) external {
        require(_token != address(want()), "!token");
        uint256 amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(msg.sender, amount);
    }
*/
}
