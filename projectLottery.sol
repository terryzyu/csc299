pragma solidity ^0.4.22;

contract projectLottery{
    
    
    //Some unnecessary variables, clean up later
    address public owner; //Contract owner
    //address[5] public played; //Array to store all players
    uint256 public winningNumber; //Winning number to be determined
    uint256 private fee;
    uint256 public pot; //Total amount in lottery
    uint private feePot;
    uint public numPlayed = 0; //Players so far
    uint256 endTime;
    uint256 startTime;

    constructor(uint256 _time, uint256 _fee) public{
        owner = msg.sender;
        fee = _fee;
        //startTime = getTime();
        endTime = getTime() + _time;
    }

   /* struct Player{
        address playerAddress;    
        bytes32 hash;
    }*/
    
    function showTimeLeft() public returns(uint256){
        return (endTime - startTime); //Doesn't seem to work at the moment
    }
    

    mapping(address => bytes32) public players;

    function play (bytes32 hash) external payable {
        require(msg.value == 2 ether,
            "Player must send exactly 2 ether"
        );

        require (
          players[msg.sender] == 0
        );

        players[msg.sender] = hash; //Similar to addPlayer()
        pot += msg.value-fee;
        feePot += fee;
    }
    
    function setWinningNumber (uint256 _winning_number) external {
        require(msg.sender == owner); //Only contract owner can set winning number
        winningNumber = _winning_number;
        
    }

    function reveal (uint256 r) external {
        
        bytes32 h = sha256 (winningNumber, r);
        //require (played[msg.sender] == h);
        
    }

    function done () external {
        
    }
    
    function getTime() returns(uint256){
        return now;
    }

    /*Functions that work but are not needed. Testing purposes


    function getOwner() public returns(address) {
        return owner;
    }


*/
}






