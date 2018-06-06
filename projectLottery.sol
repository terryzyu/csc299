pragma solidity ^0.4.2;

contract projectLottery{
    /**
     * Purpose: Create a blind lottery where a player sends in a hash of their chosen number mixed with a random number
     * When the contract is created the owner sets the following:
     * A play time in seconds, a ticket cost in wei, and the fee in wei that will be deducted from ticket cost for running the contract
     *
     * Players will then be able to play the contract using 'play-lottery.py'. 
     * Usage: python3 play-lottery.py <contract address> <account index> <fee to pay> <chosen number>
     * A random number is chosen using getrandbits(256) that is stored in a text file along with the address.
     *
     * When the play time has passed the owner can set a winning number and the reveal time is set.
     * The reveal time is equal to play time, this is when players send in their random number to be hashed
     * Reveal time's purpose is so the owner cannot immediately call done() without giving players a fair chance to reveal their numbers
     * Players can reveal using 'reveal-lottery.py'
     * Usage: python3 reveal-lottery.py <contract address> <account index>
     *
     * The owner can call done() when all have revealed or reveal time has passed
     * done() will split the winnings if necessary and distribute them to winners. Fee pot will be sent to owner
     * If there are no winners then players are refunded minus the fee.
     * Contract will self destruct after done() is called
     * 
     */
    
    address public owner;               //Contract owner
    uint256 public winningNumber;       //Winning number to be determined
    bool public hasSetWinningNumber;    //Boolean to ensure reveal cannot be called 
    uint256 private fee;                //Fee to pay to play lottery
    uint256 private feePot;             //Stores amount to be payed to owner
    uint256 public pot;                 //Total amount in lottery
    uint256 public endTime;             //Amount of time to play
    uint256 public revealTime;          //Deadline to reveal number
    uint256 public time;                //Stores time set from constructor
    uint256 public numPlayed = 0;       //Players so far
    uint256 public numWinners = 0;      //Number of winners
    uint256 public ticketCost;          //Cost to play lottery

    constructor(uint256 _time, uint256 _ticketCost, uint256 _fee) public{
        require(_fee < _ticketCost);
        owner = msg.sender;
        time = _time;
        ticketCost = _ticketCost;
        fee = _fee;
        endTime = now + _time;
        hasSetWinningNumber = false;
    } //constructor()

    mapping(address => bytes32) public players;     //Stores valid players and their addresses
    mapping(uint256 => address) public playerLookUp; // Stores valid players as a look up table
    mapping(uint256 => address) public winners;     //Stores valid winners 

    function play (bytes32 hash) external payable {
        require( //Must send correct wei
            msg.value == ticketCost,
            "Player must send the correct wei exactly."
        );

        require ( //Cannot play twice
          players[msg.sender] == 0
        );
        
        require( //Cannot play after play time has passed
            now <= endTime,
            "End time has been passed"
        );

        players[msg.sender] = hash;          //Similar to addPlayer()
        playerLookUp[numPlayed] = msg.sender;//Gets added to table
        pot += msg.value-fee;                //Pays fee to contract owner
        feePot += fee;                       //Adds remaining value to pot
        numPlayed++;                         //Number of players increments

    } //play()
    
    function setWinningNumber (uint256 _winning_number) external {
        require( //Can only be called after ending
            now >= endTime,
            "End time has not passed"
        );

        //Only contract owner can set winning number
        require(msg.sender == owner); 

        winningNumber = _winning_number; //Sets winning number
        hasSetWinningNumber = true;      //Flag to use in reveal()
        revealTime = now + time;         //The amount of reveal time is equivalent to the play time
        
    } //setWinningNumber()

    function reveal (uint256 r) external{
        require(
             now <= revealTime,
            "Reveal time has passed"
        );
        
        //Winning number must've already been set
        assert(hasSetWinningNumber); 

        //Calculates hash of number sent in by player packed with winning number
        bytes32 h = sha256(abi.encodePacked (winningNumber, r));
        
        //Gets added to winners map if confirmed winner
        if(players[msg.sender] == h){
            winners[numWinners] = msg.sender;
            numWinners++;
        }

    } //reveal()

    function done () external {
        require(now >= revealTime);
        require(msg.sender == owner);

        if(numWinners < 0){ //Refunds
            for(uint y = 0; y < numPlayed; y++)
                playerLookUp[y].transfer(pot/numPlayed);
                
        }
        else{//A winner exists
            for(uint x = 0; x < numWinners; x++)
                winners[x].transfer(pot/numWinners);
        }

        owner.transfer(feePot);
        selfdestruct(owner); //If there's any remaining money. 
        
    } //done()
    
    
    function getTime() public view returns(uint256){
        return now;
    }
    

} //projectLottery.sol