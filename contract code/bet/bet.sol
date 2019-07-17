pragma solidity^0.4.24;

contract Bet{
    
    address owner;
    bool isFinish;//是否结束 
    struct Player{
        address addr;
        uint256 amount;
    }
    Player[] inBig;
    Player[] inSmall;
    
    uint256 totalBig;
    uint256 totalSmall;
    uint256 nowtime;
    
    constructor() public{
        owner=msg.sender;
        isFinish=false;
        totalSmall=0;
        totalBig=0;
        nowtime=now;
    }
    
    function stake(bool flag) public payable returns(bool){//true means bid Big,else bid samll
    require(msg.value>0);
      Player memory p=Player(msg.sender,msg.value);
        if(flag){
            //Big
            inBig.push(p);
            totalBig+=msg.value;
            return true;
        }
        else{
            //Small
            inSmall.push(p);
            totalSmall+=msg.value;
            return true;
        }
        return false;
    }
    
    function open() payable public returns(bool){
        require(now>nowtime+40 && !isFinish);
        //0-8 is small 9-17 is big
        uint256 points=uint256(keccak256(msg.sender,now,block.number))%18;
        uint256 i=0;
        Player p;
        if(points>=9){
            for(i=0;i<inBig.length;i++){
                p=inBig[i];
                p.addr.transfer(p.amount+totalSmall/totalBig*p.amount);
            }
        }else{
            for(i=0;i<inSmall.length;i++){
                p=inSmall[i];
                p.addr.transfer(p.amount+totalBig/totalSmall*p.amount);
            }
        }
        isFinish=true;
        return true;
    }
    
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    function getNowtime() public view returns(uint256){
        return now;
    }
    
    function kill() public {
        if(msg.sender==owner)
        {
            selfdestruct(owner);
        }
    }
}