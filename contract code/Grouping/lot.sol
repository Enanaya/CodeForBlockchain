pragma solidity ^0.4.24;

contract lot{
    //成员 
    mapping(uint256=>address) public members;
    //分组mapping  1-->members
   mapping(uint256=>address[2]) public gruops;
    
    constructor() public{
      members[0]=0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
      members[1]=0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        members[2]=0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
        members[3]=0x583031d1113ad414f02576bd6afabfb302140225;
        members[4]=0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
        members[5]=0xd676b4099f27b376a9829b1cf1312d9daa916b4f;
    }
    
    
    uint256 public ran;
 
    function _lot() public{
        for(uint256 i=0;i<3;i++){
            for(uint256 j=0;j<2;j++){
                ran=getRandom();
                while(members[ran]==address(0)){
                      ran=getRandom();
                }
                gruops[i][j]=members[ran];
                delete(members[ran]);
            }
        }
    }   
    
     uint256 randNonce;
     function getRandom() public returns(uint256){
        uint256 random=uint256(keccak256(msg.sender,now,randNonce));
        randNonce++;
        return random%6;
    }
    
    function getGroups() public  {
        
    }
}