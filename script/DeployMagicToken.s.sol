// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {MagicToken} from "../src/MagicToken.sol";

contract DeployMAT is Script {
    uint public constant INITIAL_SUPPLY = 100_000 ether;
    uint public constant ANVIL_DEPLOYER_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint public deployerKey;

    function run() external returns (MagicToken) {
        if (block.chainid == 31337) {
            deployerKey = ANVIL_DEPLOYER_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerKey);
        MagicToken mat = new MagicToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return mat;
    }
}
