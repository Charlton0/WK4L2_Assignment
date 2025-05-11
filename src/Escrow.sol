// SPDX-License-Identifier: MIT

/*  A simple smart contract for an escrow system 
to manage financial transactions between a buyer and a seller */
pragma solidity ^0.8.20;

contract Escrow {
    address public buyer;
    address public seller;
    uint256 public amount;
    bool public isReleased;

    constructor(address _seller) payable {
        require(msg.value > 0, "No funds sent");
        buyer = msg.sender;
        seller = _seller;
        amount = msg.value;
        isReleased = false;
    }

   //function to release funds to the seller once the buyer is satisfied with product on sale
   // it is restricted to the only buyer
    function release() public {
        require(msg.sender == buyer, "Only buyer can release");
        require(!isReleased, "Already released");

        isReleased = true;
        payable(seller).transfer(amount);
    }

  //function to initiate refund to the buyer if the seller decides to cancel the trade
  //this function is restricted to only the seller
    function refund() public {
        require(msg.sender == seller, "Only seller can refund");
        require(!isReleased, "Already released");

        isReleased = true;
        payable(buyer).transfer(amount);
    }
}
