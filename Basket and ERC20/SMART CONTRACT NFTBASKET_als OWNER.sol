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
    ) external;

  function ownerOf(uint256 tokenId) external view returns (address);

  function approve(address to, uint256 tokenId) external;
}


contract NFTBasket is minting_1 {  
  
  DataInterface NFTContract;
  //minting_1 token;

  constructor (address AXNFT) { 
    NFTContract = DataInterface(AXNFT);
    //token = _token;
  }

  struct Basket_1 {
    uint256 tokenId;
    uint256 totalinBasket;
    uint256 totalmintToken;
    uint256 weightbar;
    string aXedrasId;
    string finessbar;
    string URL;
  }

  uint[] public basket_1_array;  //makes Array 

  function addNFTtoArray(uint256 tokenId) private {  //funciton to extend array
    basket_1_array.push(tokenId);
  }

  function lengthofArray()public view returns (uint){  //funciton to get the length of array
    return basket_1_array.length;
  }


//initializes the variables
  uint256 public totalmintToken = 0;  
  uint256 public totalinBasket = 0;
  mapping(uint256 => Basket_1) public basket_1; //maps the struct
  event NFTpacked(address owner, uint256 tokenId);
  

  function packing_Basket_1(uint256 tokenId) public {
    require(NFTContract.ownerOf(tokenId) == msg.sender, "not your token"); 
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
    NFTContract.transferFrom(msg.sender, address(this), tokenId);
    totalinBasket = totalinBasket + 1;
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    mint(msg.sender, NToken);
    totalmintToken = totalmintToken + NToken;
    addNFTtoArray(tokenId);  //add to the array
 
    basket_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId),
      totalinBasket: uint256(totalinBasket),
      totalmintToken: uint256(totalmintToken),
      weightbar: uint256(weightbar),
      finessbar: string(finessbar),
      URL: string(URL),
      aXedrasId: string(aXedrasId)
    });
  }

  function remove(uint tokenId) private{
    basket_1_array[tokenId] = basket_1_array[basket_1_array.length - 1];
    basket_1_array.pop();
  }

  
  function unpack_NFT(uint256 amount) public {
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    require(amount >= 0, "not enough token");
    while(amount >= 0){
      for (uint i = 0; i < basket_1_array.length; i++) {
        uint24 tokenId = uint24(basket_1_array[i]);
        (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
        if (weightbar <= amount) {
          burnToken(weightbar);
          amount = amount - weightbar;
          NFTContract.transferFrom(address(this), msg.sender, tokenId); 
          delete basket_1[tokenId];
          remove(tokenId);
          totalinBasket= totalinBasket-1;
          totalmintToken = totalmintToken-weightbar;
        }
      }
    }
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
    burnToken(weight);
    NFTContract.transferFrom(address(this),  msg.sender, tokenId);
    delete basket_1[tokenId];
    remove(tokenId);
    totalinBasket= totalinBasket-1;
    totalmintToken = totalmintToken-weightbar;
  }

}
