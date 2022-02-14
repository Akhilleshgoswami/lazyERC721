const Migrations = artifacts.require("Mytoken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
