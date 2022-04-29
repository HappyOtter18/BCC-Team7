pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract minting is ERC20 {

    constructor() ERC20("Basket_1_token", "B1") { }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

}

