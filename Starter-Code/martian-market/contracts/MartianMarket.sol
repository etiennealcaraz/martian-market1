pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './MartianAuction.sol';

contract MartianMarket is ERC721, Ownable {

    constructor() ERC721("MartianMarket", "MARS") public {}

    address payable foundationAddress = address(uint160(owner()));

    mapping(uint => MartianAuction) public auctions;

    function registerLand(string memory uri) public payable onlyOwner {
        uint _id = totalSupply();
        _mint(msg.sender, _id);
        _setTokenURI(_id, tokenURI);
        createAuction(_id);
    }

    function createAuction(uint tokenId) public onlyOwner {
        auctions[tokenId] = new MartianAuction(foundation_address);
    }

    function endAuction(uint tokenId) public onlyOwner landRegistered(tokenId) {
        MartianAuction auction = auctions[tokenId];
        auction.auctionEnd();
        safeTransferFrom(owner(), auction.highestBidder(), tokenId);
    }

    function auctionEnded(uint tokenId) public view returns(bool) {
        MartianAuction auction = auctions[tokenId];
        return auction.ended();
    }

    function highestBid(uint tokenId) public view landRegistered(tokenId) returns(uint) {
        MartianAuction auction = auctions[tokenId];
        return auction.highestBid();
    }

    function pendingReturn(uint tokenId, address sender) public view landRegistered(tokenId) returns(uint) {
        MartianAuction auction = auctions[tokenId];
        return auction.pendingReturn(sender);
    }

    function bid(uint tokenId) public payable landRegistered(tokenId) {
        MartianAuction auction = auctions[tokenId];
        auction.bid.value(msg.value)(msg.sender);
    }

}
