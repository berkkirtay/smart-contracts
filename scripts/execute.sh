
# Get a list of networks:
# brownie networks list

# Compile the specified contract:
brownie compile .\contracts\CryptoBank.sol  

# Run the scripts on ropsten testnet:
brownie run ".\scripts\deploy.py" --network ropsten