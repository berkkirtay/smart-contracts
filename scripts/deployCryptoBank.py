from brownie import CryptoBank
from scripts.getAccountCredential import getAccount
from datetime import datetime

class Contract:
    def __init__(self):
        self.currentAccount = getAccount(0)
        self.cryptoBank = CryptoBank.deploy({"from": self.currentAccount})

    def setCurrentUser(self, user):
        self.currentAccount = user

    def deposit(self, amount: int):
        self.cryptoBank.depositWithETH({
            "from": self.currentAccount,
            "value": amount
        })

    def withdraw(self):
        return self.cryptoBank.withdraw({"from": self.currentAccount})

    def getBalance(self, publicAddress: str) -> int:
        return self.cryptoBank.getBalance(publicAddress)

    def sendTokens(self, receiver: str, amount: int):
        transaction = self.cryptoBank.send(receiver, amount)
        transaction.wait(1)


# Test of sending ETH between peers by using a crypto bank.

contract = Contract()

def depositToBankWithAcount1():
    user1 = getAccount(1)
    contract.setCurrentUser(getAccount(0))

    contract.deposit(5000000000000000000)  # 5 ETH
    contract.sendTokens(user1, 5000000000000000000)

    print(f"user1's balance: {contract.getBalance(user1)} at {datetime.now()}")
    print(
        f"your balance: {contract.getBalance(contract.currentAccount)} at {datetime.now()}")

def withdrawFromBankWithAccount2():
    contract.setCurrentUser(getAccount(1))
    contract.withdraw()
    print("User1 withdrawed his funds from his bank account.")

def main():
    depositToBankWithAcount1()
    withdrawFromBankWithAccount2()
