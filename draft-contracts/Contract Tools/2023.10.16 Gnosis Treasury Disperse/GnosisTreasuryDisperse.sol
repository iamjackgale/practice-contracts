// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/WETH/IWETH.sol";
import "contracts/ERC-4626/IERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GnosisTreasuryDisperse.sol (v1.0 October 2023)
 * @author jackgale.eth
 * @notice Contract to facilitate dispersals of gas among treasury signers directly from the treasury Safe, including native token and wrapped token (with approval, or without approval by transfer and then disperseResidue()). 
 */

abstract contract GnosisTreasuryDisperse is Ownable {

    IWETH wnative;
    IERC20 wnative20;
    IERC4626 sDai;
    address returnAddress;
    address[] addresses;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Log(string functionType, uint gas);
    event LogBytes(bytes data);
    
    constructor(address _wnative, address _sDai, address _returnAddress, address[] memory _addresses) {
        wnative = IWETH(_wnative);
        wnative20 = IERC20(_wnative);
        sDai = IERC4626(_sDai);
        returnAddress = _returnAddress;
        addresses = _addresses;
    }

    /**
     * @notice Returns the address of the wrapped contract.
     */
    function getWrappedAddress() public view returns(address wrappedAddress) {
        return address(wnative);
    }

    /**
     * @notice Returns the address of a given signer in the stored array of addresses.
     * @param index The index for the given signer in the array.
     */
    function getSignerAddress(uint256 index) public view returns(address _address) {
        require(index < addresses.length, "ERROR: index argument is greater than the length of the array.");
        return addresses[index];
    }

    /**
     * @notice Replaces the address of the wrapped native token contract.
     * @param _address The replacement address to be substituted.
     */
    function replaceWrappedAddress(address _address) public onlyOwner {
        wnative = IWETH(_address);
        wnative20 = IERC20(_address);
    }

    /**
     * @notice Replaces a given signer address in the stored array of addresses.
     * @param index The index for the given signer in the array.
     * @param _address The replacement address to be substituted.
     */
    function replaceSignerAddress(uint256 index, address _address) public onlyOwner {
        require(index < addresses.length, "ERROR: index argument is greater than the length of the array.");
        addresses[index] = _address;
    }

    /**
     * @notice Adds a new signer address to the stored array of addresses.
     * @param _address The new address to be added.
     */
    function addSignerAddress(address _address) public onlyOwner {
        addresses.push(_address);
    }

    /**
     * @notice Removes an existing signer address from the stored array of addresses.
     * @param index The index for the given signer in the array.
     */
    function removeSignerAddress(uint256 index) public onlyOwner {
        addresses[index] = addresses[addresses.length - 1];
        addresses.pop();
    }

    /**
     * @notice Sends the inputted value to the specified address.
     * @param value The inputted value of native tokens to disperse.
     */
    function disperseSpecific(address recipient, uint256 value) internal {
        bool sent = payable(recipient).send(value);
        require(sent, "ERROR: Failed to disperse!");
        emit Transfer(address(this), recipient, value);
    }

    /**
     * @notice Divides the inputted value among the number of signer addresses in the stored array of addresses, and sends the divided value to each.
     * @param value The inputted value of native tokens to disperse.
     */
    function disperse(uint256 value) internal {
        uint256 amount = value / addresses.length;
        uint8 counter = 0;
        for (uint i = 0; i < addresses.length; i++){
            disperseSpecific(addresses[i], amount);
            counter += 1;
        }
    }

    /**
     * @notice Uses disperse() to distribute the value of native tokens sent with the message to the stored array of addresses.
     */
    function disperseNative() public payable {
        require(msg.value > 0, "ERROR: No value passed with the function. Please provide value of native tokens to disperse.");
        disperse(msg.value);
    }

    /**
     * @notice Uses disperseSpecific() to distribute the value of native tokens sent with the message to the specified address.
     */
    function disperseNativeSpecific(address recipient) public payable {
        require(msg.value > 0, "ERROR: No value passed with the function. Please provide value of native tokens to disperse.");
        disperseSpecific(recipient, msg.value);
    }

    /**
     * @notice Unwraps the specified value of wrapped tokens and uses disperse() to distribute the unwrapped tokens to the stored array of addresses.
     * @param value The inputted value of wrapped tokens to disperse.
     * @custom:tip Note that this function requires an approval on the wrapped native token contract in favour of the deployed TreasuryDisperse contract for the amount to be sent.
     */
    function disperseWrapped(uint256 value) public {
        require(value > 0, "ERROR: No value passed with the function. Please provide value of wrapped tokens to disperse.");
        require(wnative20.balanceOf(msg.sender) > 0, "ERROR: Caller has no wrapped tokens. Please provide value of wrapped tokens to disperse.");
        require(wnative20.balanceOf(msg.sender) >= value, "ERROR: Caller does not have value of wrapped tokens called. Please input amount equal to or less than caller's balance of wrapped tokens.");
        try wnative.transferFrom(msg.sender, address(this), value){
        } catch {
            emit LogBytes("ERROR: wrapped transferFrom() failed. Have you approved a sufficient allowance?");
        }
        wnative.withdraw(value);
        disperse(value);
    }

    /**
     * @notice Unwraps the specified value of wrapped tokens and uses disperseSpecific() to distribute the unwrapped tokens to the specified address.
     * @param value The inputted value of wrapped tokens to disperse.
     * @custom:tip Note that this function requires an approval on the wrapped native token contract in favour of the deployed TreasuryDisperse contract for the amount to be sent.
     */
    function disperseWrappedSpecific(address recipient, uint256 value) public {
        require(value > 0, "ERROR: No value passed with the function. Please provide value of wrapped tokens to disperse.");
        require(wnative20.balanceOf(msg.sender) > 0, "ERROR: Caller has no wrapped tokens. Please provide value of wrapped tokens to disperse.");
        require(wnative20.balanceOf(msg.sender) >= value, "ERROR: Caller does not have value of wrapped tokens called. Please input amount equal to or less than caller's balance of wrapped tokens.");
        try wnative.transferFrom(msg.sender, address(this), value){
        } catch {
            emit LogBytes("ERROR: wrapped transferFrom() failed. Have you approved a sufficient allowance?");
        }
        wnative.withdraw(value);
        disperseSpecific(recipient, value);
    }

    /**
     * @notice Withdraws the specified value of sDai tokens, unwraps the withdrawal and uses disperse() to distribute the unwrapped tokens to the stored array of addresses.
     * @param value The inputted value of sDai tokesn to disperse.
     * @custom:tip Note that this function requires an approval on the sDai token contract in favour of the deployed TreasuryDisperse contract for the amount to be sent.
     */
    function disperseSDai(uint256 value) public {
        require(value > 0, "ERROR: No value passed with the function. Please provide value of sDai tokens to disperse.");
        require(sDai.balanceOf(msg.sender) > 0, "ERROR: Caller has no sDai tokens. Please provide value of wrapped tokens to disperse.");
        require(sDai.balanceOf(msg.sender) >= value, "ERROR: Caller does not have value of sDai tokens called. Please input amount equal to or less than caller's balance of sDai tokens.");
        try sDai.transferFrom(msg.sender, address(this), value){
        } catch {
            emit LogBytes("ERROR: sDai transferFrom() failed. Have you approved a sufficient allowance?");
        }
        sDai.withdraw(sDai.balanceOf(address(this)), address(this), address(this));
        wnative.withdraw(value);
        disperse(value);
    }

    /**
     * @notice Withdraws the specified value of sDai tokens, unwraps the withdrawal and uses disperseSpecific() to distribute the unwrapped tokens to the specified address.
     * @param value The inputted value of sDai tokesn to disperse.
     * @custom:tip Note that this function requires an approval on the sDai token contract in favour of the deployed TreasuryDisperse contract for the amount to be sent.
     */
    function disperseSDaiSpecific(address recipient, uint256 value) public {
        require(value > 0, "ERROR: No value passed with the function. Please provide value of sDai tokens to disperse.");
        require(sDai.balanceOf(msg.sender) > 0, "ERROR: Caller has no sDai tokens. Please provide value of wrapped tokens to disperse.");
        require(sDai.balanceOf(msg.sender) >= value, "ERROR: Caller does not have value of sDai tokens called. Please input amount equal to or less than caller's balance of sDai tokens.");
        try sDai.transferFrom(msg.sender, address(this), value){
        } catch {
            emit LogBytes("ERROR: sDai transferFrom() failed. Have you approved a sufficient allowance?");
        }
        sDai.withdraw(sDai.balanceOf(address(this)), address(this), address(this));
        wnative.withdraw(value);
        disperseSpecific(recipient, value);
    }

    /**
     * @notice Checks for and unwraps any wrapped tokens held by the TreasuryDisperse contract, and uses disperse() to distribute both the unwrapped tokens and any native tokens already held by the TreasuryDisperse contract to the stored array of addresses.
     * @custom:tip This function allows a Safe to transfer wrapped tokens to the TreasuryDisperse contract without approving (i.e. for transferFrom), so that any user can call disperseResidue without needing signatures and execution with the Safe. 
     */
    function disperseResidue() public {
        require(address(this).balance > 0 || wnative20.balanceOf(address(this)) > 0 || sDai.balanceOf(address(this)) > 0, "ERROR: No applicable tokens held by contract. Please provide value to the contract to disperse.");
        if(sDai.balanceOf(address(this)) > 0){
            sDai.withdraw(sDai.balanceOf(address(this)), address(this), address(this));
        }
        if(wnative20.balanceOf(address(this)) > 0){
            wnative.withdraw(wnative20.balanceOf(address(this)));
        }
        uint256 value = address(this).balance;
        disperse(value);
    }

    /**
     * @notice Checks for and unwraps any wrapped tokens held by the TreasuryDisperse contract, and uses disperseSpecific() to distribute both the unwrapped tokens and any native tokens already held by the TreasuryDisperse contract to the specified address.
     * @custom:tip This function allows a Safe to transfer wrapped tokens to the TreasuryDisperse contract without approving (i.e. using transfer() not transferFrom()), so that any user can call disperseResidue without needing signatures and execution with the Safe. 
     */
    function disperseResidueSpecific(address recipient) public {
        require(address(this).balance > 0 || wnative20.balanceOf(address(this)) > 0 || sDai.balanceOf(address(this)) > 0, "ERROR: No applicable tokens held by contract. Please provide value to the contract to disperse.");
        if(wnative20.balanceOf(address(this)) > 0){
            wnative.withdraw(wnative20.balanceOf(address(this)));
        }
        if(sDai.balanceOf(address(this)) > 0){
            sDai.withdraw(sDai.balanceOf(address(this)), address(this), address(this));
        }
        uint256 value = address(this).balance;
        disperseSpecific(recipient, value);
    }

    /**
     * @notice Checks for and deposits any native or wrapped tokens held by the TreasuryDisperse contract into sDAI, and returns the residual sDAI to the treasury address.
     * @custom:tip This function allows a Safe to transfer wrapped tokens to the TreasuryDisperse contract without approving (i.e. using transfer() not transferFrom()), so that any user can call returnResidue without needing signatures and execution with the Safe. 
     */
    function returnResidue() public {
        require(address(this).balance > 0 || wnative20.balanceOf(address(this)) > 0 || sDai.balanceOf(address(this)) > 0, "ERROR: No applicable tokens held by contract. Please provide value to the contract to disperse.");
        if(address(this).balance > 0){
            wnative.deposit{value: address(this).balance}();
        }
        if(wnative20.balanceOf(address(this)) > 0){
            sDai.deposit(wnative20.balanceOf(address(this)), address(this));
        }
        sDai.transfer(address(returnAddress), sDai.balanceOf(address(this)));
        emit Transfer(address(this), address(returnAddress), sDai.balanceOf(address(this)));
    }

    /**
     * @notice Receive function to handle income native tokens with no data by default.
     */
    receive() external payable {
        emit Log("Receive", gasleft());
    }

    /**
     * @notice Fallback function to handle incoming transactions with data by default.
     */
    fallback() external payable {
        emit Log("Fallback", gasleft());
    }
}