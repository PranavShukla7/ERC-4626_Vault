//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4626Vault} from "../../src/erc4626vault.sol";
import {MockWETH} from "../../src/mockasset.sol";

contract Handler {
    ERC4626Vault public vault;
    MockWETH public underlyingToken;

    constructor(ERC4626Vault _vault, MockWETH _underlyingToken) {
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
