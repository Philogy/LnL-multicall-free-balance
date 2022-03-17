// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.12;

/**
 modified copy of Uniswap's Multicall
 - repo: github.com/Uniswap/v3-periphery
 - commit: 7431d30d8007049a4c9a3027c2e082464cd977e9
 - path: contracts/base/Multicall.sol

 change(s):
 - process of self calling extracted into isolated `_selfCall` method for reuse
 - added expiring multicall for time sensitive calls
*/

abstract contract Multicall {
    function multicall(bytes[] calldata _data) public payable returns (bytes[] memory results) {
        results = new bytes[](_data.length);
        for (uint256 i = 0; i < _data.length; i++) {
            results[i] = _selfCall(_data[i]);
        }
    }

    function _selfCall(bytes memory _data) internal returns (bytes memory) {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory result) = address(this).delegatecall(_data);
        if (!success) {
            if (result.length < 68) revert("");
            // solhint-disable-next-line no-inline-assembly
            assembly {
                result := add(result, 0x04)
            }
            revert(abi.decode(result, (string)));
        }
        return result;
    }
}
