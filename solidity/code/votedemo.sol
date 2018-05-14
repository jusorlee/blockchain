pragma solidity ^0.4.20;

contract voteDemo {
    // 定义投票人的结构
    struct Voter {
        uint weight;    //投票人的权重
        bool voted;     //是否已经投票
        address delegate;    //委托代理投票
        uint vote;           //投票主题的序号
    }
    
    // 定义投票主题的结构
    struct Posposal {
        bytes8 name;       //投票主题的名字
        uint voteCount;    //主题的得到的票数
    }
    
    // 定义投票的发起者
    address public chairperson;
    
    // 所有的投票人
    mapping(address => Voter) public voters;
    
    // 具体的投票主题
    Posposal[] public posposals;
    
    
    // 构造函数
    function voteDemo(bytes8[] peposposalName){
        // 初始化投票的发起人，就是当前合约的部署者
        chairperson = msg.sender;
        // 给发起人投票权
        voters[chairperson].weight = 1;
        
        // 初始化投票的主题
        for(uint i = 0; i < peposposalName.length; i++){
            posposals.push(Posposal({name:peposposalName[i],voteCount:0}));
        }
            
    }
    
    // 添加投票者
    function giveRightToVote(address _voter){
        // 只有投票的发起人才能够添加投票者
        // 添加的投票者不能是已经参加过投票了
        if(msg.sender != chairperson || voters[_voter].voted){
            throw;
        }
        // 赋予合格的投票者投票权重
        voters[_voter].weight = 1;
        
    }
    
    // 
    
    // 投票
    function vote(uint pid){
        // 找到投票者
        Voter sender = voters[msg.sender];
        // 检查是不是已经投过票
        if(sender.voted){
            // 如果已经投票，则终止程序
            throw;
        } else {
            // 如果没有投过票，则投票
            sender.voted = true;    //设置当前用户已经投票
            sender.vote = pid;      //设置当前用户的投票的主题编号
            posposals[pid].voteCount += sender.weight; //把当前用户的投票权重给予对应的主题
        }
    }
    
    // 计算票数最多的主题
    function winid() constant returns (uint winningid){
        // 声明一个临时变量，用来比大小
        uint winningCount = 0;
        //遍历主题，找到投票数最大的主题
        for(uint i = 0; i < posposals.length; i++){
            if(posposals[i].voteCount > winningCount) {
                winningCount = posposals[i].voteCount;
                winningid = i;
            }
        }
    }
    
    function winname() constant returns (bytes8 winnername){
        winnername = posposals[winid()].name;
    }
    
}