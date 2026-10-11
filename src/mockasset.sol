// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "../lib/solmate/src/tokens/ERC20.sol";

/// @notice Test-only WETH-like token with 18 decimals.
contract MockWETH is ERC20 {
	constructor() ERC20("Wrapped Ether", "WETH", 18) {}

	function mint(address to, uint256 amount) external {
		_mint(to, amount);
	}

	function burn(address from, uint256 amount) external {
		_burn(from, amount);
	}
}

/// @notice Test-only USDC-like token with 6 decimals.
contract MockUSDC is ERC20 {
	constructor() ERC20("USD Coin", "USDC", 6) {}

	function mint(address to, uint256 amount) external {
		_mint(to, amount);
	}

	function burn(address from, uint256 amount) external {
		_burn(from, amount);
	}
}

/// @notice Mutable price feed for tests, with 8-decimal Chainlink-style output.
contract MockOracle {
	uint8 public immutable decimals = 8;
	uint80 public roundId;
	uint256 public price;
	uint256 public updatedAt;

	constructor(uint256 initialPrice) {
		_setPrice(initialPrice);
	}

	function setPrice(uint256 newPrice) external {
		_setPrice(newPrice);
	}

	function getPrice() external view returns (uint256) {
		return price;
	}

	function latestAnswer() external view returns (int256) {
		return int256(price);
	}

	function latestRoundData()
		external
		view
		returns (uint80, int256, uint256, uint256, uint80)
	{
		return (roundId, int256(price), updatedAt, updatedAt, roundId);
	}

	function _setPrice(uint256 newPrice) internal {
		require(newPrice <= uint256(type(int256).max), "MockOracle: price overflow");
		price = newPrice;
		roundId++;
		updatedAt = block.timestamp;
	}
}
