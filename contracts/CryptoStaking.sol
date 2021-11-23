// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CryptoStaking {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public accountStakeDates;
    mapping(address => uint256) public accountStakeAmounts;
    mapping(address => uint256) public latestStakeRewards;

    // Stake reward rate
    uint256 constant interest = 3;

    // duration -> days
    function stake(uint256 duration, uint256 amountToBeStaked) public {
        require(
            balances[msg.sender] >= amountToBeStaked,
            "You have insufficient funds!"
        );
        require(
            accountStakeDates[msg.sender] == 0,
            "This account established a stake process already!"
        );

        // Stake amoutns of accounts:
        accountStakeAmounts[msg.sender] = amountToBeStaked;
        // Timestamp for stake duration.
        accountStakeDates[msg.sender] =
            block.timestamp +
            duration *
            24 *
            60 *
            60;

        // Stake reward
        latestStakeRewards[msg.sender] = (amountToBeStaked * duration * interest) / 300;
        balances[msg.sender] += latestStakeRewards[msg.sender];

        emit Stake(msg.sender, amountToBeStaked, duration);
    }

    function deposit() public payable {
        require(msg.value > 1, "Deposit amount must be more than 1 wei!");

        uint256 depositedAmount = msg.value;
        balances[msg.sender] += depositedAmount;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable {
        require(
            balances[msg.sender] != 0,
            "You don't have any funds in your bank account!"
        );

        uint256 stakeTimeStamp = accountStakeDates[msg.sender];
        if (stakeTimeStamp != 0) {
            if (stakeTimeStamp > block.timestamp) {
                require(
                    balances[msg.sender] - accountStakeAmounts[msg.sender] - latestStakeRewards[msg.sender] >=
                        amount,
                    "You can only withdraw the funds that are not staked!"
                );
            } else {
                // If account's stake duration is over, then we set stake parameters as 0.
                accountStakeDates[msg.sender] = 0;
                accountStakeAmounts[msg.sender] = 0;
                latestStakeRewards[msg.sender] = 0;
            }
        }

        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;

        emit Withdraw(msg.sender, amount);
    }

    event Deposit(address from, uint256 amount);

    event Withdraw(address from, uint256 amount);

    event Stake(address from, uint256 amount, uint256 duration);
}
