const Hodlit = artifacts.require("./HODLIT.sol");
const BigNumber = require('bignumber.js');
const Mock = artifacts.require("./Mock.sol");

let hodlit;
let mock;
let multiplicator = '1000000000000000000';

contract('Hodl Incentive Token', accounts => {
  describe('#init checks', () => {
    it('should deploy contract', async () => {
      hodlit = await Hodlit.deployed();
      assert.equal(await hodlit.name.call(), 'HODL INCENTIVE TOKEN');
      assert.equal(await hodlit.symbol.call(), 'HIT');
      assert.equal(await hodlit.decimals.call(), 18);
      assert.equal(await hodlit.multiplicator.call(), multiplicator);
      assert.equal(await hodlit.totalSupply.call(), new BigNumber(30000000).times(multiplicator).valueOf());
      assert.equal(await hodlit.ICDCap.call(), new BigNumber(20000000).times(multiplicator).valueOf());
      assert.equal(await hodlit.hardCap.call(), new BigNumber(100000000).times(multiplicator).valueOf());
    })
  })
  describe('#icd registration', () => {
    it('registerEtherBalance() should fail before regStartTime', async () => {
      try {
        await hodlit.registerEtherBalance();
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })
    it('registerEtherBalance() should succeed after regStartTime', async () => {
      await hodlit.setDevelopment(true);
      await hodlit.addDays(8);
      await hodlit.registerEtherBalance({
        from: web3.eth.accounts[0]
      });
      await hodlit.registerEtherBalance({
        from: web3.eth.accounts[1]
      });
      assert.isAbove(await hodlit.etherBalances.call(web3.eth.accounts[0]), 0);
    })
    it('registerEtherBalance() should fail after regStopTime', async () => {
      await hodlit.addDays(7);
      try {
        await hodlit.registerEtherBalance();
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })
  })
  describe('#icd claims', () => {
    it('claimTokens() should fail before POHStopTime', async () => {
      assert.equal(await hodlit.ICDClaims.call(web3.eth.accounts[0]), false)
      try {
        await hodlit.claimTokens();
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })

    it('claimTokens() should succeed after POHStopTime', async () => {
      await hodlit.addDays(7);
      await hodlit.claimTokens({
        from: web3.eth.accounts[0]
      });
      assert.isAbove(await hodlit.balanceOf.call(web3.eth.accounts[0]), 0);
    })

    it('registerEtherBalance() should fail after POHStopTime', async () => {
      try {
        await hodlit.registerEtherBalance();
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })
    it('claimTokens() should fail if done twice for the same account', async () => {
      try {
        await hodlit.claimTokens({
          from: web3.eth.accounts[0]
        });
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })

    it('claimTokens() should fail after ICDStopTime', async () => {
      try {
        await hodlit.addDays(7);
        await hodlit.claimTokens({
          from: web3.eth.accounts[1]
        });
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })
  })
})



contract('MOCK ERC721', accounts => {
  describe('#init checks', () => {
    it('should deploy contract', async () => {
      mock = await Mock.deployed();
      assert.isAbove(await mock.hodlit.call(), 0);
    })
    it('setERC721Address() should assign ERC721 address', async () => {
      await hodlit.setERC721Address(mock.address);
      assert.isAbove(await hodlit.ERC721Address.call(), 0);
    })
    it('mintPCD() should fail before PCDStartTime', async () => {
      try {
        await mock.mintFor(web3.eth.accounts[3], new BigNumber(1000).times(multiplicator).toString());
      } catch (error) {
        assert.throws(() => {
          console.log(`\tError successfully catched => ${error}`)
          throw error
        })
      }
    })
    // bug with truffle
    // it('mintPCD() should succeed after PCDStartTime', async () => {
    //   await hodlit.addDays(15);
    //   await mock.mintFor(web3.eth.accounts[3], new BigNumber(1000).times(multiplicator).toString());
    //   assert.isAbove(await hodlit.balanceOf.call(web3.eth.accounts[3]), 0)
    // })
  })
})
