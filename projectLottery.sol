pragma solidity ^0.4.22;

contract projectLottery{
    
    address public owner;
    //address players
    uint256 public winning_number;
    uint256 public pot;
    
    
    constructor() public{
    	owner = msg.sender;
    }

    function play (bytes32 h) external payable {
        
    }

    function winning (uint256 _winning_number) external {
        
        winning_number = _winning_number;
        
    }

    function reveal (uint256 r) external {
        
        bytes32 h = sha256 (winning_number, r);
        require (played[msg.sender] == h);
        
    }

    function done () external {
        
    }
}