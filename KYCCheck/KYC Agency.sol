pragma solidity 0.4.25;

interface KYCSmartContract {
    
    function transfer(address to, uint256 value) public returns (bool success);
    
    function transferFrom(address from, address to, uint256 value) public returns (bool success);
    
    function totalSupply() public view returns (uint256 amount);
    
    function approve(address spender, uint256 value) public returns (bool success);
    
    function allowance(address owner, address spender) public returns (uint256 amount);
    
    function balanceOf(address owner) public view returns (uint256 amount);
    
    event Transfer(address from, address to, uint256 value);
    event Approval(address from, address to, uint256 value);
    
}

contract AgencyHouseKeeping is KYCSmartContract {
    string public name;
    string public symbol;
    address public dad;
    uint256 TotalSupply;
    uint256 public decimals;
    uint256 public totalnumberOfTokensPerEther;
    uint256 public totalEtherinWei;
    address public ownerWallet;
    
    constructor() public {
        name = "KYCToken";
        symbol = "KYT";
        ownerWallet = msg.sender;
        dad = msg.sender;
        TotalSupply = 1000000000000000000000;
        decimals = 18;
        totalnumberOfTokensPerEther = 10;
        totalEtherinWei = 0;
        balances[dad] = 1000000000000000000000;
    }
    
    mapping (address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != 0x0);
        require(value > 0);
        require(balances[msg.sender] > value);
        require ((balances[to] + value) >= value);
        balances[msg.sender] = balances[msg.sender] - value;
        balances[to] = balances[to] + value;
        Transfer(msg.sender, to, value);
        return true;
        
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(to != 0x0);
        require(from != 0x0);
        require(value > 0);
        require(balances[from] > value);
        require ((balances[to] + value) >= value);
        require ((balances[from] - value) >= value);
        require (allowed[from][msg.sender]  >= value);
        
        balances[from] = balances[from] - value;
        balances[to] = balances[to] + value;
        allowed[from][msg.sender] = allowed[from][msg.sender] - value;
        Transfer(from, to, value);
        
        return true;
    }
    
    function totalSupply() public view returns (uint256 amount){
        return TotalSupply;
    }
    
    function approve(address spender, uint256 value) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }
    
    function allowance(address owner, address spender) public returns (uint256 amount) {
        return allowed[owner][spender];
    }
    
    function balanceOf(address owner) public view returns (uint256 amount) {
        return balances[owner];
    }
    
    function() payable {
        totalEtherinWei = totalEtherinWei + msg.value;
        uint256 amount = msg.value * totalnumberOfTokensPerEther;
        balances[dad] = balances[dad] - amount;
        balances[msg.sender] = balances[msg.sender] + amount;
        emit Transfer(dad, msg.sender, amount);
        ownerWallet.transfer(msg.value);
    }
    
}

contract AgencyContarct{
    address[] public UserReg;
    address[] public BankReg;
    mapping(bytes32 => bool) Verifiedhash;
    
    bytes32[] pendinghash;
    

//* function to add new user *//

    function AddUser (address User) public OnlyOwner
    {
        UserReg.push(user);
    }

//* function to add new back *//

    function AddBank ( address bank) public OnlyOwner
    {
        //TODO:: Check if same bank address exist
        BankReg.push(bank);
    }

//*Modifier to check only owner to perform VerifyDoc funcitionality *//
    modifier OnlyOwner() {
        require (msg.sender == owner, "only owner can call this function");
    _;
    }
   
   function VerifyDoc(byte32 hash) public OnlyOwner{
       if(Verifiedhash[hash] == 0)
       {
           Verifiedhash[hash] = 1;
        }
   }
   
   function getPendingVerificationDoc() public view returns (byte32) OnlyOwner{
       return pendinghash[0];
   }

}
/*
contract EmployeeManagement {
    struct Employee {
        uint id;
        bytes32 firstname;
        bytes32 lastname;
    }
    
    mapping (uint => Employee) employeeMap;
    
    Employee[] employees;
}*/