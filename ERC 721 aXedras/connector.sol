// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import './metadata.sol';
//import "./ERC721.sol";
import "./enumerable.sol";

contract connector is metadata, enumerable {

    //we deploy connector right away, we want to carry the metadata info ower
    constructor(string memory name, string memory symbol) metadata(name, symbol){

    }
// that way, the name and symbol of meta data is added



}