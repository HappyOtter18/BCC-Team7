// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

//import "./NFTBasket";


contract ERC20 {

event Transfer(address indexed _from, address indexed _to, uint256 _value);

event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  //mapping(address => bool) controllers;   // um ändern zu können wer der controller ist
  
constructor() ERC20("ERC20", "N2DR") { }   // N2DR so wird das Token genannt

  function mint(address to, uint256 amount) external {    // extern because we calling it from an other contract
   // require(controllers[msg.sender], "Only controllers can mint");
    _mint(to, amount);
  }
  
  function name() public view returns (string) {}
  
  function symbol() public view returns (string) {}
  
  //function decimals() public view returns (uint8)
  
  function balanceOf(address _owner) public view returns (uint256 balance) {}
  
  function transfer(address _to, uint256 _value) public returns (bool success) {}
  
  function totalSupply() public view returns (uint256) {}
  
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
  
  function approve(address _spender, uint256 _value) public returns (bool success) {}
  
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}

}
