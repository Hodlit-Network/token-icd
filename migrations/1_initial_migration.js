const Migrations = artifacts.require("./Migrations.sol");
const HODLIT = artifacts.require("./HODLIT.sol");
const Mock = artifacts.require("./Mock.sol");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(HODLIT);

  // deployer.deploy(HODLIT).then(() => {
  //   return deployer.deploy(Mock, HODLIT.address);
  // })

};
