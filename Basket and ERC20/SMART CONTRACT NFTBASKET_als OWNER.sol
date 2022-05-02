// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import './minting_1.sol';

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

  function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external virtual;

  function ownerOf(uint256 tokenId) external virtual view returns (address);

  function approve(address to, uint256 tokenId) external virtual;
}


contract NFTBasket is minting_1 {  
  
  DataInterface NFTContract;
  minting_1 token;

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
  

  function packing_Basket_1(uint256 tokenId) public {
    require(NFTContract.ownerOf(tokenId) == msg.sender, "not your token"); //nicht der sender -> da das axedras ist -> oder gehört das NFT nun kurzfrisit aXedras
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
    NFTContract.approve(msg.sender, tokenId); // nicht klar ob korrekt
    NFTContract.transferFrom(msg.sender, address(this), tokenId);
    totalinBasket = totalinBasket + 1;
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    token.mint(msg.sender, NToken);
    totalmintToken = totalmintToken + NToken;

    basket_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId),
      totalinBasket: uint256(totalinBasket),
      totalmintToken: uint256(totalmintToken)
    });
  }

  
  function unpack_NFT(uint256 amount) public {
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    while(0 < amount){
      for (uint i = 0; i < totalinBasket; i++) {
        uint24 tokenId = uint24(basket_1[i].tokenId);
        (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
        if (weightbar <= amount) {
          //token.approvemint(from, weightbar); //ist ein boolean
          token.transferto(msg.sender, address(this), weightbar);
          token.burnToken(address(this), weightbar);
          amount = amount - weightbar;
          NFTContract.transferFrom(address(this), msg.sender, tokenId);
          delete basket_1[tokenId];
        }
      }
    }
  }


  //https://ethereum.stackexchange.com/questions/7317/how-can-i-return-struct-when-function-is-called
  function showNFT() public view returns(string memory, string memory, string memory, uint256, string memory, string memory, string memory) {
    string memory output="";
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    for (uint i = 0; i < totalinBasket; i++) {
        output = string(abi.encodePacked(output,"[", basket_1[i].tokenId, ",", basket_1[i].totalinBasket, ",", basket_1[i].totalmintToken, ",""]"));
        uint tokenId = basket_1[i].tokenId;
        (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
    }
  return (output, URL, finessbar, weightbar, provenancebar, materialbar, certificationbar);
  }

  function get_specificNFT(uint tokenId, uint amount) public {
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
    uint weight = weightbar;
    require(weight<=amount, "not enough token");
    //token.approvemint(msg.sender, weightbar); //ist ein boolean
    token.transferto(msg.sender, address(this), weightbar);
    token.burnToken(address(this), amount);
    NFTContract.transferFrom(address(this),  msg.sender, tokenId);
    delete basket_1[tokenId];
  }

}

