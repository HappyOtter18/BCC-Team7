// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract ERC20 is NFTBasket {

  mapping(address => bool) controllers;   // um ändern zu können wer der controller ist
  
  constructor() ERC20("ERC20", "N2DR") { }   // N2DR so wird das Token genannt

  function mint(address to, uint256 amount) external {    // extern because we calling it from an other contract
    require(controllers[msg.sender], "Only controllers can mint");
    _mint(to, amount);
  }

// wichtig für uns -> so können wir die Token zerstören, die wieder zum smart Contract kommen. Wenn man Token für ein NFT eintauschen will -> wollen wir das diese Funktion existiert?
// hier burnt aber nur der COntroller, sprich der andere Smart Contract -> bei uns sollte das automatisch gehen

function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }
  
  //braucht man um den COntroller zu tauschen -> brauchen wir eher nicht da wir ihn nicht tauschen möchten
   function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }
}
