// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import './metadata.sol';

contract connector is metadata {

    //we deploy connector right away, we want to carry the metadata info ower
    constructor(string memory name, string memory symbol) metadata(name, symbol){

    }
// that way, the name and symbol of meta data is added



}