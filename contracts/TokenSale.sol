pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

import './CommunityCoin.sol';

contract TokenSale is CappedCrowdsale, FinalizableCrowdsale {

    using SafeMath for uint;

    uint constant private _unit  =  10 ** 18;
    address constant private w= 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;

    event WalletChanged(address _wallet);

    function TokenSale(uint _rate,uint _cap)
    Crowdsale(now, now + 30 minutes,_rate,w)
    CappedCrowdsale(_cap.mul(_unit)) public {
    }

    function setToken(address tokenAddress) onlyOwner public {
        token = CommunityCoin(tokenAddress);
    }

     function transferToken(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    token.transferOwnership(newOwner);
  }
    function setWallet(address _wallet) {
        wallet = _wallet;
        WalletChanged(_wallet);
    }

    function remainToken() view public returns(uint) {
        return (cap - weiRaised).mul(rate);
    }

    function finalization() internal {
        transferToken(msg.sender);
    }
}
