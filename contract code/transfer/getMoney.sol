pragma solidity^0.4.24;

contract GetMoney{
    address owner;
    
    constructor() public{
        owner=msg.sender;
    }
    
    function payMoney() payable public{
        
    }
    
    function () payable public{
        
    }
    
    
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    function getMoney() public{
        address who=msg.sender;
        if(getBalance()>2 ether){
            who.transfer(2 ether);
        }
    }
    
    function kill() public{
        if(msg.sender==owner){
            selfdestruct(msg.sender);
        }
    }
}