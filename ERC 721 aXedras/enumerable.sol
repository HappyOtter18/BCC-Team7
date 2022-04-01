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
        //add tokens to the owner 
        _addTokensToTotalSupply(tokenId);
    }

    function _addTokensToTotalSupply(uint256 tokenId) private {

        //add tokens with the push method
        _allTokens.push(tokenId);

    }


    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
//how much tokens is there
    function totalSupply() public view returns (uint256){
        return _allTokens.length;

    }

}
