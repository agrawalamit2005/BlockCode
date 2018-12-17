var AssetMgmt = artifacts.require("./LandAssets.sol");
module.exports = function(deployer) {
  deployer.deploy(AssetMgmt);
};

