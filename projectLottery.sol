pragma solidity ^0.4.22;

contract projectLottery{
    
    address public owner; //Contract owner
    address[5] public played; //Array to store all players
    uint256 public winningNumber; //Winning number to be determined
    uint256 public pot; //Total amount in lottery
    uint public numPlayed = 0; //Players so far

    constructor() public{
        owner = msg.sender;
    }

    struct Player{
        address playerAddress;    
        bytes32 hash;
    }

    mapping(address => Player) players;
    address[] public playersList;

    function play (bytes32 hash) external payable {
        require(msg.value == 2 ether,
            "Player must send exactly 2 ether"
        );

        require (
          numPlayed < played.length,
          "Maximum number of players reached already"
        );

        pot += msg.value;
        addPlayer (msg.sender, hash);
    }

    function addPlayer(address _playerAddress, bytes32 _hash) private{
        var player = playersList[_playerAddress];

        player.playerAddress = _playerAddress;
        player.hash = _hash;

        playersList.push(_playerAddress);
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

    /*Functions that work but are not needed. Testing purposes


    function getOwner() public returns(address) {
        return owner;
    }


*/
}






