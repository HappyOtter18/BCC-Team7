// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import './minting.sol';
//import './AXNFT.sol';

interface DataInterface {
  function tokendata(uint256 _tokenId) external view returns (
    string memory, 
    string memory, 
    string memory, 
    uint256, 
    string memory, 
    string memory, 
    string memory
  ); 
}


contract NFTBasket is minting {  
  
  DataInterface NFTContract;
  minting token;

  constructor (address AXNFT) { 
    NFTContract = DataInterface(AXNFT);
    
    //token = _token;
  }

  struct Basket_1 {
    uint256 tokenId;
    uint256 totalinBasket;
    uint256 totalmintToken;
  }

  uint256 public totalmintToken = 0;
  uint256 public totalinBasket = 0;
  mapping(uint256 => Basket_1) public basket_1; 
  event NFTpacked(address owner, uint256 tokenId);
  

  function packing_Basket_1(uint256 tokenId, address _to) public {
    
    //require(nft.ownerOf(tokenId) == msg.sender, "not your token"); //nicht der sender -> da das axedras ist -> oder gehört das NFT nun kurzfrisit aXedras
    require(basket_1[tokenId].tokenId == 0, 'already staked');
    string memory URL;
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
    string memory a = "Available";
    string memory r = "Recycled";
    require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((certificationbar))), "Not the right basket.");
    require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((provenancebar))), "Not the right basket.");
    require(keccak256(abi.encodePacked((r))) == keccak256(abi.encodePacked((materialbar))) , "Not the right basket."); 
    //NFTContract.transferFrom(msg.sender, address(this), tokenId);
    totalinBasket = totalinBasket + 1;
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    token.mint(_to, NToken);
    totalmintToken = totalmintToken +1;

    basket_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId),
      totalinBasket: uint256(totalinBasket),
      totalmintToken: uint256(totalmintToken)
    });
    
  }
  function unpack_NFT(address from, uint256 amount) public {
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    for (uint i = 0; i < totalinBasket; i++) {
      if (uint24(basket_1[i].tokenId) == uint24) {
        uint24 tokenId = uint24(basket_1[i].tokenId);
        (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
        if (weightbar <= amount) {
          token.transfer(from,  this,  weightbar);
          amount = amount - weightbar;
          //AXNFT._transfer(this,  from, tokenId);
          delete basket_1[tokenId];
        }
      }
    }
  }
}
