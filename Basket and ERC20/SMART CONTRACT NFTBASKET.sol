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
    uint24 tokenId;
  }

   
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

    basket_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId)
    });
    
  }

}
