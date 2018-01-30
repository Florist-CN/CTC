var CommunityCoin = artifacts.require("CommunityCoin");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(CommunityCoin);
};
