pragma solidity^0.4.24;
contract RedPacket{
    //设置土豪
    address tuhao;
    //设置红包个数 
    int number;
    
    constructor(int num) public payable{
        tuhao=msg.sender;
        number=num;
    }
    
    //获取余额
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    
    //抢红包 
    function stakeMoney() public returns(bool){
        address who=msg.sender;
        if(number>0){
            if(getBalance()>0){
                number--;
                uint256 random=uint256(keccak256(now,msg.sender,10))%100;
                uint256 balance=getBalance();
                who.transfer(balance*random/100);
                return true;
            }
        }
        return false;
    }
    
    function kill() public{
        if(msg.sender==tuhao){
            selfdestruct(tuhao);
        }
    }
}