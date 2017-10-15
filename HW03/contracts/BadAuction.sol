pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back*/

	mapping(address => uint) refunds;
	function bid() payable external returns (bool) {
		// YOUR CODE HERE
		if (msg.value < highestBid){
			return false;
		}
		if (highestBid != 0) {
			if (!highestBidder.send(highestBid))
			return true;
		}

		highestBidder = msg.sender;
		highestBid = msg.value;
	}

	/* Give people their funds back */
	function () payable {

	}
}
