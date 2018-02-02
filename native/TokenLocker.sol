pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

import './CommunityCoin.sol';

contract TokenLocker is Ownable, ERC20Basic {
    using SafeERC20 for CommunityCoin;
    using SafeMath for uint;

    CommunityCoin public token;

    mapping(address => uint) balances;

    uint private pool;

    uint public releaseTime;

    uint constant public lockPeriod = 180 days;

    event TokenReleased(address _to, uint _value);
    
    
    function TokenLocker(CommunityCoin _token) public {
        token = _token;
        releaseTime = token.startTime().add(lockPeriod);
    }

    function totalSupply() view public returns(uint){
        return pool;
    }

    function balanceOf(address _who) view public returns(uint balance) {
        return balances[_who];
    }

    function deposite() public onlyOwner {
        uint newPool = token.balanceOf(this);
        require(newPool > pool);
        uint amount = newPool.sub(pool);
        pool = newPool;
        balances[owner] = balances[owner].add(amount); 
        Transfer(address(0), owner, amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function release() public {
        require(now >= releaseTime);
        uint amount = balances[msg.sender];
        require(amount > 0);
        require(pool >= amount);
        balances[msg.sender] = 0;
        pool = pool.sub(amount);
        token.safeTransfer(msg.sender,amount);
        TokenReleased(msg.sender,amount);
    }

    function setToken(address tokenAddress) onlyOwner public {
        token = CommunityCoin(tokenAddress);
    }

    function setReleaseTime(uint _time) onlyOwner public {
        releaseTime = _time;
    }

    function () payable public{
        revert();
    }
}
contract TokenLocker is Ownable, ERC20Basic {
    using SafeERC20 for CommunityCoin;
    using SafeMath for uint;

    CommunityCoin public token;

    mapping(address => uint) balances;

    uint private pool;

    uint public releaseTime;

    uint constant public lockPeriod = 180 days;

    event TokenReleased(address _to, uint _value);
    
    
    function TokenLocker(CommunityCoin _token) public {
        token = _token;
        releaseTime = token.startTime().add(lockPeriod);
    }

    function totalSupply() view public returns(uint){
        return pool;
    }

    function balanceOf(address _who) view public returns(uint balance) {
        return balances[_who];
    }

    function deposite() public onlyOwner {
        uint newPool = token.balanceOf(this);
        require(newPool > pool);
        uint amount = newPool.sub(pool);
        pool = newPool;
        balances[owner] = balances[owner].add(amount); 
        Transfer(address(0), owner, amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function release() public {
        require(now >= releaseTime);
        uint amount = balances[msg.sender];
        require(amount > 0);
        require(pool >= amount);
        balances[msg.sender] = 0;
        pool = pool.sub(amount);
        token.safeTransfer(msg.sender,amount);
        TokenReleased(msg.sender,amount);
    }

    function setToken(address tokenAddress) onlyOwner public {
        token = CommunityCoin(tokenAddress);
    }

    function setReleaseTime(uint _time) onlyOwner public {
        releaseTime = _time;
    }

    function () payable public{
        revert();
    }
}