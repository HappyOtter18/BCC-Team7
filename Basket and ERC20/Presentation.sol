function packing_Basket_1(uint256 _pid, uint256 /*calldata*/ tokenId) public {
      //unterschied zwischen external und public view 
    vaultInfo storage vaultid = VaultInfo[_pid]; //ist das wirklich nötig?
    
    //require(vaultInfo = /*bestimmte vaultID*/, "not correct vault") //keine gute Idee da man ja nicht sagen kann welche Function verwendet wird ->Lisa
      // kann man funktion package 1 , package 2 nennen sodass Fehlermeldung sinn macht?
    require(vaultid.nft.ownerOf(tokenId) == msg.sender, "not your token");
    require(vault[tokenId].tokenId == 0, 'already staked');
    //var (string memory URL, string memory aXedrasId, string memory finessbar, uint256 weightbar, string memory provenancebar, string memory materialbar, string memory certificationbar) = vaultid.nft.tokendata(tokenId);
    //var (URL, aXedrasId, finessbar, weightbar, provenancebar, materialbar, certificationbar) = vaultid.nft.tokendata(tokenId);

    //require(certificationbar == "" && provenancebar == "" && materialbar = "", "not  );
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
