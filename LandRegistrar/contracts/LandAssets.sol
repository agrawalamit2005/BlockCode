pragma solidity 0.4.24;
//Contract ver 0.8
contract LandAssets{
    address contractOwner;
    mapping(address => bool) registrars;
    mapping(uint => bool) assetIds;
    mapping (uint => Asset) assetsData;
    bool public status;

    struct Asset{
        address owner;
        address registrar;
        address seller;
        address prospectiveBuyer;
        uint assetId;
    }
    
    constructor() payable public {
        contractOwner = msg.sender;
        registrars[msg.sender] = true;
    }
    
    function addRegistrar(address newRegistrar) payable public onlyByContractOwner(msg.sender) returns (bool){
            status = false;
            registrars[newRegistrar] = true;
            status = true;
            return status;
    }
    
    
    function addAssets(uint assetId, address assetOwner) payable public onlyByRegistrars(msg.sender) returns (bool){
        if (assetIds[assetId] != true)
        {
            assetIds[assetId] = true;
            Asset asst;
            asst.owner = assetOwner;
            asst.registrar = msg.sender;
            asst.seller = msg.sender;
            asst.prospectiveBuyer = 0;
            assetsData[assetId] = asst;
        }
        else
            return false;
        
        return true;
        
    }

    
    //Make this payable to become part of the transaction
    function intendToSell(address buyer, uint assetId) public payable returns (bool){
        if(assetIds[assetId] == true) {
            Asset asst = assetsData[assetId];
            if(asst.owner == msg.sender) {
                asst.prospectiveBuyer = buyer;
                assetsData[assetId] = asst;
            }
            else
                return false;
        }
        else
            return false;
            
        return true;
    }
    
    //Make this payable to become part of the transaction
    function transferAssets(address seller, address buyer, address registrar, uint assetId) payable public onlyByRegistrars(msg.sender) returns (bool)
    {
        if(assetIds[assetId] == true) {
            Asset asst = assetsData[assetId];
            if(asst.prospectiveBuyer == buyer) {
                asst.prospectiveBuyer = 0;
                asst.owner = buyer;
                asst.seller = seller;
                asst.registrar = registrar;
                assetsData[assetId] = asst;
                return true;
            }
            else
                return false;
        }
        else
            return false;       
        
    }
    
    //Viewing assets are based on assetId only. Need to think about owner as well.
    
    function viewAssetsBasedOnOwner(uint assetId) public view returns (address){
        //return 0x90c3B877CA2d8406B22BdF63651343BDdEE47804;
        return assetsData[assetId].owner;
    }
    
    modifier onlyByRegistrars(address _account)
    {
        require(
            registrars[_account] == true,
            "Sender not authorized."
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }
    
    
     modifier onlyByContractOwner(address _account)
    {
        require(
            contractOwner == _account,
            "Sender not authorized."
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }
    
}