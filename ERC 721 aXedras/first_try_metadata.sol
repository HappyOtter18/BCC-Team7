// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract metadata{

    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symbolified){
        _name = named;
        _symbol = symbolified;
    }
    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

}
