pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SuperPuperTokenByIldar is ERC20, Ownable {

    bool isActice = true;
    uint hardcap = 10000;
    
    constructor() ERC20("Token by Ildar", "IIII") {}
    
    
    function closeICO() public onlyOwner {
        require(isActice, "ICO has closed");
        isActice = false;
    }

    function getEth() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    function buy() public payable {
        require(isActice, "ICO has closed");
        require(msg.value > 0, "You need to send some ether");

        uint desiredQuantityForPurchase = msg.value / 1000000000000000000; //курс 1 к 1

        require(desiredQuantityForPurchase <= (hardcap - totalSupply()), "There is no necessary quantity");
        _mint(msg.sender, desiredQuantityForPurchase);
    }

}
