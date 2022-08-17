const { assert } = require("chai");

const TruffleTutorial = artifacts.require("./TruffleTutorial.sol");

require("chai")
  .use(require("chai-as-promised"))
  .should()

contract("TruffleTutorial", ([contractOwner, secondAddress, thirdAddress]) => {
  let truffleTut;

  before(async () => {
    truffleTut = await TruffleTutorial.deployed();
  });

  describe("deployment", () => {
    it("deploys successfully", async () => {
      const address = await truffleTut.address;

      assert.notEqual(address, '');
      assert.notEqual(address, undefined);
      assert.notEqual(address, null);
      assert.notEqual(address, 0x0);
    })

    it('has a message', async () => {
      const message = await truffleTut.message()
      assert.equal(message, 'Hello World')
    })
  })
})