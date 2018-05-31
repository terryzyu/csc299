import json
import hashlib
import sys
from web3 import Web3, HTTPProvider, IPCProvider
from pprint import pprint

web3 = Web3 (HTTPProvider ("http://localhost:9545"))

with open ("abi.json") as f:
    abi = json.load (f)

contract_address = sys.argv[1]
account_index = int (sys.argv[2])
account = web3.eth.accounts[account_index]
print ("Using account {:d} with address {:s} to play on contract {:s}".format (account_index, account, contract_address))
contract = web3.eth.contract (abi = abi, address = contract_address)

playerInfo = {} #Dictionary to store player info stored in file. 
with open("playerInfo.txt") as file:
	for line in file:
		(key, val) = line.split()
		playerInfo[key] = int(val)

number = playerInfo[account]

transaction_hash = contract.call ({
}).reveal (number);

print ("transaction hash = {:s}".format (transaction_hash))
transaction_receipt = web3.eth.getTransactionReceipt (transaction_hash)
transaction = web3.eth.getTransaction (transaction_hash)
pprint (dict (transaction_receipt))