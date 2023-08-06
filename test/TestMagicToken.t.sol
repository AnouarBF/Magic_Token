// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {MagicToken} from "../src/MagicToken.sol";
import {DeployMAT} from "../script/DeployMagicToken.s.sol";

contract TestMagicToken is Test {
    string constant NAME = "MagicToken";
    string constant SYMBOL = "MAT";
    MagicToken mat;
    DeployMAT deployer;
    uint public constant INITIAL_SUPPLY = 100_000 ether;
    uint public constant AMOUNT = 1000 ether;

    address taha = makeAddr("taha");
    address omar = makeAddr("omar");
    address deployerKey;

    function setUp() external {
        deployer = new DeployMAT();
        mat = deployer.run();

        deployerKey = vm.addr(deployer.deployerKey());

        vm.prank(deployerKey);
        mat.transfer(taha, AMOUNT);
    }

    function testInitialSupply() external {
        assert(mat.totalSupply() == INITIAL_SUPPLY);
    }

    function testUserBalance() external {
        assert(mat.balanceOf(taha) == AMOUNT);
    }

    function testName() external {
        assert(
            keccak256(abi.encodePacked(mat.name())) ==
                keccak256(abi.encodePacked(NAME))
        );
    }

    function testSymbol() external {
        assert(
            keccak256(abi.encodePacked(mat.symbol())) ==
                keccak256(abi.encodePacked(SYMBOL))
        );
    }

    function testBalanceOf() external {
        assert(mat.balanceOf(deployerKey) == INITIAL_SUPPLY - AMOUNT);
    }

    function testTransfer() external {
        vm.prank(deployerKey);
        mat.transfer(omar, AMOUNT);
        assert(mat.balanceOf(omar) == AMOUNT);
    }

    function testApprove() external {
        assert(mat.approve(taha, AMOUNT));
    }

    function testTransferFrom() external {
        uint initialAllowance = 50 ether;
        vm.prank(taha);
        mat.approve(omar, initialAllowance);
        uint transferAmount = 20 ether;

        vm.prank(omar);
        mat.transferFrom(taha, omar, transferAmount);
        assert(mat.balanceOf(omar) == transferAmount);
        assert(mat.balanceOf(taha) == AMOUNT - transferAmount);
    }

    function testIncreaseAllowance() external {
        uint initialAllowance = 50 ether;
        vm.prank(taha);
        mat.approve(omar, initialAllowance);

        uint addedValue = 10 ether;
        vm.prank(taha);
        mat.increaseAllowance(omar, addedValue);
        assert(mat.allowance(taha, omar) == initialAllowance + addedValue);
    }

    function testDecreaseAllowance() external {
        uint initialAllowance = 50 ether;
        vm.prank(taha);
        mat.approve(omar, initialAllowance);

        uint subtractedValue = 10 ether;
        vm.prank(taha);
        mat.decreaseAllowance(omar, subtractedValue);
        assert(mat.allowance(taha, omar) == initialAllowance - subtractedValue);
    }
}
