pragma solidity ^0.5.0;

/**
 * This contract allows the user to manage the different LoRa gateways, nodes and data 
 */
contract GatewayManager {
    
    //constructor
    address owner;
    
    constructor() payable public {
        owner = msg.sender;
    }
    //
    
    //variables
    struct Gateway {
        string name;
        string gatewayEUI;
        bool registered;
    }
    
    struct Node {
        string name;
        string devEUI;
        bool registered;
    }
    
    struct Admin {
        string name;
        bool authorized;
    }
    
    // TODO: link one gateway to multiple nodes (1 node cannot be linked to multiple gateways)
    //mapping(address => Node) public gatewayNodeMapping; //Maps a gateway address to all its associated nodes
    
    mapping(address => Gateway) public gatewayMapping; //Maps a gateway address to its Gateway instance
    mapping(address => Admin) public adminMapping; //Maps an admin address to its Admin instance
    
    //mapping(address => uint) public adminMapping; //Maps an admin address to its index in admins array
    
    address[] admins;
    address[] gateways;
    //
    
    //events
    event GatewayAdded(string name, address addr);
    event NodeAdded(string name, string devEUI);
    event AdminAdded(string name, address adminAddr);
    //
    
    //modifiers
    modifier adminAction() {
        require(msg.sender == owner || isAdmin(msg.sender), "Only admin accounts can perform this action.");
        _;
    }
    
    modifier gatewayAction() {
        require(isGateway(msg.sender), "Only gateway accounts can perform this action.");
        _;
    }
    //
    
    //Getters
    function getGateway(address _addr) public view returns(string memory name, string memory gatewayEUI, bool registered) {
        Gateway memory g = gatewayMapping[_addr];
        return (g.name, g.gatewayEUI, g.registered);
    }

    function isAdmin(address _addr) public view returns (bool b) {
        for (uint i = 0; i < admins.length; i ++) {
            if (_addr == admins[i]) {
                return true;
            }
        }
        
        return false;
    }
    
    function isGateway(address _addr) public view returns(bool b) {
        for (uint i = 0; i < gateways.length; i++) {
            if (_addr == gateways[i]) {
                return true;
            }
            return false;
        }
    }

    function getAllGatewayAddresses() public view returns(address[] memory) {
        return gateways;
    }

    function getNodeData(/*to be defined (node identifier)*/) public view {
        revert("Not implemented yet");
        //TODO: Implement function
    }
    //
    
    //Setters
    function addAdmin(string memory _name, address _admAddr) public adminAction {
        require(!isAdmin(_admAddr), "Already is admin."); //account must be non-admin
        Admin memory a = Admin({name: _name, authorized: true});
        admins.push(_admAddr);
        adminMapping[_admAddr] = a;

        emit AdminAdded(_name, _admAddr);
    }
    
    function removeAdmin(address _admAddr) public adminAction {
        require(isAdmin(_admAddr), "Account isn't already admin."); //the account must be admin

        admins.push(_admAddr);
        
        for(uint i = 0; i < admins.length; i += 1) {
            uint index;
            
            if (admins[i] == _admAddr) {
                index = i;
            } else if (i > index) {
                admins[i] = admins[i-1];
            }
        }
        
        admins.length -= 1;
    }
    
    function registerGateway(string memory _name, string memory _gatewayEUI, address _addr) public adminAction {
        require(!gatewayMapping[_addr].registered, "Gateway already registered."); //gateway must be non-registered
        
        Gateway memory g = Gateway({name: _name, gatewayEUI: _gatewayEUI, registered: true});
        gateways.push(_addr);
        gatewayMapping[_addr] = g;
        
        emit GatewayAdded(_name, _addr);
    }
    
    function removeGateway(address _addr) public adminAction{
        delete gatewayMapping[_addr];
        
        for(uint i = 0; i < gateways.length; i += 1) {
            uint index;
            
            if (gateways[i] == _addr) {
                index = i;
            } else if (i > index) {
                gateways[i] = gateways[i-1];
            }
        }
        
        gateways.length -= 1;
        
    }

    function registerNode(string memory _name, string memory _devEUI, address _gatewayAddr) public adminAction {
        revert("Not yet implemented");
        //TODO: Implement function
    }
    
    function removeNode(/*to be defined (node identifier)*/) public adminAction {
        revert("Not yet implemented");
        //TODO: implement function
    }
    
    function sendData(/*to be defined*/) public gatewayAction {
        revert("Not yet implemented");
        //TODO: Implement function
    }
    //
}