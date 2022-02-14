pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale,CappedCrowdsale,TimedCrowdsale,RefundablePostDeliveryCrowdsale { 

    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        KaseiCoin token ,// the KC_Token itself that the KC_TokenSale will work with
        uint goal ,//represents he amount of ether which you hope to raise
        uint open, //represent the opening time for the crowdsale
        uint close //represent the closing time for the crowdsale
    ) public Crowdsale(rate, wallet, token)
            CappedCrowdsale(goal)
            TimedCrowdsale(open, close)
            RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}

contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
       string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all Ether raised by the sale
        uint goal,
        uint now
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin kaseiCoin = new KaseiCoin(name, symbol, 0);

        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address (kaseiCoin);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kaseiCoinCrowdsale = new KaseiCoinCrowdsale(1, wallet, kaseiCoin,
            goal, now, now + 5 minutes);

        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseiCoinCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        kaseiCoin.addMinter(kasei_crowdsale_address);

        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        kaseiCoin.renounceMinter();
    }
}


