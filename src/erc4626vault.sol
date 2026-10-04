// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "../lib/solmate/src/tokens/ERC20.sol";
import {ERC4626} from "../lib/solmate/src/tokens/ERC4626.sol";

/// @notice Bare-bones ERC-4626 vault for a single ERC-20 asset.
contract ERC4626Vault is ERC4626 {
    constructor(ERC20 asset_, string memory name_, string memory symbol_) ERC4626(asset_, name_, symbol_) {}

    function totalAssets() public view override returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public override returns (uint256) {
        return super.mint(shares, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner) public override returns (uint256) {
        return super.redeem(shares, receiver, owner);
    }

    function convertToShares(uint256 assets) public view override returns (uint256) {
        return super.convertToShares(assets);
    }

    function convertToAssets(uint256 shares) public view override returns (uint256) {
        return super.convertToAssets(shares);
    }

    function previewDeposit(uint256 assets) public view override returns (uint256) {
        return super.previewDeposit(assets);
    }

    function previewMint(uint256 shares) public view override returns (uint256) {
        return super.previewMint(shares);
    }

    function previewWithdraw(uint256 assets) public view override returns (uint256) {
        return super.previewWithdraw(assets);
    }

    function previewRedeem(uint256 shares) public view override returns (uint256) {
        return super.previewRedeem(shares);
    }

    function maxDeposit(address receiver) public view override returns (uint256) {
        return super.maxDeposit(receiver);
    }

    function maxMint(address receiver) public view override returns (uint256) {
        return super.maxMint(receiver);
    }

    function maxWithdraw(address owner) public view override returns (uint256) {
        return super.maxWithdraw(owner);
    }

    function maxRedeem(address owner) public view override returns (uint256) {
        return super.maxRedeem(owner);
    }
}
