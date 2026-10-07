//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MockERC20} from ".././erc4626vault.t.sol";
import {ERC4626Vault} from "../../src/erc4626vault.sol";

contract Handler {
    ERC4626Vault public vault;
    MockERC20 public underlyingToken;

    constructor(ERC4626Vault _vault, MockERC20 _underlyingToken) {
        vault = _vault;
        underlyingToken = _underlyingToken;
    }

    function deposit(uint256 assets) external {
        underlyingToken.mint(address(this), assets);
        underlyingToken.approve(address(vault), assets);
        vault.deposit(assets, address(this));
    }

    function redeem(uint256 shares) external {
        vault.redeem(shares, address(this), address(this));
    }
}
