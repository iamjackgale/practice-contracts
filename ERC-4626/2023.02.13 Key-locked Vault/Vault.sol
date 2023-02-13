// SPDX-License-Identifier: MIT

// @title vault.sol
// @author jackgale.eth

// @dev template ERC-4626 vault contract, adapted from OpenZeppelin's ERC-4626 for ERC-20 assets only.
// @dev key change is to allow the deployer to give a name and symbol for the vault deposit token.
// @dev does not include any operative functions for handling assets once deposited into the vault.
// @ref based on: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC4626.sol

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Vault is ERC20, IERC4626 {
    
    // >>> LIBRARIES <<<
    using Math for uint256;

    // >>> VARIABLES <<<
    IERC20 private immutable _asset;
    IERC721 private immutable _key;

    // >>> EVENTS <<<
    event Deposit(address caller, uint256 amt);
    event Withdraw(address caller, address receiver, uint256 amt, uint256 shares);

    // >>> CONSTRUCTOR <<<
    // @dev Sets the underlying ERC-20 asset for the vault contract and names the vault ERC-20 token
    constructor(IERC20 asset_, IERC721 key_) ERC20("Vault Deposit Token", "DEPOSIT") { //Set vault token name and symbol
        _asset = asset_;
        _key = key_;
    }

    // >>> MODIFIERS <<<
    // @dev Requires 
    modifier onlyKeyHolder() {
        require(_key.balanceOf(msg.sender)!=0, "Access restricted to key holders.");
        _;
    }

    // >>> PUBLIC WRITE METHODS <<<
    // @dev Adopting various prescriptive methods for ERC-4626
    function asset() public view virtual override returns (address) {
        return address(_asset);
    }

    function totalAssets() public view virtual override returns (uint256) {
        return _asset.balanceOf(address(this));
    }

    function convertToShares(uint256 assets) public view virtual override returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Down);
    }

    function convertToAssets(uint256 shares) public view virtual override returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Down);
    }

    function maxDeposit(address) public view virtual override returns (uint256) {
        return _isVaultHealthy() ? type(uint256).max : 0;
    }

    function maxMint(address) public view virtual override returns (uint256) {
        return type(uint256).max;
    }

    function maxWithdraw(address owner) public view virtual override returns (uint256) {
        return _convertToAssets(balanceOf(owner), Math.Rounding.Down);
    }

    function maxRedeem(address owner) public view virtual override returns (uint256) {
        return balanceOf(owner);
    }

    function previewDeposit(uint256 assets) public view virtual override returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Down);
    }

    function previewMint(uint256 shares) public view virtual override returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Up);
    }

    function previewWithdraw(uint256 assets) public view virtual override returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Up);
    }

    function previewRedeem(uint256 shares) public view virtual override returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Down);
    }

    // >>> PUBLIC READ METHODS <<<

    function deposit(uint256 assets, address receiver) public virtual override onlyKeyHolder returns (uint256) {
        require(assets <= maxDeposit(receiver), "ERC4626: deposit more than max");
        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);
        return shares;
    }

    function mint(uint256 shares, address receiver) public virtual override onlyKeyHolder returns (uint256) {
        require(shares <= maxMint(receiver), "ERC4626: mint more than max");
        uint256 assets = previewMint(shares);
        _deposit(_msgSender(), receiver, assets, shares);
        return assets;
    }

    function withdraw(uint256 assets, address receiver, address owner) public virtual override onlyKeyHolder returns (uint256) {
        require(assets <= maxWithdraw(owner), "ERC4626: withdraw more than max");

        uint256 shares = previewWithdraw(assets);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    function redeem(uint256 shares, address receiver, address owner) public virtual override onlyKeyHolder returns (uint256) {
        require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");

        uint256 assets = previewRedeem(shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return assets;
    }

    // >>> INTERNAL READ METHODS <<<

    function _convertToShares(uint256 assets, Math.Rounding rounding) internal view virtual returns (uint256) {
        uint256 supply = totalSupply();
        return
            (assets == 0 || supply == 0)
                ? _initialConvertToShares(assets, rounding)
                : assets.mulDiv(supply, totalAssets(), rounding);
    }

    function _initialConvertToShares(
        uint256 assets,
        Math.Rounding /*rounding*/
    ) internal view virtual returns (uint256 shares) {
        return assets;
    }

    function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256) {
        uint256 supply = totalSupply();
        return
            (supply == 0) ? _initialConvertToAssets(shares, rounding) : shares.mulDiv(totalAssets(), supply, rounding);
    }

    function _initialConvertToAssets(
        uint256 shares,
        Math.Rounding /*rounding*/
    ) internal view virtual returns (uint256) {
        return shares;
    }

    function _isVaultHealthy() private view returns (bool) {
        return totalAssets() > 0 || totalSupply() == 0;
    }

    // >>> INTERNAL WRITE METHODS <<<

    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal virtual {
        SafeERC20.safeTransferFrom(_asset, caller, address(this), assets);
        _mint(receiver, shares);
        emit Deposit(caller, receiver, assets, shares);
    }

    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal virtual {
        if (caller != owner) {
            _spendAllowance(owner, caller, shares);
        }
        _burn(owner, shares);
        SafeERC20.safeTransfer(_asset, receiver, assets);
        emit Withdraw(caller, receiver, owner, assets, shares);
    }
}