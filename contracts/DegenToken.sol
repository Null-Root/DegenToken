// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    struct StoreItem {
        uint requiredTokens;
        string itemName;
        bool isRedeemed;
    }

    StoreItem[] private storeItems;

    constructor()
    ERC20("Degen", "DGN")
    Ownable()
    {
        storeItems.push(StoreItem(55, "League of Legends - Shaco NFT", false));
        storeItems.push(StoreItem(12, "Apple NFT", false));
        storeItems.push(StoreItem(18, "Toy Story Merch", false));
        storeItems.push(StoreItem(26, "Arm NFT", false));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); 
    }

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Current DGN tokens are not enough to cover the transfer!");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Current DGN tokens are not enough to cover burn of the requested amount!");
        burn(_value);
    }

    function redeemTokens(uint8 input) external payable returns (string memory) {
        require(input >= 0 || input <= 3, "Invalid Input");
        require(storeItems[input].isRedeemed == false, "This item is already redeemed!");
        require(balanceOf(msg.sender) >= storeItems[input].requiredTokens, "Current DGN tokens are not enough to cover the redeem!");

        approve(msg.sender, storeItems[input].requiredTokens);
        transferFrom(msg.sender, owner(), storeItems[input].requiredTokens);
        storeItems[input].isRedeemed = true;

        return string.concat(storeItems[input].itemName ," has been redeemed!");
    }

    function showStoreItems() public view returns (string memory) {
        string memory itemPrintStr = "";

        for (uint i = 0; i < 4; i++) {
            itemPrintStr = string.concat(itemPrintStr, "   ", Strings.toString(i), ". ", storeItems[i].itemName);
        }

        return itemPrintStr;
    }
}