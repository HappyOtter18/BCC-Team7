// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract minting_1 is ERC20, ERC20Burnable {

    constructor() ERC20("Basket_1_token", "B1") { }

    function mint(address to, uint256 amount) internal virtual {
        _mint(to, amount);
    }

    function transferto(address sender, address recipient, uint256 amount) internal virtual {
        transferFrom(sender, recipient, amount);
    }

    function burnToken(uint256 amount) internal virtual {
        burn(amount);
    }
    function burnfrom(address account, uint256 amount)internal virtual {
        burnFrom(account, amount);
    }

}

