from web3 import Web3, HTTPProvider, IPCProvider
from pprint import pprint

web3 = Web3(HTTPProvider("http://localhost:8545"))
acc1 = web3.eth.accounts[0]
amt = web3.toWei(0.0001, "ether")
# Excludes mine in classmates
classmates = ["0xe862c3e7513e7b651cfa991ae7db33eff7474f6b","0x9c3706ba0723272b67ee36ed7391213b2681c376","0x29d01e587bfd0d91d4ea6c4fd3fc6d30de62a38a","0x58234c4eb3022c3a3022f0616040011a2b666cda","0xf09505fe468aac607bf938510f69a78c7be828f4","0x724a41f20fa8952220b56ea05b48bff819f96a47","0xe08f3b7df58857f8598ec30e67c2e482a719cf9f","0x2d8aee9a894060d21a3d505e611316645a06a9bf","0xc89bd86ec3468485f52973eb6683606f8c3e8ae9","0x3839277acee809bf4306cb52f6d53496f18c4467","0x4853381d3e6986f26146040c5038e9340dba38f8","0x4fa435845daa22e0830119b3b49b5e2f93f80a41","0x2a9ea185439db3b31a7f786f5ee28a83fa9c89bc","0xcf64b4c584408c6e3af08414959301be2af4fc57","0x1108dd9ff24efadf5293a8f9bfe58222c56628a0","0x8640e3e678eebbcd02638704c5454a34273c9c7f","0x3050040d31e50a2b1892a032a2315bc4e98d3ce3","0xc23c42fda25228072645989e2fb2aac753a70b96","0xcdf7843b12a07c20d394c6e5a20e321ba20d3ba2","0xfaca2fa2d1202318ca53e9d25e87d7c8e84f08fa","0xeea474ca6209c90a286724463d506ddb3ea82772","0xe0e7c5430f8dec9e27fc285fd49818d8aa7a3308","0x99c28aed7012978a4721f99411ca45a6a691f30d"]
web3.personal.unlockAccount(acc1, "MY PASSPHRASE")

for student in classmates:
	web3.eth.sendTransaction(
		{
			"from": acc1,
			"to": student,
			"value": amt,
			"data": web3.toHex('El tomate, la papa, y el queso van a la playa.')
		}
	)

print("Done")