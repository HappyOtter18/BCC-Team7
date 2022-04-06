// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

// KEEP TRACK OF ALL NFT 
//Enumerable --> mathematic, not like in C 

// we need the mint function of the ERC721 function

import "./ERC721.sol";

contract enumerable is ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mappping of owner to list -> [] of all owner token ids 
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from token ID to index of the owner tokens list --> []
    mapping(uint256 => uint256) private _ownedTokensIndex;


    //This function must override the mint function in ErC721
    function _mint(address to, uint tokenId) internal override(ERC721) {
        //super allow to grab the mint function from ERC721
        super._mint(to, tokenId);
        //To further build a market place, it is important to keep the market place. To have a real functioning market place.
        //we need to build many things to store the informations in teh mapping 
        //add tokens to the owner (so we know as the owner how many tokens we have, keep track of the mapping)
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the allTokens array
    // Set the position of the all tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId]= _allTokens.length; //to store the token index, at which position it is going to be, added to the index
        //add tokens with the push method
        _allTokens.push(tokenId);

    }

    //function of owner enumeration
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        // 1. set to our owned token the address and information (token id) --> so add address and id to _ownedTokens
        // 2. set the mapping to ownedTokenIndex --> set to address of ownedTokens position 
        // Execute this function with minting
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length; //address of position
    }

    // two function, one that returns tokenByIndex 
    // the other that returns tokenByOwnerIndex
    function tokenByIndex(uint256 index) public view returns(uint256){
        // make sure that the index is not out of bound of the total supply, the index must be in the range of existence
        require(index < totalSupply(), "global index is out of bounds!");
        // Search through index and return the token index, to keep track
        return _allTokens[index]; 
    }
    //return owner by the index
    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint256){
        // check the index against the ERC721 BalanceOf function
        require(index < balanceOf(owner), "Owner index is out of bound"); //make sure we are in the range
        return _ownedTokens[owner][index];
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    //how much tokens is there
    //keep track of NFT that are minted
    //Return the total supply of the all tokens array
    function totalSupply() public view returns (uint256){
        return _allTokens.length;

    }



}
