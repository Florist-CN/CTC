pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol';

contract CommunityCoin is CappedToken, PausableToken {

  string public constant symbol = "CTC";

  string public constant name = "Community Coin";

  uint8 public constant decimals = 18;

  uint public constant unit = 10 ** uint256(decimals);

  uint public constant tokenCap = 10 ** 2 * unit; //
  
  uint public constant lockPeriod = 120 days;
  
  uint public startTime;

  function CommunityCoin() CappedToken(tokenCap) public {
      totalSupply_ = 0;
      startTime = now;
      pause();
    }
    
     function unpause() onlyOwner whenPaused public {
    require(now > startTime + lockPeriod);
    super.unpause();
  }

  function () payable public {
        revert();
    }


}