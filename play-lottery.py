import json
import hashlib
import sys
import random
from web3 import Web3, HTTPProvider, IPCProvider
from pprint import pprint

web3 = Web3 (HTTPProvider ("http://localhost:9545"))

with open ("abi.json") as f:
    abi = json.load (f)

contract_address = sys.argv[1]
account_index = int (sys.argv[2])
value = int (sys.argv[3]) #ether amount to send
chosenNumber = int(sys.argv[4])

account = web3.eth.accounts[account_index]
print ("Using account {:d} with address {:s} to play on contract {:s}".format (account_index, account, contract_address))
contract = web3.eth.contract (abi = abi, address = contract_address)

#Gets a random number and hashes it with the chosen number
randomNum = random.getrandbits(256)
data = int.to_bytes (chosenNumber, 32, "big") + int.to_bytes (randomNum, 32, "big")
hash_nr = hashlib.sha256 (data).hexdigest ()


transaction_hash = contract.transact ({
    "from": account,
    "value": web3.toWei (value, "ether")
}).play (Web3.toBytes (hexstr = hash_nr));

print ("transaction hash = {:s}".format (transaction_hash))
transaction_receipt = web3.eth.getTransactionReceipt (transaction_hash)
transaction = web3.eth.getTransaction (transaction_hash)
pprint (dict (transaction_receipt))

#Creates a file to store the player's address and their random number.
#Will create file if none exist, otherwise it'll append
#Used later in reveal. 
playerInfo = account + " " + str(randomNum) + "\n"
with open('playerInfo.txt', 'a') as file:
    file.write(playerInfo)