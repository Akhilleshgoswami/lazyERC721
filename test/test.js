const myToken = artifacts.require("./Mytoken.sol");
require("chai").use(require("chai-as-promised")).should();
const assert = require("chai").assert;
contract("MYToken", ([deployer, author, tipper]) => {
  let Mytoken;

  before(async () => {
    //Mytoken = await myToken.deployed();
    Mytoken = await myToken.at("0xcbF8f3572ee696b35a1824b92848b4C122981b87");
  });

  describe("deployment", async () => {
    it("deploys successfully", async () => {
      const address = await Mytoken.address;

      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.equal(address, "0xcbF8f3572ee696b35a1824b92848b4C122981b87");
    });
    const sign =
      "0x59b2045f74961a571d95e5f782434d5cd42900da99f9d9a12cefa8d8e04adc41014325cecd832993148b47f058db32e0e9c7c2ea4d51c14a5cf82cb74080d5e01b";
    it("singer wallte address", async () => {
      const address = await Mytoken.check(sign, "Akhilesh");
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.equal(address, "0xE0E24a32A7e50Ea1c7881c54bfC1934e9b50B520");
    });

    it("Mint NFT", async () => {
      const event = await Mytoken.buyToken(
        "0xF995CE1B760148F531c86AadCED893d6dB0Ef5C0",
        12,
        "Akhilesh",
        sign,
        { from: author, value: 13 }
      );
    });
    it("get Token URI", async () => {
      let TokenURI = await Mytoken.tokenURI(1);
      console.log(TokenURI);
      TokenURI = await Mytoken.tokenURI(9).should.be.rejected;
    });
    it("owner of token", async () => {
      const owner = await Mytoken.balanceOf(
        "0xf995ce1b760148f531c86aadced893d6db0ef5c0"
      );
      let Tokenowner = await Mytoken.ownerOf(1);

      console.log(Tokenowner);
      Tokenowner = await Mytoken.ownerOf(10).should.rejected;
    });
    it("direct mint", async () => {
      const owner = await Mytoken.mintToken(
        "ak",
        "0xf995ce1b760148f531c86aadced893d6db0ef5c9"
      );
      let owner1 = await Mytoken.ownerOf(1);
      console.log(owner1);
      owner1 = await Mytoken.ownerOf(2);
      console.log(owner1);
    });
  });
});
