// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import './AXNFT.sol';

contract NFTBasket is AXNFT, ERC20 {   
// um auf die FUnktionen von AXNFT zugreifen zu können
  
  uint256 public totalinBasket;
  
  // struct to store a stake's token, owner, and earning values
  struct Stake {
    uint24 tokenId;
    address owner;
  }

  event NFTStaked(address owner, uint256 tokenId, uint256 value);  
  event NFTUnstaked(address owner, uint256 tokenId, uint256 value);  // brauchen wir erst ganz am schluss
  

  // reference to the Block NFT contract
  AXNFT nft;
  ERC20 token;


  // maps tokenId to  
  mapping(uint256 => Basket) public vault; 

   constructor(AXNFT _nft, ERC20 _token) {    // hier haben wir noch kein Code für die Token 
    nft = _nft;
    token = _token;
   }


//um zu fragen welches der NFTs in den Basket soll -> wenn z.B. jemand viele NFTs hat 

 function stake(uint256[] calldata tokenIds) external {
    uint256 tokenId;  //aufrufen der Token ID  -> initialisieren der variable
    
    totalStaked += tokenIds.length;  // zusammenzählen aller NFT die von dieser Person in den Basket sollen -> brauchen wir das? meistenes ist ja sowieso nur eines das zu einem bestimmten Basket passt
    for (uint i = 0; i < tokenIds.length; i++) {    // kontrollieren jedes einzelnen NFTs 
      tokenId = tokenIds[i];
      
      //if cause mit tokenID ob eigenschaften zu Basket passen -> oder besser require --> wenn es nicht passt: "NFT doesn't fit with selected basket."  -> video mit mehreren stakes
      require(ERC721.ownerOf(tokenId) == msg.sender, "not your NFT");   // für das brauchen wir mit OWner of die adresse des Owner -> beim NFT smart contract -> oder doch NFT.
      require(vault[tokenId].tokenId == 0, 'already in Basket');    // speichert den Besitzer des NFT, damit dieser das eigene NFT wieder zurück bekommen kann. -> brauchen wir eher nicht 
      
      //macht den Transfer in den vaulet -> NFT wird in den BAsket gelegt
      nft.transferFrom(msg.sender, address(this), tokenId);
      emit NFTStaked(msg.sender, tokenId, block.timestamp);

      // das ist unser basket
      vault[tokenId] = Basket({
        owner: msg.sender,
        tokenId: uint24(tokenId),
        //timestamp: uint48(block.timestamp)   //das brauchen wir eher nicht, da wir ja keine Zeitstoppen müssen 
      });
    }
    // token.mint(account);  // mint funktion um token zu minten
  }
  
  //Funktion um es zu unstaken -> brauchen wir auch da man die Token ja wieder zurück geben möchte 
  //Die frage ist jedoch ob wir es auch so machen wollen dass der ehemalige besitzer gespeichert wird und dann sein eigenes NFT wieder zurück erhält oder ob darf man bei uns einfach irgendein NFT vom Basket kaufen. 
  function _unstakeMany(address account, uint256[] calldata tokenIds) internal {
    uint256 tokenId;
    totalStaked -= tokenIds.length;
    for (uint i = 0; i < tokenIds.length; i++) {
      tokenId = tokenIds[i];
      Stake memory staked = vault[tokenId];
      require(staked.owner == msg.sender, "not an owner");

      delete vault[tokenId];
      emit NFTUnstaked(account, tokenId, block.timestamp);
      nft.transferFrom(address(this), account, tokenId);
    }
  }
  
  
  
  //brauchen wir erst am schluss da das zu schwierig sein könnte -> aber nur ein Teil davon
  
  function unstake(uint256[] calldata tokenIds) external {
      _claim(msg.sender, tokenIds, true);
  }
      
     // token.mint(account);  // mint funktion um token zu minten
       
    if (_unstake) {
      _unstakeMany(account, tokenIds);    // das brauchen wir!!! -> hier erhält man das Smart Contract zurück
    }
  }

  // should never be used inside of transaction because of gas fee
  function balanceOf(address account) public view returns (uint256) {     //zeigt wie viele NFTs man gestaket hat  -> können wir eher nicht brauchen da die NFTs dann nicht mehr im besitz sind 
  // man könnte stattdessen ein zähler bei der staking funktion einbauen der zählt wie viel man schon in ein Bsket gelegt hat und beim unstaking wie viel wieder entfernt wurde
    uint256 balance = 0;
    uint256 supply = nft.totalSupply();
    for(uint i = 1; i <= supply; i++) {
      if (vault[i].owner == account) {
        balance += 1;
      }
    }
    return balance;
  }

  // should never be used inside of transaction because of gas fee
  function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {    // zeigt welche spezifischen Token im Vault sind -> können wir so direkt auch nicht brauchen 
// der ehemalige besitzer des NFTs besitzt das NFT nicht mehr, man könnte bei der staking funktion ein memory machen in dem alle ehemaligen NFTs ID gespeichert werden 
    uint256 supply = nft.totalSupply();
    uint256[] memory tmp = new uint256[](supply);

    uint256 index = 0;
    for(uint tokenId = 1; tokenId <= supply; tokenId++) {
      if (vault[tokenId].owner == account) {
        tmp[index] = vault[tokenId].tokenId;
        index +=1;
      }
    }

    uint256[] memory tokens = new uint256[](index);
    for(uint i = 0; i < index; i++) {
      tokens[i] = tmp[i];
    }

    return tokens;
  }

  function onERC721Received(    // kontrolliert ob die NFTs auch wirklich gesendet werden konnten 
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
      require(from == address(0x0), "Cannot send nfts to Vault");
      return IERC721Receiver.onERC721Received.selector;
    }
  
  
}
