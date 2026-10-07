// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {ERC20} from "../lib/solmate/src/tokens/ERC20.sol";
import {ERC4626Vault} from "../src/erc4626vault.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MCK", 18) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract ERC4626VaultTest is Test {
    ERC4626Vault public vault;
    MockERC20 public underlyingToken;

    function setUp() public {
        underlyingToken = new MockERC20();

        vault = new ERC4626Vault(ERC20(address(underlyingToken)), "Vault Token", "vMCK");
    }

    function test_FuzzDeposit(uint256 assets) public {
        vm.assume(assets > 0 && assets < type(uint128).max);

        underlyingToken.mint(address(this), assets);
        underlyingToken.approve(address(vault), assets);

        uint256 expectedShares = vault.previewDeposit(assets);
        uint256 actualShares = vault.deposit(assets, address(this));

        assertEq(actualShares, expectedShares, "Preview mismatch with actual deposit");
        assertEq(vault.balanceOf(address(this)), expectedShares, "Incorrect share balance");
    }

    function test_FuzzWithdraw(uint256 assets) public {
        vm.assume(assets > 0 && assets < type(uint128).max);

        underlyingToken.mint(address(this), assets);
        underlyingToken.approve(address(vault), assets);

        uint256 shares = vault.deposit(assets, address(this));

        uint256 expectedAssets = vault.previewRedeem(shares);
        uint256 actualAssets = vault.withdraw(expectedAssets, address(this), address(this));

        assertEq(actualAssets, expectedAssets, "Preview mismatch with actual withdraw");
        assertEq(vault.balanceOf(address(this)), 0, "Incorrect share balance after withdraw");
    }

    function testFuzzAccounting(uint64 firstDeposit, uint64 secondDeposit) public {
        vm.assume(firstDeposit > 0);
        vm.assume(secondDeposit > 0);

        underlyingToken.mint(address(this), uint256(firstDeposit) + uint256(secondDeposit));
        underlyingToken.approve(address(vault), type(uint256).max);

        vault.deposit(firstDeposit, address(this));
        vault.deposit(secondDeposit, address(this));
        uint256 assetsEntered = uint256(firstDeposit) + uint256(secondDeposit);

        assertGe(vault.totalAssets(), vault.convertToAssets(vault.totalSupply()));
        assertEq(vault.totalAssets(), assetsEntered, "Assets are not conserved after deposits");

        uint256 sharesToRedeem = vault.totalSupply() / 2;
        uint256 assetsLeaving = vault.redeem(sharesToRedeem, address(this), address(this));

        assertGe(vault.totalAssets(), vault.convertToAssets(vault.totalSupply()));
        assertEq(
            vault.totalAssets(),
            assetsEntered - assetsLeaving,
            "Assets are not conserved after redemption"
        );
    }
}
