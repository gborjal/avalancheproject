// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20Burnable, Ownable {
    event TransferredToken(address indexed sender,address indexed reciever, uint256 amount);
    event RedeemedToken(address indexed sender, uint256 itemCode, uint256 amount);
    event BurnedToken(address indexed sender, uint256 amount);
    constructor (uint256 initialSupply) ERC20("Degen","DGN") Ownable(_msgSender()){
        _mint(msg.sender,initialSupply);
    }
    function decimals() override public pure returns (uint8){
        return 0;
    }
    modifier enoughToken(uint256 _value){
        require(balanceOf(_msgSender()) >= _value,"Insuficient DegenToken");
        _;
    }
    function mint(address dest, uint256 amount) onlyOwner public {
        _mint(dest, amount);
    }
    function myBalance()public view returns(uint256){
        return this.balanceOf(_msgSender());
    }
    function transferToken(address reciever, uint256 amount) enoughToken(amount) public returns (bool) {
        approve(_msgSender(),amount);
        transferFrom(_msgSender(), reciever, amount);
        emit TransferredToken(_msgSender(), reciever, amount);
        return true;
    }
    function shop() public pure returns (string memory){
        return "=========ShopItems============(101,100DGN) NFT small pack========(201,400DGN) NFT Medium pack=====(301,800DGN) NFT Large pack";
    }
    function redeemToken(uint256 itemCode)external{
        uint256 tokenPrice;

        tokenPrice = 0;
        if (itemCode == 101) {          //NFT small pack
            tokenPrice = 100;
        } else if (itemCode == 201) {   //NFT medium pack
            tokenPrice = 400;
        } else if (itemCode == 301) {   //NFT big pack
            tokenPrice = 800;
        } else {
            revert("Invalid redeem type");
        }

        if(balanceOf(_msgSender()) < tokenPrice){
            revert("Insuficient balance.");
        }
        burn(tokenPrice);
        emit RedeemedToken(_msgSender(), itemCode, tokenPrice);
    }
    function burnToken(uint256 amount) enoughToken(amount) public{
        burn(amount);
        emit BurnedToken(_msgSender(),amount);
    }
    receive() external payable {
        revert("Contract does not accept Ether");
    }
}