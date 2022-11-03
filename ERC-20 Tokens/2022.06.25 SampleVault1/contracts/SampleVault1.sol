// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IStrategy.sol";

/**
 * @title SampleVault1.sol
 * @author jackgalet.eth
 * @dev Create a sample vault, capable of receiving deposit and withdrawal requests and being topped up, to increase the asset of the vault token holders

 Note: could not achieve effective deployment on Remix, as approvals were repeatedly unsucessful.
 */

contract SampleVault1 is ERC20 {
    using SafeMath for uint256;
    IStrategy public strategy;

    constructor(
        IStrategy _strategy,
        string memory tokenName,
        string memory tokenSymbol
    ) public ERC20(tokenName, tokenSymbol) {
        strategy = _strategy;
    }

    function want() public view returns (IERC20) {
        return IERC20(strategy.want());
    }

    function balance() public view returns (uint) {
        return
            want().balanceOf(address(this)).add(
                IStrategy(strategy).balanceOf()
            );
    }

    function available() public view returns (uint256) {
        return want().balanceOf(address(this));
    }

    function getPricePerFullShare() public view returns (uint256) {
        return
            totalSupply() == 0 ? 1e18 : balance().mul(1e18).div(totalSupply());
    }

    function depositAll() external {
        deposit(want().balanceOf(msg.sender));
    }

    function deposit(uint _amount) public {
        strategy.beforeDeposit();
        uint256 _pool = balance();
        want().transferFrom(msg.sender, address(this), _amount);
        earn();
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

    function earn() public {
        uint _bal = available();
        want().transfer(address(strategy), _bal);
        strategy.deposit();
    }

    function withdrawAll() external {
        withdraw(balanceOf(msg.sender));
    }

    function withdraw(uint _shares) public {
        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);
        uint b = want().balanceOf(address(this));
        if (b < r) {
            uint _withdraw = r.sub(b);
            strategy.withdraw(_withdraw);
            uint _after = want().balanceOf(address(this));
            uint _diff = _after.sub(b);
            if (_diff < _withdraw) {
                r = b.add(_diff);
            }
        }
        transfer(msg.sender, r);
    }

    function topup(uint _amount) public {
        want().transferFrom(msg.sender, address(this), _amount);
    }

    function inCaseTokensGetStuck(address _token) external {
        require(_token != address(want()), "!token");
        uint256 amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(msg.sender, amount);
    }
}
