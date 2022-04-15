// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;


//import './ERC721.sol';
import './AXNFT.sol';

contract NFTStaking is /*Ownable, IERC721Receiver, ERC721,*/ AXNFT {  
//ich kann AXNFT nicht hinzufügen -> keine Ahnung warum
  struct vaultInfo {
        //ERC721 nft;
        AXNFT nft;
        //N2DRewards token; 
        string name;  //will ich eigentlich nicht ausklammern da eher wichtig, aber ansonsten gibt es eine Warnung
  }

  vaultInfo[] public VaultInfo;
  
  // struct to store a stake's token, owner, and earning values
  struct Basket {
    uint24 tokenId;
   // uint48 timestamp;
   // address owner;
  }

  AXNFT nft;
  //ERC721 nft;
  //N2DRewards token;

  uint256 public totalStaked;
  mapping(uint256 => Basket) public vault; 
  event NFTpacked(address owner, uint256 tokenId/*, uint256 value*/);
  //event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
  //event Claimed(address owner, uint256 amount);

//diese Funktion brauchen wir vielleicht nicht, man kann sowieso nicht einfach eine vault hinzufügen.
//wenn man eine einzelne Funktion von aussen ansprechen kann mit dem entsprechenden Namen reicht das eig. aus
//das basket kontrolliert dann nur noch ob man das richtige ausgewählt hat
//das würde das Ganze einfacher machen. 
function addVault(
        AXNFT _nft,
        //N2DRewards _token,
        string calldata _name
    ) public {
        VaultInfo.push(
            vaultInfo({
                nft: _nft,
                //token: _token,
                name: _name
            })
        );
    }

  function pack(uint256 _pid, uint256 /*calldata*/ tokenId) external {
      //unterschied zwischen external und public view 
    vaultInfo storage vaultid = VaultInfo[_pid];
    
    //require(vaultInfo = /*bestimmte vaultID*/, "not correct vault") //keine gute Idee da man ja nicht sagen kann welche Function verwendet wird ->Lisa
      // kann man funktion package 1 , package 2 nennen sodass Fehlermeldung sinn macht?
    require(vaultid.nft.ownerOf(tokenId) == msg.sender, "not your token");
    require(vault[tokenId].tokenId == 0, 'already staked');
    //string memory URL, string memory aXedrasId, string memory finessbar, uint256 weightbar, string memory provenancebar, string memory materialbar, string memory certificationbar = vaultid.nft.tokendata(tokenId);
    //require(certificationbar == "" && provenancebar == "" && materialbar = "", "not );
      // mit require muss jeder Smart Contract schon alle möglichen Basket beachtet haben.
    
    vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTpacked(msg.sender, tokenId);
    //NToken = weightbar;
    //for(uint j = 0; j < NToken; j++) {
      //vaultid.token.mint();
    //}
    vault[tokenId] = Basket({
    //  owner: msg.sender,
      tokenId: uint24(tokenId)
     // timestamp: uint48(block.timestamp)
    });
    
  }
/*
  function _unstakeMany(address account, uint256[] calldata tokenIds, uint256 _pid) internal {
    uint256 tokenId;
    totalStaked -= tokenIds.length;
    vaultInfo storage vaultid = VaultInfo[_pid];
    for (uint i = 0; i < tokenIds.length; i++) {
      tokenId = tokenIds[i];
      Stake memory staked = vault[tokenId];
      require(staked.owner == msg.sender, "not an owner");

      delete vault[tokenId];
      emit NFTUnstaked(account, tokenId, block.timestamp);
      vaultid.nft.transferFrom(address(this), account, tokenId);
    }
  }

  function claim(uint256[] calldata tokenIds, uint256 _pid) external {
      _claim(msg.sender, tokenIds, _pid, false);
  }

  function claimForAddress(address account, uint256[] calldata tokenIds, uint256 _pid) external {
      _claim(account, tokenIds, _pid, false);
  }

  function unstake(uint256[] calldata tokenIds, uint256 _pid) external {
      _claim(msg.sender, tokenIds, _pid, true);
  }

  function _claim(address account, uint256[] calldata tokenIds, uint256 _pid, bool _unstake) internal {
    uint256 tokenId;
    uint256 earned = 0;
    vaultInfo storage vaultid = VaultInfo[_pid];
    for (uint i = 0; i < tokenIds.length; i++) {
      tokenId = tokenIds[i];
      Stake memory staked = vault[tokenId];
      require(staked.owner == account, "not an owner");
      uint256 stakedAt = staked.timestamp;
      earned += 100000 ether * (block.timestamp - stakedAt) / 1 days;
      vault[tokenId] = Stake({
        owner: account,
        tokenId: uint24(tokenId),
        timestamp: uint48(block.timestamp)
      });

    }
    if (earned > 0) {
      earned = earned / 10;
      vaultid.token.mint(account, earned);
    }
    if (_unstake) {
      _unstakeMany(account, tokenIds, _pid);
    }
    emit Claimed(account, earned);
  }

  function earningInfo(uint256[] calldata tokenIds) external view returns (uint256[2] memory info) {
     uint256 tokenId;
     uint256 totalScore = 0;
     uint256 earned = 0;
      Stake memory staked = vault[tokenId];
      uint256 stakedAt = staked.timestamp;
      earned += 100000 ether * (block.timestamp - stakedAt) / 1 days;
    uint256 earnRatePerSecond = totalScore * 1 ether / 1 days;
    earnRatePerSecond = earnRatePerSecond / 100000;
    // earned, earnRatePerSecond
    return [earned, earnRatePerSecond];
  }*/
/*
  // should never be used inside of transaction because of gas fee
  function balanceOf(address account,uint256 _pid) public view returns (uint256) {
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
  function tokensOfOwner(address account, uint256 _pid) public view returns (uint256[] memory ownerTokens) {
    vaultInfo storage vaultid = VaultInfo[_pid];
    uint256 supply = vaultid.nft.totalSupply();
    uint256[] memory tmp = new uint256[](supply);

    uint256 index = 0;
    for(uint tokenId = 1; tokenId <= supply; tokenId++) {
      if (vault[tokenId].owner == account) {
        tmp[index] = vault[tokenId].tokenId;
        index +=1;
      }
    }

    uint256[] memory tokens = new uint256[](index);
    for(uint i = 0; i < index; i++) {
      tokens[i] = tmp[i];
    }

    return tokens;
  }
*/
 /* function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
      require(from == address(0x0), "Cannot send nfts to Vault directly");
      //return IERC721Receiver.onERC721Received.selector;
    }
  */
}
