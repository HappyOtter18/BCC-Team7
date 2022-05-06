# BCC-Team7

This is a university project in the framework of the Blockchain challenge. 

Our project is to tokenize gold in order to trade it afterwards on the blockchain. The branding name is aXSolution. 

![aXSolution (mit Titel)](https://user-images.githubusercontent.com/95071880/167140430-79a812ca-a102-4a1d-bb29-660572c899e2.png)


For reasons of anonymity, the company for which the project is being developed is referred to as "the company" below.

## The first part of our solution

First, if a stakeholder of the responsible company such as an asset manager, has gold to trade on the blockchain, 
he must request this to a registered custodian. The custodian verifies the existence of the physical gold. Now, the custodian requests the NFT minting to the company 
over a dedicated website and send the information about the gold that is going to be minted. Then, the company interacts with the smart contract that will mint the requested NFT. 
Legally, the stakeholder owns the NFT, he can sell it directly if he finds an OTC partner. 

<img width="766" alt="Capture d’écran 2022-05-06 à 15 30 11" src="https://user-images.githubusercontent.com/95071880/167141337-6f45c607-ce14-4325-a20d-444080874656.png">

This is the first part of the projet which smart contract is in the folder NFT721.

![erc721](https://user-images.githubusercontent.com/95071880/167143951-02a9835d-d725-428f-8d4f-3ed9ded0d6ce.png)

The final contract is called "SMART_CONTRACT_AXNFT". There is a standard of Openzeppelin which is widely used, widespread and available as open source. This standard was used for the final contract to avoid errors and inefficiencies in the code. 

However, before only taking the standard and implement it as such, it was tried to understand it. The NFT smart contract was then deployed from scratch. 

The NFT contract is broken down into 5 sub-contracts, in order to have a better visibility. 

1. AXNFT
This is the main contract, the one to be deployed to make all the contracts work 
The mint function is programmed to add metadata in each token
There is also a function to see the metadata depending on the token id
A function to burn tokens is also implemented
All the caracteristics about the gold, URL, Company's unique ID, the metal, the weight, the finesse, the origin, the material (new, recycled or mixture), the certification (e.g., LBMA) are stored at the beginning of the contract. 

By minting the token, specific information about the underlying gold bar must be provided. In the code, these are stored as follow: 

```
    string[] private AXNFTz;
    string[] private aXUniqueId;
    string[] private finess;
    uint256[] private weight;
    string[] private provenance;
    string[] private material;
    string[] private certification;


2. Connector 
This is the contract that links all the sub-contracts together. This is for ease of use

3. Metadata
The basic information needed to deploy the NFT contract is stored here. 

4. ERC721
This contract implements the function to mint tokens but also all necessary standard functions of the ERC-721. 

5. Enumerable
This contract keeps track of all the NFTs, so we can know what all the supply is, who has which token, etc... 
The is a old and a new version of the enumerable contract. The old version was programmed from scratch, this incurred errors and was not very stable. 
The version "new" use simply the OpenZeppelin standard and the whole was adapted to our code.

![image](https://user-images.githubusercontent.com/95071880/167144501-ac49e562-a675-4480-88b2-542aadb858e9.png)


## The second part of the solution

If he wishes, the stakeholder can notify again his custodian, who can give aX-edras a basketing request. The responsible company puts the NFT into a basket, now the stake-holder gets ERC-20 Tokens through 
the custodian and has no access to the NFT anymore. The basket was divided into small parts, and each part corresponds to an ERC-20 token which can easily be exchanged and is very fungible. 
A NFT, which represent a gold bar, will be transformed in many ERC-20 tokens, as one token represent one gram gold. But this one gram is not attributable to a specific gold bar but it is a part. 
of the whole basket. The investor could therefore invest in the company's labelled gold in the form of a token. In a nutshell, the baskets group together NFTs of similar characteristics 
and issue ERC20 tokens which are easily exchangeable by their compliance with the standard. 

<img width="841" alt="Capture d’écran 2022-05-06 à 15 31 58" src="https://user-images.githubusercontent.com/95071880/167141542-09e1ac23-bbc9-471f-8bac-11904a367743.png">

The smart contract corresponding to this part of the solution can be found in the second folder "Basket and ERC20". 

![folder copie](https://user-images.githubusercontent.com/95071880/167143814-1e308703-7c8d-4c5f-8533-890ffa255439.png)

The contracts to be studied are those starting with "SMART CONTRACT". The other contracts are trials that could not be implemented. 

The second part of the solution is made out of two sub-smart contracts. For each basket which all start with the name "NFTBasket" and "minting". For example, there is one smart contract called NFTBasket_1 and one called minting_1. For our solution we use the "SMART CONTRACT NFTBASKET_1.sol" and the "SMART CONTRACT minting_1.sol". The "SMART CONTRACT NFTBASKET_als OWNER.sol" can be used, if you want directly put an NFT in the Basket, but our solution doesn't need it. For creating the other baskets, you would have to change the number of all the names, e.g. from 1 to 2 and so on. And additionally, you would have to change the input of the constructor of the minting smart contract.

The minting smart contract uses the functions of the ERC-20 smart contract from openzeppelin to mint or burn the tokens.  
The NFTBasket smart contract combines the different functions. It contains a structure, a mapping, a function to put the NFT into the basket, and two functions to get an NFT out by surrendering the respective tradable tokens. With the "unpack_NFT_1" function, you can simply enter the amount of tokens you want to exchange and it will give you NFTs corresponding to that amount. With the "get_specificNFT_1" function, you can choose which NFT you want and therefore you have to enter both, the amount of tokens and the ID of the NFT. If the quantity is correct, you then get the specific NFT in return for the tokens. In addition to these functions, an array is also created to better iterate and to better see what NFTs are in the basket. The Array and the functions are also named after the respective basket number. 

With the NFTBasket function, aXedras can put the NFT as input into the respective basket by entering the tokenID and the owner's address. The NFT is then stored and held in the smart contract. In return, the owner receives one token per gram of weight of the gold bar. He can then exchange these tokens again for an NFT. In order for aXedras to be able to do this, the owner must first allow both aXedras and the smart contract with "approve".

![image](https://user-images.githubusercontent.com/95409842/167159851-83e18de2-86cc-4b54-8ac2-6e0392b10577.png)


