pragma solidity ^0.8.4;

contract FUNDaily {
    
    string public constant name = "FUNDaily";
    string public constant symbol = "FUND";
    uint8  public constant decimals = 0;
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => uint256) equity_usd;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 totalSupply_;
    
    // Numero maximo de fund a la venta
    uint256 public max_fund = 1000000;
    // Tasa de Conversion USD a fund
    uint256 public usd_to_fund = 1000;
    // Numero total de fund comprados por inversionistas
    uint256 public total_fund_bought = 0;

    using SafeMath for uint256;
    constructor() {
        totalSupply_ = max_fund;
        balances[msg.sender] = totalSupply_;
    }
    
    //Get total token supply
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    
    //Get token balance of owner
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }
    
    //Transfer tokens to another account
    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        equity_usd[msg.sender] = balances[msg.sender]/1000;
        equity_usd[receiver] = balances[receiver]/1000;
        total_fund_bought = total_fund_bought.add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
    
    //Approve Delegate to Withdraw tokens marketplace
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    // Get number of tokens approved for withdrawal
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }
    
    //Transfer tokens by delegate
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a-b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a+b;
        assert(c >= a);
        return c;
    }
}
