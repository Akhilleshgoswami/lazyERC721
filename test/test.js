const myToken = artifacts.require("./Mytoken.sol");

contract("MYToken", ([deployer, author, tipper]) => {
  let Mytoken;

  before(async () => {
    Mytoken = await myToken.deployed();
  });

  describe("deployment", async () => {
    it("deploys successfully", async () => {
      const address = await Mytoken.address;
      console.log(address);
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
    const sign =
      "0x8acfe5610f9e917fea379b5a2c2c6d8067a21c3e3b2f233ab9c1816edee923c97ea2b5ab7b7764de496d1bcce35859b86ef204bb9bf98c6b94791aebf97826ec1b";
    it("user wallte address", async () => {
      const address = await Mytoken.check(sign, "Akhilesh");
      console.log(address);
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
      const TokenURI = await Mytoken.tokenURI(1);
      console.log(TokenURI);
    });
    it("owner of token", async () => {
      const owner = await Mytoken.balanceOf(
        "0xf995ce1b760148f531c86aadced893d6db0ef5c0"
      );
      const owner1 = await Mytoken.ownerOf(1);
      console.log(owner1);
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
