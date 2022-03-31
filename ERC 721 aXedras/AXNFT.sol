// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import './connector.sol';

contract NFTaXedras is connector {

//initialize this contract to inherit name and symbol form erc721metadata so that the name is goldnft and the symbol is AXNFT
    constructor () connector("GoldNFT", "AXNFT") {

    }


}