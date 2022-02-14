pragma solidity ^0.8.2;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract Mytoken is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    using ECDSA for bytes32;
    Counters.Counter private tokendIds;
    mapping(uint256 => string) private _tokenURIs; // mapping to token URI

    string private _baseURIextended;

    constructor() ERC721("Mytoken", "MTK") {}

    event mintNft(address owner, address seller, uint256 tokenId);

    /**
     *
     * function check - it is used to check the signature of the user .
     * {param} signature - it the user signature  .
     *  {param} tokenUri  - it is the IPFS hash of the token .
     * returns -  singer wallate Address
     *
     */

    function check(
        bytes memory signature,
        string memory tokenUri
    ) public view returns (address) {
        return _getsignerAddress(signature,tokenUri);
    }

    /***
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

    /**
     *
     * function buyToken  - It the function to buy The lazy NFT.
     * {param}  buyer -  wallate address of the buyer.
     * {param} price - price of the NFT.
     * {param} uri - The IPFS URL of the NFT.
     * {param} signature -  The   keccak256 of signer.
     *
     * **/
    function buyToken(
        address buyer,
        uint256 price,
        string memory uri,
        bytes memory signature
    )  public  payable returns (uint256) {
        //the value must be greate then or eqaul to the price
        require(msg.value >= price, "Insufficient funds to redeem");
        // address must not be null
        address saller = check(signature, uri);
        require(
            (buyer != address(0) && saller != address(0)),
            "you can not mint for null address"
        );
        tokendIds.increment();
        uint256 tokenId = tokendIds.current();
        // first assign the token to the signer, to establish provenance on-chain.
        _mint(saller, tokenId);
        //set the token URI.
        _setTokenURI(tokenId, uri);
        // transfer token to buyer.
        _transfer(saller, buyer, tokenId);
        // paying the owner of the lazy NFT.
        payable(saller).transfer(price);
        emit mintNft(buyer, saller, price);

        return tokenId;
    }

    /**
     * function - this function directly mint the Token.
     * {param} URI - IPFS URL of The Token.
     * {param} minter - eth address of the minter.
     */
    function mintToken(
        string memory URI,
        address minter
    ) public returns (uint256) {
        require(minter != address(0), "you can not mint for null address");
        tokendIds.increment();
        uint256 tokenId = tokendIds.current();
        //mint the NFT.
        _mint(minter, tokenId);
        //set the token URI.
        _setTokenURI(tokenId, URI);
        return tokenId;
    }

    /**
     * {param}  _signature - keccak256 hash.
     * {param} _url - IPFS url of the Token.
     * returns  - the eth address of signer.
     *
     * **/

    function _getsignerAddress(
        bytes memory _signature,
        string memory _url
    ) internal view returns (address) {
        bytes32 messagehash = keccak256(
            //in production _url is going to change with contract address
            abi.encodePacked(_url)
        );
        // getting the signer eth address.
        address signer = messagehash.toEthSignedMessageHash().recover(
            _signature
        );

        return signer;
    }
}
