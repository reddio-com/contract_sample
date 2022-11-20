// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Reddio721MintFor is ERC721Enumerable, ERC721URIStorage, AccessControl {

    string _baseTokenURI;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    address public constant prodOperatorAddress = 0xB62BcD40A24985f560b5a9745d478791d8F1945C;
    address public constant testOperatorAddress = 0x8Eb82154f314EC687957CE1e9c1A5Dc3A3234DF9;

    constructor(string memory name_, string memory symbol_, string memory baseURI) ERC721(name_, symbol_) {
        _setupRole(ADMIN_ROLE, msg.sender);
        _baseTokenURI = baseURI;
    }


    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "ReddioMintFor: must have admin role"
        );
        _baseTokenURI = baseURI;
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

    modifier onlyOperator() {
        require((msg.sender == prodOperatorAddress) || (msg.sender == testOperatorAddress), "only the operator contract can call mintFor");
        _;
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256){
        uint256 number;
        for (uint i = 0; i < b.length; i++) {
            number = number + uint(uint8(b[i])) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }

    // amount for later use
    function mintFor(address player, uint256 amount, bytes calldata mintingBlob)
        public
        onlyOperator
        returns (uint256)
    {
        uint256 tokenId = bytesToUint(mintingBlob);
        _mint(player, tokenId);

        return tokenId;
    }
}
