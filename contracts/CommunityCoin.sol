pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';

contract CommunityCoin is Ownable, PausableToken {

  string public constant symbol = "CTC";

  string public constant name = "CTC";

  uint8 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
  
  function ConmunityCoin() public {
      totalSupply_ = INITIAL_SUPPLY;
      paused = true;
      balances[msg.sender] = 50;
      Transfer(msg.sender, msg.sender, 50);
    }
    
    function a() public {
        balances[msg.sender] = 50;
      Transfer(msg.sender, msg.sender, 50);
    }

  function () payable public {
        revert();
    }


}
