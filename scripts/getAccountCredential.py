from brownie import accounts
import os 

def getAccount(walletIndex: int):
    returnName = ''
    if walletIndex == 0:
        returnName = "PRIVATE_KEY_LOCAL1"
    else:
        returnName = "PRIVATE_KEY_LOCAL2"
    return accounts.add(os.getenv(returnName))