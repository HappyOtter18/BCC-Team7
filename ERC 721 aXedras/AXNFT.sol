// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

// The market place Smart Contract, the main Smart contract 

import './connector.sol';

contract NFTaXedras is connector {

    // Array that keep track of the minted NFT 
    string[] public AXNFTz;
    //check if an ID already exist
    mapping(string => bool) _AXNFTzExists;

// This function will make an array of the NFT already minted
// Mint NFT to adresses and keep track of the adresses who mint the NFTs. 
//The other mint funtion, we don't have access directly, this is internal
    function mint(string memory _GoldNFT) public {
        require(!_AXNFTzExists[_GoldNFT], "error, this NFT already exists"); //We can't mint two same NFTs
        AXNFTz.push(_GoldNFT);
        uint _id = AXNFTz.length -1;
        _mint(msg.sender, _id); //we get an id for each token. The msg.sender is our adress (the one that interact). 
        _AXNFTzExists[_GoldNFT] =true;
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
        _burn2();
    }

//initialize this contract to inherit name and symbol form erc721metadata so that the name is goldnft and the symbol is AXNFT
    constructor () connector("GoldNFT", "AXNFT") {

    }


}