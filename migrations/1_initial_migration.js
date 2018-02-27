const Migrations = artifacts.require("./Migrations.sol");
const HODLIT_DEV = artifacts.require("./HODLIT_DEV.sol");
const HODLIT = artifacts.require("./HODLIT.sol");
const Mock = artifacts.require("./Mock.sol");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(HODLIT);
  deployer.deploy(HODLIT_DEV).then(() => {
    return deployer.deploy(Mock, HODLIT_DEV.address);
  })


};
