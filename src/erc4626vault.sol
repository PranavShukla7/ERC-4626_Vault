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
}
