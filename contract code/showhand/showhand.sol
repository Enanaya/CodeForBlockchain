pragma solidity^0.4.20;

contract showhand{
    
    address private cto;
    bytes32 seed;
    
    uint public bringInBet=1;
    uint public minmalBet=1;
    
    
    address public hostPlayer;
    address public guestPlayer;
    address public activePlayer;
    address public winner;
    
    mapping(address=>uint8[5]) private cards;
    mapping(address=>uint) public totalBalance;
    mapping(address=>uint) public roundBalance;
    mapping(address=>bool) public isPlayerActed;
    
    uint8 public round;
    bool isGameFinished;
    
    event onCardDeal(address player,uint8 card);
    event onGameCreated();
    event onPlayerJoin(address player);
    
    function showhand(address _cto) public {
        cto=_cto;
        bringInBet=100;
        minmalBet=100;
        round=0;
        //hostPlayer=msg.sender;
        seed=block.blockhash(block.number-1);
        //event
         onGameCreated();
    }
    
    function join() public{
        assert(round==0);
        //first one is host
        if(address(0)==hostPlayer){
            hostPlayer=msg.sender;
            return;
        }
        //second is guest
        assert(address(0)==guestPlayer);
        guestPlayer=msg.sender;
        //event
         onPlayerJoin(msg.sender);
    }
    
    function isAllPlayerActed() private returns(bool){
        return isPlayerActed[hostPlayer]&&isPlayerActed[guestPlayer];
    }
    
    function dealCard() private returns(uint8){
        seed=sha256(seed);
        return uint8(seed)%52;
    }
    
    
    function bringIn() public payable{
        assert(round==0);
        assert(guestPlayer==msg.sender||msg.sender==hostPlayer);
        assert(msg.value>=bringInBet);
        
        totalBalance[msg.sender]=msg.value;
        isPlayerActed[msg.sender]=true;
        
        //if all palyer bringin?
        if(isAllPlayerActed()){
            //post card
            cards[hostPlayer][round]=dealCard();
            cards[guestPlayer][round]=dealCard();
            
            //nextRound();
            
            cards[hostPlayer][round]=dealCard();
            
             onCardDeal(hostPlayer,cards[hostPlayer][round]);
            cards[guestPlayer][round]=dealCard();
            
             onCardDeal(guestPlayer,cards[guestPlayer][round]);
            nextRound();
        }
        
    }
    
    
    function bet() public payable{
        assert(msg.value>minmalBet);
        assert(msg.sender==activePlayer);
        assert(round>0&&!isGameFinished);
        if(msg.sender==hostPlayer){
            require(roundBalance[msg.sender]+msg.value>=roundBalance[guestPlayer]);
        }
        else{
            require(roundBalance[msg.sender]+msg.value>=roundBalance[hostPlayer]);
        }
        
        isPlayerActed[msg.sender]=true;//must reset
        roundBalance[msg.sender]+=msg.value;
        totalBalance[msg.sender]+=msg.value;
        
        nextMove();
    }
    
    
    function nextPlayer() private{
        if(activePlayer==hostPlayer){
            activePlayer=guestPlayer;
        }else{
            activePlayer=hostPlayer;
        }
    }
    
    
    function nextMove() private {
        assert(round>0);
        if(!isAllPlayerActed() ||
        roundBalance[hostPlayer]!=roundBalance[guestPlayer]){
            nextPlayer();
            return ;
        }
        
        if(round== 5){
            //game over
            if(compareCard(0,cards[hostPlayer],cards[guestPlayer])){
                winner=hostPlayer;
                isGameFinished=true;
            }else{
                winner=guestPlayer;
                isGameFinished=true;
            }
            return ;
        }
        
        cards[hostPlayer][round]=dealCard();
        onCardDeal(hostPlayer,cards[hostPlayer][round]);
        
        cards[guestPlayer][round]=dealCard();
        onCardDeal(guestPlayer,cards[guestPlayer][round]);
        
        nextRound();
    }
    
    function resetRoundData() private{
        activePlayer=address(0);
        roundBalance[hostPlayer]=0;
        roundBalance[guestPlayer]=0;
        isPlayerActed[hostPlayer]=false;
        isPlayerActed[guestPlayer]=false;
    }
    
    
    function nextRound() private{
        
        round++;
        resetRoundData();
        determinerActivePlayer();
    }
    
    function determinerActivePlayer() private{
        if(compareCard(1,cards[hostPlayer],cards[guestPlayer])){
            activePlayer=hostPlayer;
        }else{
            activePlayer=guestPlayer;
        }
    }
    
    function compareCard(uint8 start,uint8[5] cards1,uint8[5] cards2) private returns(bool){
        uint i=0;
        uint sum1=0;
        uint sum2=0;
        for(i=start;i<5;i++){
            sum1+=cards1[i];
            sum2+=cards2[i];
        }
        return sum1>=sum2;
    }
    
    
    function withdraw() public payable{
        assert(winner==msg.sender);
        assert(isGameFinished);
        
        uint total = totalBalance[hostPlayer]+totalBalance[guestPlayer];
        
        winner.transfer(total*90/100);
        cto.transfer(total*10/100);
        
    }
    
    function fold() public{
        assert(round>0&&!isGameFinished);
        require(msg.sender==activePlayer);
        
        //set winner
        nextPlayer();
        winner=activePlayer;
        isGameFinished=true;
    }
    
    function pass() public{
        assert(round>0&&!isGameFinished);
        require(msg.sender==activePlayer);
        require(roundBalance[hostPlayer]==roundBalance[guestPlayer]);
        
        nextMove();
        
    }
    
    function getPocket() public returns(uint8){
        return cards[msg.sender][0];
    }
    
    
    function getPlayerCard(uint8 pos) public returns(uint8 host,uint8 guest){
        if(pos==0){
            host=55;
            guest=55;
            return;
        }
        host=cards[hostPlayer][pos];
        guest=cards[guestPlayer][pos];
        return;
    }
    
}