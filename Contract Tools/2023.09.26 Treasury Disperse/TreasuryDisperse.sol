// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "WETH/IWETH.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TreasuryDisperse.sol (v1.0 September 2023)
 * @author jackgale.eth
 * @notice Contract to facilitate dispersals of gas among treasury signers directly from the treasury Safe, including native token and wrapped token (with approval, or without approval by transfer and then disperseResidue()). 
 */

contract TreasuryDisperse is Ownable {

    IWETH wnative;
    IERC20 wnative20;
    address[] addresses;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Log(string functionType, uint gas);
    event LogBytes(bytes data);

    constructor(address _wnative, address[] memory _addresses) {
        wnative = IWETH(_wnative);
        wnative20 = IERC20(_wnative);
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
     * @notice Divides the inputted value among the number of signer addresses in the stored array of addresses, and sends the divided value to each.
     * @param value The inputted value of native tokens to disperse.
     */
    function disperse(uint256 value) internal {
        uint256 amount = value / addresses.length;
        uint8 counter = 0;
        for (uint i = 0; i < addresses.length; i++){
            bool sent = payable(addresses[i]).send(amount);
            require(sent, "ERROR: Failed to disperse!");
            emit Transfer(address(this), addresses[i], amount);
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
            emit LogBytes("ERROR: wrapped transferFrom() failed. Have you approved a sufficient allowance.");
        }
        wnative.withdraw(value);
        disperse(value);
    }

    /**
     * @notice Checks for and unwraps any wrapped tokens held by the TreasuryDisperse contract, and uses disperse() to distribute both the unwrapped tokens and any native tokens already held by the TreasuryDisperse contract to the stored array of addresses.
     * @custom:tip This function allows a Safe to transfer wrapped tokens to the TreasuryDisperse contract without approving (i.e. for transferFrom), so that any user can call disperseResidue without needing signatures and execution with the Safe. 
     */
    function disperseResidue() public {
        require(address(this).balance > 0 || wnative20.balanceOf(address(this)) > 0, "ERROR: No native or wrapped tokens held by contract. Please provide value to the contract to disperse.");
        if(wnative20.balanceOf(address(this)) > 0){
            wnative.withdraw(wnative20.balanceOf(address(this)));
        }
        uint256 value = address(this).balance;
        disperse(value);
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