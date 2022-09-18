pragma solidity >=0.8.7;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Reddio721General is ERC721Enumerable, ERC721URIStorage, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    string _baseTokenURI;
    

    bool _publicMint;
    constructor(string memory name_, string memory symbol_,  address owner , bool publicMint, string memory baseURI)
    ERC721(name_, symbol_)
    {
        _setupRole(ADMIN_ROLE, owner);
        _setupRole(MINTER_ROLE, owner);
        _publicMint = publicMint;
        _baseTokenURI = baseURI;
    }

    /**
      * @dev Function to mint tokens.
     * @param to The address that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @param uri The token URI of the minted token.
     * @return A boolean that indicates if the operation was successful.
     */
    function mintWithTokenURI(
        address to,
        uint256 tokenId,
        string memory uri
    ) public returns (bool) {
        if (!_publicMint) {
            require(
                hasRole(MINTER_ROLE, _msgSender()),
                "ReddioGeneral721: must have minter role to mint"
            );
        }
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return true;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "ReddioGeneral721: must have admin role"
        );
        _baseTokenURI = baseURI;
    }

    /**
     * @dev Function to mint tokens. This helper function allows to mint multiple NFTs in 1 transaction.
     * @param to The address that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @param uri The token URI of the minted token.
     * @return A boolean that indicates if the operation was successful.
    */
    function mintMultiple(
        address[] memory to,
        uint256[] memory tokenId,
        string[] memory uri
    ) public returns (bool) {
        if (!_publicMint) {
            require(
                hasRole(MINTER_ROLE, _msgSender()),
                "ReddioGeneral721: must have minter role to mint"
            );
        }
        for (uint256 i = 0; i < to.length; i++) {
            _safeMint(to[i], tokenId[i]);
            _setTokenURI(tokenId[i], uri[i]);
        }
        return true;
    }

    function safeTransfer(address to, uint256 tokenId, bytes calldata data) public virtual {
        super._safeTransfer(_msgSender(), to, tokenId, data);
    }

    function safeTransfer(address to, uint256 tokenId) public virtual {
        super._safeTransfer(_msgSender(), to, tokenId, "");
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable, AccessControl)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}