pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol';

import './CommunityCoin.sol';

contract TokenSale is CappedCrowdsale, FinalizableCrowdsale {

CommunityCoin public token;
    uint constant private r = 8000 * 10 ** 27;
    uint constant private c = 12000 * 10 ** 27;
    address constant private w= 0x12c752AA48A18a7409C23363c2E85443f24F149A;

    function TokenSale()
    Crowdsale(now, now + 30 minutes,r,w)
    CappedCrowdsale(c) public{

    }

    function setToken(address tokenAddress) onlyOwner public {
        token = CommunityCoin(tokenAddress);
    }

     function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    token.transferOwnership(newOwner);
    super.transferOwnership(newOwner);
  }
}
