// SPDX-License-Identifier: MIT

// @title NoImportsSampleContract.sol
// @author jackgale.eth
// @dev basic contract with no imports, for use in development/testing.

pragma solidity 0.8.17;

contract NoImportsSampleContract {
    string private _name;
    address private _deployer;

    constructor() {
        _name = "NoImportsSampleContract";
        _deployer = msg.sender;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function deployer() public view returns (address) {
        return _deployer;
    }
}
