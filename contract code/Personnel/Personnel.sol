pragma solidity ^0.4.24;

import './strings.sol';

//abandon use example
contract Personnel{
    
    using strings for *;
    
    address police;
    
    struct person{
        uint256 id;
        string name;
        uint256 age;
        string[10] crimedata;
        uint256 crimeCount;
    }
    
    uint256 public idCount;
    
    mapping(uint256=>person) persons;
    
    string[10] data;
    
    constructor() public{
        idCount=0;
        police=msg.sender;
        data[0]="";
    }
    
    function addPerson(string _name, uint256 _age) public{
        require(msg.sender!=address(0));
        person memory p;
        p=person(idCount,_name,_age,data,0);
        persons[idCount++]=p;
        }
        
    function addCrime(uint256 _id,string _crimedata) public{
        //require(msg.sender==police );
        uint256 crimeNo=persons[_id].crimeCount;
        persons[_id].crimeCount++;
        persons[_id].crimedata[crimeNo]=_crimedata; 
    }
    
    function getPerson(uint256 _id)  public returns(string result,uint256 ,string ){
        for(uint256 i=0;i<persons[_id].crimedata.length;i++){
            if(bytes(persons[_id].crimedata[i]).length!=0){
            result=result.toSlice().concat(persons[_id].crimedata[i].toSlice());
            }
        }
        return (persons[_id].name,persons[_id].age,result);
    }
    
    function getLen(uint256 _id)  public returns(uint256){
        string memory _name;
        uint256 _age;
        string memory data;
        (_name,_age,data)=getPerson(_id);
        return bytes(data).length;
    }
    
}