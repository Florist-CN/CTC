pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol';

contract CommunityCoin is CappedToken, PausableToken {

  string public constant symbol = "CTC";

  string public constant name = "CTC";

  uint8 public constant decimals = 18;

  uint public constant unit = 10 ** uint256(decimals);
  uint public constant INITIAL_SUPPLY = 10 ** 2 * uint;
  uint public constant lockTime = 120 days;
  uint public startTime;

  function ConmmnityCoin() public {
      totalSupply_ = 0;
      startTime = now;
    }
    
     function unpause() onlyOwner whenPaused public {
    require(now > startTime + lockTime);
    super.unpause();
  }

  function () payable public {
        revert();
    }


}