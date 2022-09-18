// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;


import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721General.sol";

contract Reddio721MintFor is Reddio721General {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //replace "0x8Eb82154f314EC687957CE1e9c1A5Dc3A3234DF9" with the operator contract address
    address public constant operatorAddress = 0x8Eb82154f314EC687957CE1e9c1A5Dc3A3234DF9;

    constructor(string memory name_, string memory symbol_, string memory baseURI) Reddio721General(name_, symbol_, operatorAddress, true, baseURI) {
        _tokenIds.increment();
    }

    modifier onlyOperator() {
        require(msg.sender == operatorAddress, "only the operator contract can call mintFor");
        _;
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256){
        uint256 number;
        for(uint i=0;i<b.length;i++){
            number = number + uint(uint8(b[i]))*(2**(8*(b.length-(i+1))));
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