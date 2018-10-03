from datetime import datetime
from web3 import Web3, HTTPProvider, IPCProvider
web3 = Web3(HTTPProvider("http://localhost:8545"))

# Loops over blocks
for num in range(100000, 100021):
	b = web3.eth.getBlock(num)  # Gets block data
	# Prints block number and readable timestamp
	print("block {} timestamp {}".format(num, datetime.fromtimestamp (b.timestamp).strftime ('%Y-%m-%d %H:%M:%S')))
	