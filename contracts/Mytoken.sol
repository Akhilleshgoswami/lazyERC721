
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Context.sol";
contract Mytoken is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    using ECDSA for bytes32;
    Counters.Counter private tokendIds;
    mapping(uint256 => string) private _tokenURIs; // mapping to token URI

    string private _baseURIextended;

    constructor() ERC721("Mytoken", "MTK") {}

    event transferNft(address owner, address seller, uint256 tokenId);

    /*
     *  function check - it is used to check the signature of the user .
     *  {param} signature - it the user signature  .
     *  {param} tokenUri  - it is the IPFS hash of the token .
	 *  returns -  singer wallate Address
     **/

    function check(
        bytes memory signature,
        string memory tokenUri
    ) public view returns (address) {
        return _getsignerAddress(signature,tokenUri);
    }

    /**
     * function _setTokenURI - It is used to set the URI of NFT.
     * {Param} tokenId - It is the Token Id of NFT.
     * {param} _tokenURI - It is the IPFS URI of the NFT.
     * */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    /**
     * {param} - tokendId - It is the Token Id of the Tokend.
     *  returns - return the TokenURI.
     * */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];

        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    /*
     * function buyToken  - It the function to buy The lazy NFT.
     * {param}  buyer -  wallate address of the buyer.
     * {param} price - price of the NFT.
     * {param} uri - The IPFS URL of the NFT.
     * {param} signature -  The   keccak256 of signer.
     *
     * **/
    function buyLazyToken(
        address buyer,
        uint256 price,
        string memory uri,
        bytes memory signature
    )  public  payable  returns (uint256){
      require(msg.value >= price,"please give a proper price");
	  require(price > 0,"price must be > 0");
        address saller = check(signature, uri);
        _mintNFt(saller,uri); 
        // transfer token to buyer.
        _transferNft(buyer,saller,price,tokendIds.current());
        return tokendIds.current();
    }
/**
*function - will transfer a minted nft on blokchain 
*`buyer` - wallat address
*`price` - nft value.
*`tokenId` - nft tokendId
**/
function buyMintedToken(
       address buyer,
       uint256 price,
       uint256 tokenId
	)  public payable {
      require(msg.value >= price,"please give a proper price");
	  require(price > 0,"price must be > 0");
       address saller =  ownerOf(tokenId);
      _transferNft(buyer,saller,price,tokenId); 
	}
    /**:
     * function - this function directly mint the Token.
     * {param} URI - IPFS URL of The Token.
     * {param} minter - eth address of the minter.
     */
    function mintTokenOnBlockchain(
        string memory URI
         ) public returns (uint256) {
        //mint the NFT.
		_mintNFt(_msgSender(),URI);
        return tokendIds.current();
    }

    /* {param}  _signature - keccak256 hash.
     * {param} _url - IPFS url of the Token.
     * returns  - the eth address of signer.
     */

    function _getsignerAddress(
        bytes memory _signature,
        string memory _url
    ) internal view returns (address) {
        bytes32 messagehash = keccak256(
            //in production _url is going to change with contract address
            abi.encodePacked(address(this),_url)
        );
        // getting the signer eth address.
        address signer = messagehash.toEthSignedMessageHash().recover(
            _signature
        );
        return signer;
    }
 // internal functions 
	function _transferNft(address _buyer,address _saller,uint256 _price,uint256 _tokenId)internal {
      require(_buyer!= address(0) && _saller != address(0),"you can not transfer") ;
         // transfer token to buyer.
           _transfer(_saller, _buyer, _tokenId);
        // paying the owner of the lazy NFT.
      payable(_saller).transfer(_price);

      emit transferNft(_buyer, _saller, _price);
	}

	function _mintNFt(address _owner,string memory _URI)internal{
	 require(bytes(_URI).length> 0,"URI can not be null");
     require(_owner != address(0),"you can not mint NFT on null address") ;
        tokendIds.increment();
        uint256 _tokenId = tokendIds.current();
		_mint(_owner, _tokenId);
        _setTokenURI(_tokenId, _URI);

	}
}
