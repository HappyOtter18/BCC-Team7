// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;

// This is the Basket Smart Contract to place an NFT directly, as owner, into the Basket.
//In addition, you can also use it to get the NFT out again by handing over tokens.


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import './minting_1.sol';

//interface to get the functions of the AXNFT Smart Contract
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

//NFT Basket Smart Contract inherit from the Smart Contract minting_1
contract NFTBasket is minting_1 {  
  
  DataInterface NFTContract;
  

  constructor (address AXNFT) { //so that we can use always the current address 
    NFTContract = DataInterface(AXNFT);
    
  }

//struct so that we can see what the data of the NFTs is. 
//I used only this data because the other data is already a criterium for the basket
// and with all the data it would be to large.
  struct Basket_1 {    
    uint256 tokenId;
    uint256 totalinBasket;
    uint256 totalmintToken;
    uint256 weightbar;
    string aXedrasId;
    string finessbar;
    string URL;
  }

  uint[] public basket_1_array;  //makes Array, so we can easily iterate,
  //and see how many nfts are in the basket and what NFTs are in the Baskets

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
  
//the main function of the smart contract 
//it takes a NFT, controlls if it is a right one ande pack it into the Basket 1
//Then it sends per gramm of weight a token to the owner of the NFT
//befor that you must give a approve to the Smart Contract because it controls about that 
//and the smart contract becomes the owner inside of the transferFrom funciton
  function packing_Basket_1(uint256 tokenId) public {
    require(NFTContract.ownerOf(tokenId) == msg.sender, "not your token"); 
    require(basket_1[tokenId].tokenId == 0, 'already staked');
    //initialize the variables
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
    //controlls if it is the right basket
    require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((certificationbar))), "Not the right basket.");
    require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((provenancebar))), "Not the right basket.");
    require(keccak256(abi.encodePacked((r))) == keccak256(abi.encodePacked((materialbar))) , "Not the right basket."); 
    NFTContract.transferFrom(msg.sender, address(this), tokenId); //sending the NFT
    totalinBasket = totalinBasket + 1; //to know how many NFTs are in the Basket
    emit NFTpacked(msg.sender, tokenId);
    uint256 NToken = weightbar;
    mint(msg.sender, NToken);
    totalmintToken = totalmintToken + NToken; //to know how many token are circulating
    addNFTtoArray(tokenId);  //add to the array
 
    basket_1[tokenId] = Basket_1({  //actualize the struct: what exactly is in the Basket
      tokenId: uint24(tokenId),
      totalinBasket: uint256(totalinBasket),
      totalmintToken: uint256(totalmintToken),
      weightbar: uint256(weightbar),
      finessbar: string(finessbar),
      URL: string(URL),
      aXedrasId: string(aXedrasId)
    });
  }


  //funcion to remove the now empty index of the array
  function remove(uint tokenId) private{
    basket_1_array[tokenId] = basket_1_array[basket_1_array.length - 1];
    basket_1_array.pop();
  }


  // funciton to get a NFT or various NFTs from the basket for a specific amount of Token
  function unpack_NFT(uint256 amount) public {
    //initialize the variables
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    string memory URL;
    require(amount >= 0, "not enough token");
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


  //function to get the NFT from the basket with a specific Token Id
  function get_specificNFT(uint tokenId, uint amount) public {
    //initialize the variables
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

