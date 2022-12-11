// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "hardhat/console.sol";


/**
 * @title NFT Staking with Infinite Rewards
 * @author Breakthrough Labs Inc.
 * @notice Staking, NFT, ERC721
 * @custom:version 1.0.0
 * @custom:address 51
 * @custom:default-precision 0
 * @custom:simple-description NFT staking contract that rewards stakers with an exact number of ERC20 tokens per minute.
 * @dev NFT staking contract that rewards stakers with an exact number of ERC20 tokens per minute. On deployment, the owner specifies a minute-by-minute reward rate,
 * and an address that tokens will be pulled from. Neither of these can be changed. Each staked NFT receives the same number of tokens every minute. The per NFT
 * rate stays the same even when the number of staked NFTs increases/decreases.
 *
 * A common usecase is for blockchain-based games, where each NFT rewards a certain number of lives per minute.
 *
 */
contract TBWStaker is Context, IERC721Receiver {
    IERC721 public nft;
    IERC20 public rewardToken;
    address public rewardWallet;
    /// @custom:precision 18
    uint256 public rewardPerTokenPerMinute;

    mapping(uint256 => address) private stakedTokens;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) private reward;

    /**
     * @param nftAddress  Staked NFT Address
     * @param rewardTokenAddress Reward Token Address
     * @param rewardWalletAddress Wallet that holds rewards to be paid out
     * @param rewardRate # of tokens per staked NFT per minute | precision:18
     */
    constructor(
        address nftAddress,
        address rewardTokenAddress,
        address rewardWalletAddress,
        uint256 rewardRate
    ) {
        nft = IERC721(nftAddress);
        rewardToken = IERC20(rewardTokenAddress);
        rewardWallet = rewardWalletAddress;
        rewardPerTokenPerMinute = rewardRate;
    }

    modifier update(address account) {
        reward[account] = available(account);
        lastUpdateTime[account] = block.timestamp;
        _;
    }

    /**
     * @dev returns the number of reward tokens available for an address
     * @param account account
     */
    function available(address account) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - lastUpdateTime[account];
        uint256 earned = (balanceOf[account] *
            timeElapsed *
            rewardPerTokenPerMinute) / 10;
        return reward[account] + earned;
    }

    /**
     * @dev stakes a specific tokenID
     * @param tokenId tokenId
     */
    function stake(uint256 tokenId) external {
        console.log("message sender from openzeppelin context", _msgSender());
        nft.safeTransferFrom(_msgSender(), address(this), tokenId);
    }

    /**
     * @dev withdraws a token from the staking contract
     * @param tokenId tokenId
     */
    function withdraw(uint256 tokenId) external update(_msgSender()) {
        require(stakedTokens[tokenId] == _msgSender(), "Token is not staked.");
        delete stakedTokens[tokenId];
        balanceOf[_msgSender()]--;
        nft.transferFrom(address(this), _msgSender(), tokenId);
    }

    /**
     * @dev redeems all of a user's reward tokens.
     */
    function redeem() external update(_msgSender()) {
        uint256 amount = reward[_msgSender()];
        require(amount > 0, "Nothing to redeem");
        reward[_msgSender()] = 0;
        rewardToken.transferFrom(rewardWallet, _msgSender(), amount);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata
    ) external update(from) returns (bytes4) {
        stakedTokens[tokenId] = from;
        balanceOf[from]++;
        return IERC721Receiver.onERC721Received.selector;
    }
}

