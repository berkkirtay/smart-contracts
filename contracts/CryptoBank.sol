// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CryptoBank {
    mapping(address => uint256) public balances;
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    /*
     * From: 0x23bc92ca3d8dd080dd65914e40bad5a5bec93769 : owner
     * to:  0xd2d656253b91c5915cafdcd8b3a5249950739e10 : receiver
     */
    function send(address receiver, uint256 amount) public {
        require(owner.balance >= amount);

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
    }

    function getBalance(address publicAddress) public view returns (uint256) {
        return balances[publicAddress];
    }

    function deposit(uint256 amount) public {
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function depositWithETH() public payable {
        // A conversion rate between ETH and banks currency can be included.
        balances[msg.sender] += msg.value / 10000;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() public payable {
        require(msg.sender == owner);

        uint256 totalAmount = balances[owner];
        owner.transfer(totalAmount);
        balances[owner] = 0;

        emit Withdraw(msg.sender, totalAmount);
    }

    error InsufficientBalance(uint256 requested, uint256 available);

    event Sent(address from, address to, uint256 amount);

    event Deposit(address from, uint256 amount);

    event Withdraw(address from, uint256 amount);
}
