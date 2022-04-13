// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./ERC721.sol";
import "./ERC20.sol";
import "./AXNFT.sol";
import "./connector.sol";

contract NFTBasket is ERC721, ERC20, AXNFT, connector {   
// um auf die FUnktionen von AXNFT zugreifen zu können
  
  uint256 public totalinBasket;
  
  struct vaultInfo {
        AXNFT nft;
        ERC20 token;
        string name;
  }

  vaultInfo[] public VaultInfo;

  // struct to store a stake's token, owner, and earning values
  struct Basket {
    uint24 tokenId;
    string certification;
    string provenance;
    //address owner;
  }

  

  event NFTpacked(address owner, uint256 tokenId);  
  //event NFTUnstaked(address owner, uint256 tokenId, uint256 value);  // brauchen wir erst ganz am schluss
  

  // reference to the Block NFT contract
  AXNFT nft;
  ERC20 token;


  // maps tokenId to  
  mapping(uint256 => Basket) public vault; 

  constructor(ERC721 _nft, ERC20 _token) {    // hier haben wir noch kein Code für die Token 
    nft = _nft;
    token = _token;
  }

  function addVault(
        AXNFT _nft,
        ERC20 _token,
        string calldata _name
    ) public {
        VaultInfo.push(
            vaultInfo({
                nft: _nft,
                token: _token,
                name: _name
            })
        );
    }



//um zu fragen welches der NFTs in den Basket soll -> wenn z.B. jemand viele NFTs hat 

 function stake(uint256[] calldata tokenIds) external {
    uint256 tokenId;  //aufrufen der Token ID  -> initialisieren der variable
    
    totalStaked += tokenIds.length;  // zusammenzählen aller NFT die von dieser Person in den Basket sollen -> brauchen wir das? meistenes ist ja sowieso nur eines das zu einem bestimmten Basket passt
    vaultInfo storage vaultid = VaultInfo[_pid];
    for (uint i = 0; i < tokenIds.length; i++) {    // kontrollieren jedes einzelnen NFTs 
      tokenId = tokenIds[i];
      
      //if cause mit tokenID ob eigenschaften zu Basket passen -> oder besser require --> wenn es nicht passt: "NFT doesn't fit with selected basket."  -> video mit mehreren stakes
      require(vaultid.nft.ownerOf(tokenId) == msg.sender, "not your NFT");   // für das brauchen wir mit OWner of die adresse des Owner -> beim NFT smart contract -> oder doch NFT.
      require(vault[tokenId].tokenId == 0, "already in Basket");    // speichert den Besitzer des NFT, damit dieser das eigene NFT wieder zurück bekommen kann. -> brauchen wir eher nicht 
      //require(materialbar == && finessbar ==  &&, "NFT doesn't fit with selected basket")
      NToken = weight;
      for(uint j = 0; j < NToken; j++) {
        vaultid.token.mint();     // kann man minten mit einem anderen Smart Contract sodass es nur ausgelöst wird wenn das NFT wrklich in den Basket gelegt wird -> aussage von Katrin hat mich verwirrt
      }
      
      //macht den Transfer in den vaulet -> NFT wird in den BAsket gelegt
      vaultid.nft.transferFrom(msg.sender, address(this), tokenId);  //macht noch nicht ganz sinn
      emit NFTpacked(msg.sender, tokenId);

      // das ist unser basket
      vault[tokenId] = Basket({
        //owner: msg.sender,
        tokenId: uint24(tokenId)
      
        //timestamp: uint48(block.timestamp)   //das brauchen wir eher nicht, da wir ja keine Zeitstoppen müssen 
      });
    }
    
  }
  

  // should never be used inside of transaction because of gas fee
  function balanceOf(address account) public view returns (uint256) {     //zeigt wie viele NFTs man gestaket hat  -> können wir eher nicht brauchen da die NFTs dann nicht mehr im besitz sind 
  // man könnte stattdessen ein zähler bei der staking funktion einbauen der zählt wie viel man schon in ein Bsket gelegt hat und beim unstaking wie viel wieder entfernt wurde
    uint256 balance = 0;
    vaultInfo storage vaultid = VaultInfo[_pid];
    uint256 supply = vaultid.nft.totalSupply();
    for(uint i = 1; i <= supply; i++) {
      if (vault[i].owner == account) {
        balance += 1;
      }
    }
    return balance;
  }

  // should never be used inside of transaction because of gas fee
 //function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {    // zeigt welche spezifischen Token im Vault sind -> können wir so direkt auch nicht brauchen 

    // der ehemalige besitzer des NFTs besitzt das NFT nicht mehr, man könnte bei der staking funktion ein memory machen in dem alle ehemaligen NFTs ID gespeichert werden 
    //uint256 supply = nft.totalSupply();
    //uint256[] memory tmp = new uint256[](supply);

    //uint256 index = 0;
    //for(uint tokenId = 1; tokenId <= supply; tokenId++) {
      //if (vault[tokenId].owner == account) {
        //tmp[index] = vault[tokenId].tokenId;
        //index +=1;
      //}
    //}

    //uint256[] memory tokens = new uint256[](index);
    //for(uint i = 0; i < index; i++) {
      //tokens[i] = tmp[i];
    //}

    //return tokens;
  //}

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
