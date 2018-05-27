pragma solidity ^0.4.0;
contract Auction {
    uint256 public bestBid = 0;
    bool receivedBid = false;
    address bestBidder = 0;
    address public owner;
    constructor() public {
        owner = msg.sender; //msg.sender in constructor creates the owners address
    }
    
    function bid() public payable {
        
        if(receivedBid){
            require(msg.value > bestBid); //Beats current bid
            bestBidder.transfer(bestBid); //Transfers old bid to old bestBidder
        }
        
        receivedBid = true;
        bestBid = msg.value;
        bestBidder = msg.sender;
        
    }
    
    function end() public {
        require(msg.sender == owner);
        owner.transfer(bestBid);
        
    }
}