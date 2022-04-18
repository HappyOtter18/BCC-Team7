// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;


import './ERC721.sol';
import './AXNFT.sol';

contract NFTStaking is  AXNFT {  

//braucht es wirklich beide structs?
  struct vaultInfo {
        AXNFT nft;
        string name;  //will ich eigentlich nicht ausklammern da eher wichtig, aber ansonsten gibt es eine Warnung
  }

  vaultInfo[] public VaultInfo;
   
  // struct to store a stake's token, owner, and earning values
  struct Basket {
    uint24 tokenId;
   
  }

  AXNFT nft; 
   
  uint256 public totalStaked;
  mapping(uint256 => Basket) public vault; 
  event NFTpacked(address owner, uint256 tokenId);
  

  function packing_Basket_1(uint256 _pid, uint256 /*calldata*/ tokenId) public {
      //unterschied zwischen external und public view 
    vaultInfo storage vaultid = VaultInfo[_pid]; //ist das wirklich nötig?
  
      // kann man funktion package 1 , package 2 nennen sodass Fehlermeldung sinn macht?
    require(vaultid.nft.ownerOf(tokenId) == msg.sender, "not your token");
    require(vault[tokenId].tokenId == 0, 'already staked');
    //var (string memory URL, string memory aXedrasId, string memory finessbar, uint256 weightbar, string memory provenancebar, string memory materialbar, string memory certificationbar) = vaultid.nft.tokendata(tokenId);
    //var (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = vaultid.nft.tokendata(tokenId);

    //require(certificationbar == "" && provenancebar == "" && materialbar = "", "Not the right basket.);
      // mit require muss jeder Smart Contract schon alle möglichen Basket beachtet haben.
    
    vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTpacked(msg.sender, tokenId);
    //NToken = weightbar;
      //uint j = 0; j < NToken; j++) {
      //vaultid.token.mint();
    //}
    vault[tokenId] = Basket({
      tokenId: uint24(tokenId)
    });
    
  }
}
