pragma solidity ^0.4.15;

contract BettingContract {
	/* Standard state variables */
	address owner;
	address public gamblerA;
	address public gamblerB;
	address public oracle;
	uint[] outcomes;
	uint8 public numPlayers;
	uint true_outcome;

	/* Structs are custom data structures with self-defined parameters */
	struct Bet {
		uint outcome;
		uint amount;
		bool initialized;
	}

	/* Keep track of every gambler's bet */
	mapping (address => Bet) bets;
	/* Keep track of every player's winnings (if any) */
	mapping (address => uint) winnings;

	/* Add any events you think are necessary */
	event BetMade(address gambler);
	event BetClosed();

	/* Uh Oh, what are these? */
	modifier OwnerOnly(address owner) {if (msg.sender == owner) {_;}}
	modifier OracleOnly(address oracle) {if (msg.sender == oracle) {_;}}
	modifier GamblerOnly(address Gambler) {if (msg.sender != owner && msg.sender != oracle) {_;}}
	/* Constructor function, where owner and outcomes are set */
	function BettingContract(uint[] _outcomes) {
        outcomes = _outcomes;
	    owner = msg.sender;
	}

	/* Owner chooses their trusted Oracle */
	function chooseOracle(address _oracle) OwnerOnly() returns (address) {
	    oracle = _oracle;
        return oracle;
	}

	/* Gamblers place their bets, preferably after calling checkOutcomes */
	function makeBet(uint _outcome) payable returns (bool) {
	    if (numPlayers < 2){
	        Bet memory myBet = Bet(_outcome, msg.value, true);
	        bets[msg.sender] = myBet;
	        numPlayers += 1;
	        if (numPlayers < 1){
	            gamblerA = msg.sender;
	        } else{
	            GamblerB = msg.sender;
	        }
	        BetMade(msg.sender);
	        return true;
	    }   else{
	        return false;
	    }
	    }
	    /*
	}

	/* The oracle chooses which outcome wins */
	function makeDecision(uint _outcome) OracleOnly() {

	}

	/* Allow anyone to withdraw their winnings safely (if they have enough) */
	function withdraw(uint withdrawAmount) returns (uint remainingBal) {
	    if (withdrawAmount > remainingBal){
	        winnings[msg.sender] -= remainingBal;
	        msg.sender.transfer(winnings[msg.sendeer]);
	    }
	    return winnings[msg.sender];
	}

	/* Allow anyone to check the outcomes they can bet on */
	function checkOutcomes() constant returns (uint[]) {
	    return outcomes;
	}

	/* Allow anyone to check if they won any bets */
	function checkWinnings() constant returns(uint) {
	    return winnings[msg.sender];
	}

	/* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
	function contractReset() private {
	}

	/* Fallback function */
	function() {
		revert();
	}
}
