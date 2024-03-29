// SPDX-License-Identifier: MIT
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

pragma solidity ^0.8.7;

contract FlipContract is Ownable {
    
    using SafeMath for uint256;

    uint public ContractBalance;

    event bet(address indexed user, uint indexed bet, bool indexed win, uint8 side);
    event funded(address owner, uint funding);

    // flip 50/50
    function flip(uint8 side) public payable returns(bool){
        require(address(this).balance >= msg.value.mul(2), "The contract hasnt enought funds");
        require(side == 0 || side == 1, "Incorrect side, needs to be 0 or 1");
        bool win;
        if(block.timestamp % 2 == side){
            ContractBalance -= msg.value;
            payable(msg.sender).transfer(msg.value * 2);
            win = true;
        }
        else{
            ContractBalance += msg.value;
            win = false;
        }
        emit bet(msg.sender, msg.value, win, side);
    }
    // withdraw funds
    function withdrawAll() public onlyOwner returns(uint){
        payable(msg.sender).transfer(address(this).balance);
        assert(address(this).balance == 0);
        return address(this).balance;
    }
    // get the balance of the contract
    function getBalance() public view returns (uint) {
        return ContractBalance;
    }
    // fund the contract
    function fundContract() public payable onlyOwner {
        require(msg.value != 0);
        ContractBalance = ContractBalance.add(msg.value);
        emit funded(msg.sender, msg.value);
        assert(ContractBalance == address(this).balance);
    }

}