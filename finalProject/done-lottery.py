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

account = web3.eth.accounts[account_index]
print ("Using account {:d} with address {:s} to play on contract {:s}".format (account_index, account, contract_address))
contract = web3.eth.contract (abi = abi, address = contract_address)

transaction_hash = contract.transact ({
    "from": account
}).done ();

print ("transaction hash = {:s}".format (transaction_hash))
transaction_receipt = web3.eth.getTransactionReceipt (transaction_hash)
transaction = web3.eth.getTransaction (transaction_hash)
pprint (dict (transaction_receipt))