pragma solidity ^0.4.20;

contract SimpleAuction {
    address public beneficiary;  //拍卖受益人
    uint public auctionStart;       //拍卖开始时间
    uint public biddingTime;        //拍卖时长
    
    // 当前最高的投标人地址和投标金额；
    address public highestBidder;
    uint public highestBid;
    
    // 记录某个人的投标历史总金额
    mapping(address => uint) public pendingReturns;
    
    // 当为true是，拍卖结束
    bool public ended;
    
    // 构造函数
    // 初始化，拍卖的时长（秒）,和拍卖受益人的地址
    function SimpleAuction(uint _biddingTime, address _beneficiary){
        beneficiary = _beneficiary;
        auctionStart = now;
        biddingTime = _biddingTime;
    }
    
    // 出现更高投标价格是，触发该事件，公开投标人和投标金额
    event HighestBidIncreased(address bidder, uint amount);
    event DoWithdraw(bool _b, uint _org, uint _now,address _addr,uint amount);
    event AuctionEnded(address _addr, uint amount);
    
    function bid() payable {
        // 如果投标时间已过，则终止程序
        if (now > auctionStart+biddingTime){
            throw;
        }
        
        // 如果投标的金额小于当前最高投标金额，在终止程序
        if (msg.value <= highestBid){
            throw;
        }
        
        // 记录当前用户的累计投标金额
        // 当用户没有中标时，需要返还这些金额给当前用户
        if (highestBidder != 0){
            pendingReturns[highestBidder] += highestBid;
        }
        
        // 第二次投标的时候，需要先把前一次没有中标的钱先返回来。
        var amount = pendingReturns[msg.sender];
        pendingReturns[msg.sender] = 0;
        msg.sender.send(amount);
        
        highestBidder = msg.sender;
        highestBid = msg.value;
        // 打印log
        HighestBidIncreased(msg.sender,msg.value);
    }
    
    //退回未中标的资金
    function withdraw() payable returns (bool){
        // 把要返回的金额存在变量amount中
        var amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // 将用户返还的钱设置为0
            pendingReturns[msg.sender] = 0;
            
            // 获取当前函数调用这的账户余额
            uint _org = msg.sender.balance;
            uint _now = 0;
            if(!msg.sender.send(amount)){
                // 如果以太币发送失败，则重置需要返还的钱。
                pendingReturns[msg.sender] = amount;
                DoWithdraw(false, _org,_now,msg.sender,amount);
                return false;
            }else{
                _now = msg.sender.balance;
                DoWithdraw(true, _org,_now,msg.sender,amount);
            }
            
        }
        return true;
    }
    
    // 结束此次拍卖
    function auctionEnd(){
        // 如果时间还没有到，则终止程序
        if(now <= auctionStart + biddingTime){
            throw;
        }
        if(ended){
            throw;   //auctionEnd()本身已经被调用过了。
        }
        
        // 设置投标结束
        ended = true;
        
        // 将获胜者的信息显示在日志里面
        AuctionEnded(highestBidder, highestBid);
        
        // 将中标的金额发送给拍卖受益人
        if (!beneficiary.send(highestBid)){
            throw;
        }
    }
    
    
}