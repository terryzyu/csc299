from web3 import Web3, HTTPProvider, IPCProvider
from pprint import pprint

web3 = Web3(HTTPProvider("http://localhost:8545"))
max = 0  # Stores maximum in wei

# Loops through each block
for num in range(100000, 200001):
	#Uncomment following to print block number to see progress
	#print("Block Num: {}".format(num))

	b = web3.eth.getBlock(num) # Gets data on block number

	# Loops over transactions in block
	for txhash in b.transactions:
		amt = web3.eth.getTransaction(txhash).value  # Gets amount transferred
		if(amt > max): # Determines new max and stores it
			max = amt

# Prints max in ether unit
print("Max: {} ETH".format(float(web3.fromWei(max, "ether"))))