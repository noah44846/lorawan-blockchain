//GetAllNodes using getAllNodeAddresses + getNodeInfo

// Import libraries
var Web3 = require('web3'),
    contract = require("truffle-contract"),
    path = require('path')
MyContractJSON = require('../../build/contracts/GatewayManager.json');

// Setup RPC connection   
var provider = new Web3.providers.HttpProvider("http://localhost:8545");


// Read JSON and attach RPC connection (Provider)
var MyContract = contract(MyContractJSON);
MyContract.setProvider(provider);

// Use Truffle as usual
MyContract.deployed().then(function (instance) {
    return instance.owner.call({ from: "0x6589F246e977EAc11199EF81Ba7FDD6995Fe6500" });
}).then(function (result) {
    console.log(result);
}, function (error) {
    console.log(error);
});
