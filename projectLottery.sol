pragma solidity ^0.4.2;

contract projectLottery{
    
    
    //Some unnecessary variables, clean up later
    address public owner; //Contract owner
    //address[5] public played; //Array to store all players
    uint256 public winningNumber; //Winning number to be determined
    bool public hasSetWinningNumber;
    uint256 private fee;
    uint256 public pot; //Total amount in lottery
    uint private feePot;
    uint public numPlayed = 0; //Players so far
    uint endTime;
    uint256 startTime;
    bytes32 winningHash;

    constructor(uint _time, uint256 _fee) public{
        owner = msg.sender;
        fee = _fee;
        //startTime = getTime();
        endTime = now + _time;
        hasSetWinningNumber = false;
    }

   /* struct Player{
        address playerAddress;    
        bytes32 hash;
    }*/
    
    
    

    mapping(address => bytes32) public players;
    mapping(address => bytes32) public winners;

    function play (bytes32 hash) external payable {
        require(msg.value == 5 ether,
            "Player must send exactly 5 ether"
        );

        require (
          players[msg.sender] == 0 //Cannot play twice
        );
        
        require(now <= endTime, "End time has been passed");
        
        

        players[msg.sender] = hash; //Similar to addPlayer()
        pot += msg.value-fee; //Pays fee to contract owner
        feePot += fee; //Adds remaining value to pot
        numPlayed++;
    }
    
    function setWinningNumber (uint256 _winning_number) external {
        require(now >= endTime, "End time has not passed"); //Can only be called after ending
        require(msg.sender == owner); //Only contract owner can set winning number
        winningNumber = _winning_number;
        hasSetWinningNumber = true;
        winningHash = sha256(_winning_number);
        
    }

    function reveal (uint256 r) external{
        //PLAYERS CAN ONLY REVEAL ONCE
        require(now >= endTime, "Time has not passed"); //Can only be called after ending
        require(hasSetWinningNumber == true); //Winning number must've already been set
        
        bytes32 h = sha256(abi.encodePacked (winningNumber, r));//Calculates sha256 of number sent in by player
        //require (players[msg.sender] == h);
        
        //Gets added to mapping if a winner is confirmed
        if(players[msg.sender] == h){
            winners[msg.sender] = h;
        }
        
        
        delete players[msg.sender]; //Removes player from mapping
        numPlayed--;
    }

    function done () external {
        require(numPlayed == 0);
    }
    
    
    //All it returns is the current unix time
    //I can literally just use "now" instead of this
    function getTime() public returns(uint256){
        return now;
    }
    
    function showEndTime() public returns(uint256){
        return (endTime); //Doesn't seem to work at the moment
        //okay it works now :^)
        //doesn't work anymore :^(
    }

    /*Functions that work but are not needed. Testing purposes


    function getOwner() public returns(address) {
        return owner;
    }


*/
}






