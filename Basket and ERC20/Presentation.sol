// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;


//import './ERC20.sol';
import './AXNFT.sol';

contract NFTStaking is  AXNFT {  

//braucht es wirklich beide structs?
  struct vaultInfo {
        AXNFT nft;
        string name;  //will ich eigentlich nicht ausklammern da eher wichtig, aber ansonsten gibt es eine Warnung
  }

  vaultInfo[] public VaultInfo;
   
  // struct to store a stake's token, owner, and earning values
  struct Basket_1 {
    uint24 tokenId;
   
  }

  AXNFT nft;
  //ERC20 token; 

  uint256  weightbar = 10000;
  uint256 public totalStaked;
  mapping(uint256 => Basket_1) public vault_1; 
  event NFTpacked(address owner, uint256 tokenId);
  

  function packing_Basket_1(uint256 _pid, uint256 tokenId) public {
    
    require(vaultid.nft.ownerOf(tokenId) == msg.sender, "not your token");
    require(vault_1[tokenId].tokenId == 0, "already staked");
    //var (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = vaultid.nft.tokendata(tokenId);
    //require(certificationbar == "" && provenancebar == "" && materialbar = "", "Not the right basket.);
    
    vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    //vaultid.token.mint(address(this), NToken);
    
    vault_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId)
    });
    
  }
}
