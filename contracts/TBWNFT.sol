// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TBWNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("TaipeiBlockchainWeekNFT", "TBW") {
        for (uint256 i = 0; i < 3; i++) {
            safeMint(msg.sender);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmZkAbLYH2oX5ZP7XVVQnhHwUTJL9p4yjzXhZbnAZg3qEW/";
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}