// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact 
contract CatNFT is ERC721, ERC721URIStorage, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;
    //是否开启盲盒
    bool private _blindBoxOpened = false;
    //设置盲盒uri
    string baseUri;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FDF20220325FNFT", "FDF20220325FNFT") {
      _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
      _grantRole(MINTER_ROLE, msg.sender);
    }

    function setBaseUri(string memory _baseUri) public {

        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "BaseERC721Uri: only admin can do this action"
        );
        baseUri = _baseUri;
    }

    function setBlindBoxOpened(bool _status) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "BaseERC721BlindBox: only admin can do this action"
        );
        _blindBoxOpened = _status;
    }


    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }


    function tokenURI(uint256 tokenId) 
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        if(_blindBoxOpened){
            return super.tokenURI(tokenId);
        }else {
            return baseUri;
        }
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}