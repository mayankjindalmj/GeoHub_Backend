const datasetManager = artifacts.require("DatasetManager");
var fs = require("fs");
var fileContent = require("../build/contracts/DatasetManager.json");

module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(datasetManager).then(() => {
    var contractConfig = {
      abi: fileContent.abi,
      address: datasetManager.address
    };

    fs.writeFileSync('info/DatasetManager.json', JSON.stringify(contractConfig), { flag: "w" });
  })
};
