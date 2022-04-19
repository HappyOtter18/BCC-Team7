// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;


//import './ERC20.sol';
import './AXNFT.sol';

contract NFTBasket  is  AXNFT {  
  
  // struct to store a stake's token, owner, and earning values
  struct aXological {
    uint24 tokenId;  
  }

  AXNFT nft;
  //ERC20 token; 

  uint256  weightbar = 10000; // solange wir nch nicht die Angaben verwenden können. 
  uint256 public totalStaked;
  mapping(uint256 => aXological) public aXological; 
  event NFTpacked(address owner, uint256 tokenId);
  

  function packing_aXological(uint256 _pid, uint256 tokenId) public { 
    require(nft.ownerOf(tokenId) == msg.sender, "not your NFT");
    require(vault_1[tokenId].tokenId == 0, "already in Basket");
    var (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = vaultid.nft.tokendata(tokenId);
    require(certificationbar == "" && provenancebar == "" && materialbar = "", "Not the right basket.);
    
    nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    token.mint(msg.sender, NToken);
    
    vault_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId)
    });
    
  }
}
