// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

// This is the contract with the standards and the mint funtion

contract ERC721 {
    // we can see the logs of people that are minting
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); //to show data, it creates a log
    //index --> to search in the list

    //Event for approval 
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    // Emitted when owner enables or disables (approved) operator to manage all of its assets.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // Mapping --> hash table of key pair values 
    // Mapping from token id to the owner --> keep track how many token a token adress has 
    mapping (uint => address) private _tokenOwner;

    //mapping form owner to number of owned tokend (keep track of token owner addresses to token ids)
    mapping (address => uint) private _OwnedTokensCount;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // SIMILAR TO BALANCE OF --> Integer and spinning out an adress (not integer from adress)
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns (address){
        address owner = _tokenOwner[_tokenId]; 
        require(owner != address(0), "This is a non existent Token"); //make sure the owner address is valid
        return owner; //returns an address
    }
    
    //Function that check if a token already exist 
    //Only internal
    function _exists(uint256 tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId]; //setting the address of NFT owner to check the mapping of the address from token Owner at the token Id
        return owner != address(0); //Is the adress 0, true or false
    }
    
    /*
    Here is the _mint function built. To create NFT. The essentials of the minting function:
        So we need the nft to point to an adress 
        Keep track of the Token Id 
        Keep track of token owner addresses to token ids
        keep track of how many tokens an owner address has
        Events that emits a transfer log - contract address, where it is being minted to, the id
    */
//Everybody can come and mint their own NFT
//We call the function in the AXNFT contract
/// We mark it as virtual, we override it in the enumerable contract 
    function _mint(address to, uint256 tokenId) internal virtual {
        //require that the adress is not 0 and the token doesn't already exist
        require(to != address(0), "ERC721: no minting address");
        require(!_exists(tokenId), "Token already minted"); //make sure that the minted Id doesn't exist. 
        //add the new adress with a token id for minting
        _tokenOwner[tokenId] =to;
        //How many token own each address? 
        _OwnedTokensCount[to] +=1;

        emit Transfer(address(0), to, tokenId);
        //address 0, default address
    }
    // COMMENTS OF THE NFT ETHEREUM PAGE
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    // We want to check the balance of the owners, we make it public, view a return, it return the balance (uint)
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "This is a non existent query");
        return _OwnedTokensCount[_owner];
    }


    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_from != address(0), "this address doesn't exist");
        require(_to != address(0), "this address doesn't exist");
        require(ERC721.ownerOf(_tokenId) == _from, "This Token ID doesn't belongs to this address");
        _OwnedTokensCount[_from] -= 1; 
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

        /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function _getApproved(uint256 _tokenId) public view virtual returns (address) {
        require(_exists(_tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[_tokenId];
    }


    // 1. require that the person approving is the owner 
    // 2. approve an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner 
    // 4. Update the map of the approval addresses 
    function approve(address _to, uint256 tokenId) public payable {
        address owner = ERC721.ownerOf(tokenId);
        require(_to != owner, "Error - approval to current owner");
        require(msg.sender == owner, "current caller is not the owner of the token");
        _tokenApprovals[tokenId] = _to; // so that nobody emit without approval
        emit Approval(owner, _to, tokenId);
    }

    // function has been approved or it is the owner
    function isApprovedOrOwner(address spender, uint256 tokenId) public view returns(bool){
        require(_exists(tokenId), "token doesn't exist");
        address owner = ERC721.ownerOf(tokenId); 
        return(spender == owner || _getApproved(tokenId)==spender); //the spender has to be the owner, check
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function _setApprovalForAll(address _owner, address _operator, bool _approved) internal virtual {
        require(_owner != _operator, "ERC721: approve to caller");
        _operatorApprovals[_owner][_operator] = _approved;
        emit ApprovalForAll(_owner, _operator, _approved);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
        return _operatorApprovals[_owner][_operator];
    }

// There is still the function Transfer, safeTransfer, safeTransfer (2) 

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        // _beforeTokenTransfer(from, to, tokenId); That is a hook, maybe an implementation later will follow
        // Clear approvals from the previous owner
        approve(address(0), tokenId);
        _OwnedTokensCount[from] -= 1;
        _OwnedTokensCount[to] += 1;
        _tokenOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);

        //_afterTokenTransfer(from, to, tokenId);
    }

    // This internal function is equivalent to {safeTransferFrom}, and can be used to e.g. implement alternative mechanisms to perform token transfer, such as signature-based.
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        //////// require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
 

/// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable{
        require(ERC721.isApprovedOrOwner(msg.sender, _tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(_from, _to, _tokenId, _data);
    }
        

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function burn(uint256 tokenId) public virtual {
        address owner = ERC721.ownerOf(tokenId);

        // Clear approvals
        approve(address(0), tokenId);

        _OwnedTokensCount[owner] -= 1;
        delete _tokenOwner[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

}
