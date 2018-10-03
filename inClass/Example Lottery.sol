pragma solidity ^0.4.22;

contract Lottery {
  address public owner;
  address[4] public played;
  uint public num_played = 0;

  event Played (address player);
  event Won (address player);

  constructor () public {
    owner = msg.sender;
    add_player (msg.sender);
  }

  function play () external payable {
    require (
      msg.value == 100 finney,
      "Must send exactly 100 finney"
    );
    require (
      num_played < played.length,
      "Maximum number of players reached already"
    );
    add_player (msg.sender);
  }

  function add_player (address player) private {
    for (uint i = 0; i < num_played; i++) {
      require (
        player != played[i],
        "A player cannot play twice"
      );
    }
    assert (played[num_played] == 0);
    played[num_played] = player;
    num_played = num_played + 1;
    emit Played (player);
    if (num_played == played.length) {
      finish ();
    }
  }

  function finish () private {
    assert (num_played == played.length);
    uint winner_index = (uint (keccak256 (abi.encodePacked (block.timestamp)))) % played.length;
    address winner = played[winner_index];
    emit Won (winner);
    // winner.transfer (this.balance);
    selfdestruct (winner);
  }
}