// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

// This is the contract with the standards and the mint funtion

contract ERC721 {
    // we can see the logs of people that are minting
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); //to show data, it creates a log
    //index --> to search in the list

    // Mapping --> hash table of key pair values 
    // Mapping from token id to the owner --> keep track how many token a token adress has 
    mapping (uint => address) private _tokenOwner;

    //mapping form owner to number of owned tokend (keep track of token owner addresses to token ids)
    mapping (address => uint) private _OwnedTokensCount;

    //Function that check if a token already exist 
    //Only internal
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
//We call the function in the AXNFT contract
/// We mark it as virtual, we override it in the enumerable contract 
    function _mint(address to, uint256 tokenId) internal virtual {
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
    // COMMENTS OF THE NFT ETHEREUM PAGE
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    // We want to check the balance of the owners, we make it public, view a return, it return the balance (uint)
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "This is a non existent query");
        return _OwnedTokensCount[_owner];
    }
    // SIMILAR TO BALANCE OF --> Integer and spinning out an adress (not integer from adress)
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "This is a non existent Token"); //make sure the owner address is valid
        return owner; //returns an address
    }






}