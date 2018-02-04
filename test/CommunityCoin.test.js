const CommunityCoin = artifacts.require('CommunityCoin.sol');

contract('CommunityCoin', accounts => {
  let token;
  const creator = accounts[0];

  beforeEach(async function () {
    token = await CommunityCoin.new({ from: creator });
  });

  it('has a name', async function () {
    const name = await token.name();
    assert.equal(name, 'Coin of The Community');
  });

  it('has a symbol', async function () {
    const symbol = await token.symbol();
    assert.equal(symbol, 'CTC');
  });

  it('has 18 decimals', async function () {
    const decimals = await token.decimals();
    assert(decimals.eq(18));
  });

  it('cannot be unpause in lock period', function () {
    token.unpause.call()
    .then(res => assert(false,"unpaused in lock period"))
    .catch(err =>{
      assert(err);
    });
  });

  it('cannot transer in lock period', async function () {
    await token.mint(accounts[0],50);
    balance = await token.balanceOf(accounts[0]);
    assert(balance.eq(50));
    token.transfer.call(accounts[1],25)
    .then(res => assert(false,"transer in lock period"))
    .catch(err =>{
      assert(err);
    });
  });

  it('can be unpause after lockPeriod', async function () {
    await token.setLockPeriod(0);
    await sleep(1001);
    token.unpause.call()
    .then(res => assert(res))
    .catch(err =>{
      console.log(err);
      assert(false,"can not unpause after lock period");
    });
  });

   it('can transer after lockPeriod', async function () {
    await token.mint(accounts[0],50);
    await token.setLockPeriod(0);
    await sleep(1001);
    await token.unpause();
    token.transfer.call(accounts[1],25)
    .then(async(res) =>{
      await sleep(1001);
      const balance1 = await token.balanceOf(accounts[0]);
      const balance2 = await token.balanceOf(accounts[1]);
      console.log(balance1);
      assert.equal(balance1, balance2, "transfer value not correct");
    })
    .catch(err =>{
      console.log(err);
      assert(false,"can not transer after lock period");
    });
  });
});

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
