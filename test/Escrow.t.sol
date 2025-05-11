// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

 import "forge-std/Test.sol";  

import "../src/Escrow.sol";   // Import the Escrow contract to be tested

//Inherits Test, giving access to assertions and cheatcodes
contract EscrowTest is Test {

    //state variables goes here
    Escrow public escrow;
    address buyer = address(0xBEEF);
    address seller = address(0xCAFE);
    uint256 amount = 1 ether;

    //This function runs before every test to set initial balances for test isolation
    function setUp() public {
        vm.deal(buyer, 2 ether);
        vm.deal(seller, 0 ether);
    }


   //Function to test if buyer can successfully release funds to the seller
    function testBuyerCanReleaseFunds() public {
        vm.prank(buyer);
        escrow = new Escrow{value: amount}(seller);

        vm.prank(buyer);
        escrow.release();

        assertEq(seller.balance, amount);
    }

   //Fuction to test if seller can successfully refund escrowed funds to the buyer
    function testSellerCanRefund() public {
        vm.prank(buyer);
        escrow = new Escrow{value: amount}(seller);

        vm.prank(seller);
        escrow.refund();

        assertEq(buyer.balance, 1 ether);
    }
    
    //Tests if Only the buyer can call release()
    function testOnlyBuyerCanRelease() public {
        vm.prank(buyer);
        escrow = new Escrow{value: amount}(seller);

        vm.expectRevert("Only buyer can release");
        vm.prank(seller);
        escrow.release();
    }

   //Tests if Only the seller can call refund()
    function testOnlySellerCanRefund() public {
        vm.prank(buyer);
        escrow = new Escrow{value: amount}(seller);

        vm.expectRevert("Only seller can refund");
        vm.prank(buyer);
        escrow.refund();
    }

       //  Fuzz test for release()
    function testFuzzRelease(uint256 _amount) public {
        _amount = bound(_amount, 1 wei, 10 ether);
        vm.deal(buyer, _amount);

        vm.prank(buyer);
        escrow = new Escrow{value: _amount}(seller);

        vm.prank(buyer);
        escrow.release();

        assertEq(seller.balance, _amount);
    }

    //Fuzz test for refund()
    function testFuzzRefund(uint256 _amount) public {~
        _amount = bound(_amount, 1 wei, 10 ether);
        vm.deal(buyer, _amount);

        vm.prank(buyer);
        escrow = new Escrow{value: _amount}(seller);

        vm.prank(seller);
        escrow.refund();

        assertEq(buyer.balance, _amount);
    }
}
