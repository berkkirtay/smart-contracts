from brownie import CryptoStaking
from scripts.getAccountCredential import getAccount
import time
from web3 import Web3

def stakeETH():
    currentAccount = getAccount(0)
    contract = CryptoStaking.deploy({"from": currentAccount})
    contract.deposit({"from": currentAccount, "value": 10**18})
    print(f'Current balance: {contract.getBalance(currentAccount)/10**18} ETH')

    tx1 = contract.stake(10, 10**18 / 2)
    print(tx1)

    print(f'Current balance: {contract.getBalance(currentAccount)/10**18} ETH')
    time.sleep(10)
    contract.checkStakeStatus()
    contract.withdraw(10**18)

    print(f'Current balance: {contract.getBalance(currentAccount)/10**18} ETH')

def main():
    stakeETH()
