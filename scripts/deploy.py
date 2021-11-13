from brownie import accounts, CryptoBank, network
import os
from datetime import datetime


def getAccount():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(os.getenv("PRIVATE_KEY"))


class Contract:
    def __init__(self):
        self.account = getAccount()
        self.cryptoBank = CryptoBank.deploy({"from": self.account})

    def deposit(self, amount: int):
        self.cryptoBank.deposit(amount)

    def depositAsETH(self, amount: int):
        pass

    def withdraw(self):
        return self.cryptoBank.withdraw()

    def withdrawAsEth(self):
        pass

    def getBalance(self, publicAddress: str) -> int:
        return self.cryptoBank.getBalance(publicAddress)

    def sendTokens(self, receiver: str, amount: int):
        transaction = self.cryptoBank.send(receiver, amount)
        transaction.wait(1)


def main():
    contract = Contract()
    user1 = "0x128cf4716F521CbC7331c882977EAE8f7E4c4c53"
    print(
        f"your balance: {contract.getBalance(contract.account)} at {datetime.now}")
    contract.deposit(5000)
    for i in range(5):
        contract.sendTokens(user1, 1000)

    print(f"user1's balance: {contract.getBalance(user1)} at {datetime.now}")
    print(
        f"your balance: {contract.getBalance(contract.account)} at {datetime.now}")
