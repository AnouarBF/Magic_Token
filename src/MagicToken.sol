// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MagicToken is ERC20 {
    constructor(uint initialSupply) ERC20("MagicToken", "MAT") {
        _mint(msg.sender, initialSupply);
    }
}
