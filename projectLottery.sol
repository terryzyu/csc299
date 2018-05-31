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
    bytes32 winningHash;

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
        return (endTime - getTime()); //Doesn't seem to work at the moment
        //okay it works now :^)
    }
    

    mapping(address => bytes32) public players;
    mapping(address => bytes32) public winners;

    function play (bytes32 hash) external payable {
        require(msg.value == 5 ether,
            "Player must send exactly 5 ether"
        );

        require (
          players[msg.sender] == 0 //Cannot play twice
        );

        players[msg.sender] = hash; //Similar to addPlayer()
        pot += msg.value-fee; //Pays fee to contract owner
        feePot += fee; //Adds remaining value to pot
        numPlayed++;
    }
    
    function setWinningNumber (uint256 _winning_number) external {
        require(getTime() >= endTime, "End time hasn't been passed"); //Can only be called after ending
        require(msg.sender == owner); //Only contract owner can set winning number
        winningNumber = _winning_number;
        winningHash = sha256(_winning_number);
        
    }

    function reveal (uint256 r) external returns(bytes32){
        require(getTime() >= endTime); //Can only be called after ending
        bytes32 h = sha256 (r);//Calculates sha256 of number sent in by player
        return h;
       /* require (players[msg.sender] == h);
        if(h == winningHash){
            winners[msg.sender] = h;
        }*/
        
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






