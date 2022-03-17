// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.12;

import {Multicall} from "../Multicall.sol";

abstract contract NativeHolder is Multicall {
    uint256 private heldNative;

    modifier isFree(uint256 _msgValue) {
        _checkMsgValue(_msgValue);
        _;
    }

    function _getHeldNative() internal returns (uint256) {
        return heldNative;
    }

    function _availableNative() internal returns (uint256) {
        return address(this).balance - heldNative;
    }

    function _storeNative(uint256 _newAmount) internal returns (uint256) {
        uint256 newHeld = _newAmount + heldNative;
        require(newHeld <= address(this).balance, "NativeHolder: Insufficient bal");
        heldNative = newHeld;
        return _newAmount;
    }

    function _releaseNative(uint256 _releaseAmount) internal returns (uint256) {
        uint256 currentHeld = heldNative;
        require(currentHeld >= _releaseAmount, "NativeHolder: Insufficient held");
        unchecked {
            heldNative = currentHeld - _releaseAmount;
        }
        return _releaseAmount;
    }

    function _checkMsgValue(uint256 _msgValue) internal {
        require(_msgValue <= _availableNative(), "NativeHolder: Insufficient bal");
    }
}
