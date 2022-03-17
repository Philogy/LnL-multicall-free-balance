// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.12;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Multicall} from "../Multicall.sol";

contract BadWeth is ERC20, Multicall {
    constructor() ERC20("Wrapped Ether", "WETH") {}

    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external payable {
        // `ERC20._burn` checks for sufficient balance
        _burn(msg.sender, _amount);
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "WETH: Withdraw failed");
    }
}
