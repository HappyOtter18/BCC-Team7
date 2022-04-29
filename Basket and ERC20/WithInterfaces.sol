pragma solidity >=0.5.0 <0.6.0;
/*// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;
*/

//import './ERC20.sol';
//import './connector.sol';

contract DataInterface {
    function tokendata(uint256 _tokenId) public view returns (
      string memory, 
      string memory, 
      string memory, 
      uint256, 
      string memory, 
      string memory, 
      string memory
    );
}


contract NFTStaking is  connector/*, ERC20 */{  
  address DataInterfaceAddress = 0xd9145CCE52D386f254917e481eB44e9943F39138;
  DataInterface NFTContract = DataInterface(DataInterfaceAddress);

  connector nft;

  constructor(connector _nft /*, ERC20 _token*/) { 
    nft = _nft;
    //token = _token;
  }


 
  struct Basket_1 {
    uint24 tokenId;
  }

   

  //uint256 public totalStaked;
  //mapping(uint256 => Basket_1) public basket_1; 
  event NFTpacked(address owner, uint256 tokenId);
   

  function packing_Basket_1(uint256 _pid, uint256 /*calldata*/ tokenId) public {

    //require(nft.ownerOf(tokenId) == msg.sender, "not your token"); //nicht der sender -> da das axedras ist -> oder gehört das NFT nun kurzfrisit aXedras
    //require(basket_1[tokenId].tokenId == 0, 'already staked');
    string memory URL;
    string memory aXedrasId;
    string memory finessbar;
    uint256 weightbar;
    string memory provenancebar;
    string memory materialbar;
    string memory certificationbar;
    (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = NFTContract.tokendata(tokenId);
    
    //require(certificationbar == "Available" && provenancebar == "Available" && materialbar = "Recycled", "Not the right basket.);
    
    //nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTpacked(msg.sender, tokenId);
    //uint256 NToken = weightbar;
    //token.mint(msg.sender, NToken);
/*
    basket_1[tokenId] = Basket_1({
      tokenId: uint24(tokenId)
    });
    */
  }
}
