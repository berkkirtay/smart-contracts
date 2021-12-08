
# Get a list of networks:
brownie networks list

# Compile the specified contract:
brownie compile .\contracts\CryptoBank.sol  

# Run the scripts on ropsten testnet:
# brownie run ".\scripts\deploy.py" --network ropsten

## Run the scripts on local ganache server:
brownie networks add Ethereum ganache-local host=http://127.0.0.1:7545 chainid=5777