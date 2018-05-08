pragma solidity ^0.4.23;

contract Coin {
    // minter铸币工
    address minter;
    // 映射，用来记录当前地址的余额
    mapping(address => uint) balances;
    
    // minter存储了合约的创建者地址
    function Coin() public {
        // msg.sender 获取合约的创建者
        minter = msg.sender;
    }
    
    // 此函数只有合约的创建者才能执行
    function mint(address receiver, uint amount) public {
        // 如果调用当前函数的人不是合约创建者，则直接返回
        if (msg.sender != minter) return;
        // 对账户地址的余额进行初始化操作
        balances[receiver] += amount;
    }
    // 模拟转账操作
    function send(address receiver, uint amount) returns(address, uint,address, uint){
        // 判断当前函数调用者的余额是否充足 
        if (balances[msg.sender] < amount) return;
        // 进行相应的转账操作
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        
        return (msg.sender,balances[msg.sender],receiver,balances[receiver]);
    }
    
    // 显示当前函数调用者的余额
    function showBalance() constant returns (address, uint) {
        return (msg.sender,balances[msg.sender]);
    }
}