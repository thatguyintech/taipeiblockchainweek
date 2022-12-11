// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TBWCoin is ERC20, Ownable {
    address public bank;

    constructor() ERC20("TaipeiBlockchainWeekCoin", "TBW20") {
        // pre-mint one million coins to the deployer address
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
        bank = msg.sender;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
