// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.12;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Multicall} from "../Multicall.sol";

/**
 * @dev sample test token
 */
contract Token is ERC20, Multicall {
    constructor() ERC20("Some token", "TOK") {}

    function mint(address _recipient, uint256 _amount) external {
        _mint(_recipient, _amount);
    }
}
