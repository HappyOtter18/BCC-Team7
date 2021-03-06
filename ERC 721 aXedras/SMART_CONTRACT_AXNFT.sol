// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;


// This is the final contract. It was tried to implement it from scratch (see other contracts). At the end, for more convinience and to avoid unnecessary 
// errors, we implemented it with the openzeppelin Standard. 

// To use the contract, only deploy this contract.

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract AXNFT is ERC721Enumerable {

 // Array that keep track of the minted NFT 
    string[] private AXNFTz;
    string[] private aXUniqueId;
    string[] private finess;
    uint256[] private weight;
    string[] private provenance;
    string[] private material;
    string[] private certification;
    //check if an ID already exist
    mapping(string => bool) _AXNFTzExists;

    address aX;

//initialize this contract to inherit name and symbol form erc721metadata so that the name is goldnft and the symbol is AXNFT
    constructor () ERC721("GoldNFT", "AXNFT") {
        aX = msg.sender;
    }



// This function will make an array of the NFT already minted
// Mint NFT to adresses and keep track of the adresses who mint the NFTs. 
//The other mint funtion, we don't have access directly, this is internal
    function mint(address _to, string memory _url, string memory _aXuniqueId, string memory _finess, uint256 _weightGramms, string memory _provenance, string memory _material, string memory _certification) public {
        require(!_AXNFTzExists[_url], "error, this NFT already exists"); //We can't mint two same NFTs
        require(!_AXNFTzExists[_aXuniqueId], "error, this NFT already exists");
        require (msg.sender == aX, "you can't mint NFTs on this contract"); //Only the company, deployer of the contract can mint the token
        AXNFTz.push(_url);
        aXUniqueId.push(_aXuniqueId);
        finess.push(_finess);
        weight.push(_weightGramms);
        provenance.push(_provenance);
        material.push(_material);
        certification.push(_certification);
        uint _id = AXNFTz.length -1;
        _safeMint(_to, _id); //we get an id for each token. The msg.sender is our adress (the one that interact). 
        _AXNFTzExists[_url] =true;
        _AXNFTzExists[_aXuniqueId] =true;
    }

    function tokendata(uint256 _tokenId) public view returns (string memory, string memory, string memory, uint256, string memory, string memory, string memory){
        string memory URL = AXNFTz[_tokenId];
        string memory aXId = aXUniqueId[_tokenId];
        string memory finessbar = finess[_tokenId];
        uint256 weightbar = weight[_tokenId];
        string memory provenancebar = provenance[_tokenId];
        string memory materialbar = material[_tokenId];
        string memory certificationbar = certification[_tokenId];
        require(_exists(_tokenId), "token ID not existent anymore");
        return (URL, aXId, finessbar, weightbar, provenancebar, materialbar, certificationbar);
    }

      
    function burn(uint256 _tokenId) public {
        require (msg.sender == aX, "you don't have the allowance to burn NFTs"); //Only the company, deployer of the contract can burn the Token
        _burn(_tokenId);
        
    }

}

