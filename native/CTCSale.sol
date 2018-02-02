pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

import './CommunityCoin.sol';

contract CTCSale is CappedCrowdsale, FinalizableCrowdsale {

    using SafeMath for uint;

    uint constant private exa  =  10 ** 18;

    event WalletChanged(address _wallet);

    function CTCSale(uint _start,uint _end,uint _rate,uint _cap,address _wallet,CommunityCoin _tokenAddress)
    Crowdsale(_start, _end,_rate,_wallet)
    CappedCrowdsale(_cap.mul(exa)) public {
        token = CommunityCoin(_tokenAddress);
    }

    function setToken(address _tokenAddress) onlyOwner public {
        token = CommunityCoin(_tokenAddress);
    }

    function transferToken(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        token.transferOwnership(newOwner);
    }

    function setWallet(address _wallet) onlyOwner public {
        wallet = _wallet;
        WalletChanged(_wallet);
    }

    function setStartTime(uint _start) onlyOwner public {
        startTime = _start;
    }

    function setEndTime(uint _end) onlyOwner public {
        endTime = _end;
    }

    function remainToken() view public returns(uint) {
        return (cap - weiRaised).mul(rate);
    }

    function finalization() internal {
        super.finalization();
        transferToken(msg.sender);
    }
}
