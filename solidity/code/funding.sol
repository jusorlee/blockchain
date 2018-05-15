pragma solidity ^0.4.20;

// 实现众筹的智能合约（实现赞助功能的基本模块）
contract Funding{
    // 投资人
    struct Funder{
        address addr;       //投资人地址
        uint amount;        //给某个产品投资的金额
    }
    
    //产品（被赞助）
    struct Product{
        address addr;       //众筹账户的钱包地址
        string name;        //被赞助产品的名称
        uint total;         //想要众筹的总金额
        uint numFunder;     //记录有多少人赞助
        uint amount;        //当前已经众筹的金额
        // 以后希望通过产品查询出赞助者
        mapping(uint=>Funder) funders;
    }
    
    // 统计被赞助的产品数量
    uint public numProduct;
    
    // 获取被赞助的产品信息
    mapping (uint => Product) public products;
    
    event eaddr(address addr);
    event ebool(bool b);
    
    // 添加一个众筹产品传递参数：众筹的钱包地址，产品名称，欲筹金额
    function newProduct(address addr, string name, uint total){
        uint num = numProduct++;
        products[num] = Product(addr, name, total*10**18,0,0);
    }
    
    // 对产品进行众筹功能（因为要进行代币交易，因此需要设置payable关键词）
    
    function contribute(uint pid) public payable{
        // 根据pid获取要赞助的产品对象
        Product p = products[pid];
        // msg.sender获取当前函数的调用者, amount:获取函数调用时传入的value值
        p.funders[p.numFunder++] = Funder({addr:msg.sender, amount:msg.value});
        // p.addr.send(msg.value);
        p.amount += msg.value;
    }
    
    // 检查众筹是否成功，如果成功,把所有代币发送到产品的地址
    function checkContribute(uint pid) public payable returns (bool){
        // 通过pid获取相应的众筹产品
        Product p = products[pid];
        // 检查当前商品是否众筹成功
        ebool(p.amount < p.total);
        if(p.amount < p.total){
            // throw;
            return false;       //获取把已经众筹的代币退还给投资者
        }
        // 把众筹的金额转移到产品的钱包地址
        eaddr(p.addr);
        p.addr.transfer(p.amount);
        p.amount = 0;
        return true;

    }
    
    
    
    
}