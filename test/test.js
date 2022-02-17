const myToken = artifacts.require("./Mytoken.sol");
require("chai").use(require("chai-as-promised")).should();
const assert = require("chai").assert;
contract("MYToken", ([deployer, author, tipper]) => {
  let Mytoken;

  before(async () => {
    //Mytoken = await myToken.deployed();
    Mytoken = await myToken.at("0x0E41115Aedc85c40d9fbc2267f4181FBce845fA3");
  });
  describe("deployment", async () => {
    it("deploys successfully", async () => {
      const address = await Mytoken.address;

      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.equal(address, "0x0E41115Aedc85c40d9fbc2267f4181FBce845fA3");
    });
    const sign =
      "0xe6904485d9ec60855fd63164d1f6886964f66cbc6411818009f66bf76715f44971269c05cb44f08b4ad87e804e023653a343e8ed70e6c4258e46e3725f21f4d61b";
    it("singer wallte address", async () => {
      const address = await Mytoken.check(sign, "Akhilesh");
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.equal(address, "0xE0E24a32A7e50Ea1c7881c54bfC1934e9b50B520");
    });

    it("Mint NFT", async () => {
      let event = await Mytoken.buyLazyToken(
        "0x98978D41Ffbd3cBaA517ef6A3b4C7ebDc005158A",
        12,
        "",
        sign,
        { from: author, value: 13 }
      );
    });
    it("when price is 0 ", async () => {
      const event = await Mytoken.buyLazyToken(
        "0xF995CE1B760148F531c86AadCED893d6dB0Ef5C0",
        0,
        "Akhilesh",
        sign,
        { from: author, value: 13 }
      ).should.be.rejected;
    });
    it("when value is 0", async () => {
      const event = await Mytoken.buyLazyToken(
        "0xF995CE1B760148F531c86AadCED893d6dB0Ef5C0",
        10,
        "Akhilesh",
        sign,
        { from: author, value: 0 }
      ).should.be.rejected;
    });

    it("get Token URI", async () => {
      let TokenURI = await Mytoken.tokenURI(1);
      console.log(TokenURI);
      TokenURI = await Mytoken.tokenURI(19).should.be.rejected;
    });
    it("owner of token", async () => {
      const owner = await Mytoken.balanceOf(
        "0x98978D41Ffbd3cBaA517ef6A3b4C7ebDc005158A"
      );
      console.log(owner.toNumber());
      let Tokenowner = await Mytoken.ownerOf(1);

      console.log(Tokenowner);
      Tokenowner = await Mytoken.ownerOf(199).should.rejected;
    });
    it("direct mint", async () => {
      const owner = await Mytoken.mintTokenOnBlockchain("");
      let owner1 = await Mytoken.ownerOf(1);
      console.log(owner1.toString());
      owner1 = await Mytoken.ownerOf(2);
      console.log(owner1);
      console.log();
    });
  });
});
