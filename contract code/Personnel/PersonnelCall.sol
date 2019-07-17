pragma solidity ^0.4.24;

import './Personnel.sol';

contract personnelCall{
    
    Personnel p;
    address owner;
    
    struct liver{
        uint256 id;
        string name;
        uint256 age;
    }
    
    liver[] livers;
    
    constructor() public{
        owner=msg.sender;
    }
    
    function setDb(address add) public returns(bool){
        //transfer Personnel's address into contract  here
        p=Personnel(add);
    }
    
    string  _name;
    uint256 _age;
    string  data;
    
    function check(uint256 _id) public  returns(bool){
        (_name,_age,data)=p.getPerson(_id);
        if(bytes(data).length!=0 || _age<18){
        return false;
        }
        return true;
    } 
}