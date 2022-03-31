// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;



contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); //to show data, it creates a log
    //index --> to search in the list

    // Mapping --> hash table of key pair values 
    // Mapping from token id to the owner --> keep track how many token a token adress has 
    mapping (uint => address) private _tokenOwner;

    //mapping form owner to number of owned tokend (keep track of token owner addresses to token ids)
    mapping (address => uint) private _OwnedTokensCount;

    //Function that check if a token already exist 
    function _exists(uint256 tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId]; //setting the address of NFT owner to check the mapping of the address from token Owner at the token Id
        return owner != address(0); //Is the adress 0, true or false
    }
    
    /*
    Here is the _mint function built. To create NFT. The essentials of the minting function:
        So we need the nft to point to an adress 
        Keep track of the Token Id 
        Keep track of token owner addresses to token ids
        keep track of how many tokens an owner address has
        Events that emits a transfer log - contract address, where it is being minted to, the id
    */
//Everybody can come and mint their own NFT
    function _mint(address to, uint256 tokenId) internal {
        //require that the adress is not 0 and the token doesn't already exist
        require(to != address(0), "ERC721: no minting address");
        require(!_exists(tokenId), "Token already minted"); //make sure that the minted Id doesn't exist. 
        //add the new adress with a token id for minting
        _tokenOwner[tokenId] =to;
        //How many token own each address? 
        _OwnedTokensCount[to] +=1;

        emit Transfer(address(0), to, tokenId);
        //address 0, default address
    }
}