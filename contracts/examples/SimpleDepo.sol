// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.12;

import {NativeHolder} from "./NativeHolder.sol";

contract SimpleDepo is NativeHolder {
    mapping(address => uint256) public balances;

    function deposit(address _recipient, uint256 _msgValue) external payable isFree(_msgValue) {
        balances[_recipient] += _storeNative(_msgValue);
    }

    function release(uint256 _amount) external payable {
        balances[msg.sender] -= _releaseNative(_amount);
    }

    function withdraw(address _recipient, uint256 _amount) external payable isFree(_amount) {
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "SimpleDepo: Withdraw failed");
    }
}
