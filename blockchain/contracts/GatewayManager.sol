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
        address[] nodes;
    }
    
    struct Node {
        string name;
        string devEUI;
        
        //Array of strings in format "%timestamp%, %location%"
        // location% = "(%s%f2.15, %s%f2.15)", s% = "" || s="-" (4 eg.:"(37.700421688980136, -81.84535319999998)")
        string[] locationHistory;
        bool registered;
    }
    
    struct Admin {
        string name;
        bool authorized;
    }
    
    mapping(address => Gateway) public gatewayMapping; //Maps a gateway address to its Gateway object instance
    mapping(address => Admin) public adminMapping; //Maps an admin address to its Admin object instance
    mapping(address => Node) public nodeMapping; //Maps a node address to a Node object instance
    mapping(address => address) public nodeGatewayMapping; //Maps a node address to its associated gateway address
    
    address[] admins;
    address[] gateways;
    address[] nodes; //Note: Every node (LoRa emitter) will have an address to identifiy them, even if the account isn't used
    
    enum AccountHolder {
        OWNER,
        ADMIN,
        GATEWAY,
        NODE,
        NULL
    }
    //
    
    //events
    event AdminAdded(string name, address adminAddr);
    event GatewayAdded(string name, address addr);
    event NodeAdded(string name, string devEUI, address nodeAddr, address gatewayAddr);
    event LocationDataAdded(address nodeAddr, string data);
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
    
    //the given address shouldn't correspond to any object in this contract (Admin, Gateway, Admin or owner);
    modifier notAssigned(address _addr) {
        (bool b, AccountHolder who) = isAssigned(_addr);
        string memory s;
        
        if (b) {
            if(who == AccountHolder.OWNER) {
                s = "owner";
            } else if(who == AccountHolder.ADMIN) {
                s = "admin";
            } else if(who == AccountHolder.GATEWAY) {
                s = "gateway";
            } else if(who == AccountHolder.NODE) {
                s = "node";
            }
        }
        revert(strConcat("Account already assigned as ", s, "."));
        _;
    }
    //
    
    //Getters
    function getGatewayInfo(address _addr) public view returns(string memory name, string memory gatewayEUI, bool registered) {
        Gateway memory g = gatewayMapping[_addr];
        return (g.name, g.gatewayEUI, g.registered);
    }
    
    function isAdmin(address _addr) public view returns (bool) {
        for (uint i = 0; i < admins.length; i ++) {
            if (_addr == admins[i]) {
                return true;
            }
        }
        
        return false;
    }
    
    function isGateway(address _addr) public view returns(bool) {
        return gatewayMapping[_addr].registered;
    }
    
    function isNode(address _addr) public view returns(bool) {
        return nodeMapping[_addr].registered;
    }
    
    /**
     * Returns the address of the gateway associated to this node
     */
    function getAssociatedGateway(address _nodeAddr) public view returns(address) {
        return nodeGatewayMapping[_nodeAddr];
    }


    function getAllGatewayAddresses() public view returns(address[] memory) {
        return gateways;
    }
    
    /**
     * Returns a list of all associated nodes addresses
     */
    function getAssociatedNodes(address _gatewayAddr) public view returns(address[] memory) {
        //Checks if the given address is a gateway address
        require(isGateway(_gatewayAddr), "Address given is not a gateway address or the gateway is not yet registered");
        return gatewayMapping[_gatewayAddr].nodes;
    }

    /**
     * Returns a concatenation of all string of the locationHistory[] array, separated by a ";", between "[]"
     */
    function getNodeLocationHistory(address _addr) public view returns(string memory packedData) {
        string[] memory l = nodeMapping[_addr].locationHistory;
        string memory res;
        
        for (uint i = 0; i < l.length; i += 1) {
            res = strConcat(res, "[", l[i], "]");
            
            if(i != l.length-1) {
                res = strConcat(res, ";");
            }
        }
        
        return res;
    }
    
    function getNodeAddress(string memory _devEUI) public view returns(address) {
        for(uint i = 0; i < nodes.length; i += 1) {
            Node memory n = nodeMapping[nodes[i]];
            if (compareStrings(n.devEUI, _devEUI)) {
                return nodes[i];
            }
        }
        
        revert("Node address not found");
    }
    
    function isAssigned(address _addr) internal view returns(bool, AccountHolder) {
        bool b = true;
        AccountHolder who;
        
        if(_addr == owner) {
            who = AccountHolder.OWNER;
        } else if(isAdmin(_addr)) {
            who = AccountHolder.ADMIN;
        } else if(isGateway(_addr)) {
            who = AccountHolder.GATEWAY;
        } else if(isNode(_addr)) {
            who = AccountHolder.NODE;
        } else {
            who = AccountHolder.NULL;
            b = false;
        }
        
        return (b, who);
    }
    //
    
    //Setters
    function addAdmin(string memory _name, address _addr) public adminAction notAssigned(_addr) {
        Admin memory a = Admin({name: _name, authorized: true});
        admins.push(_addr);
        adminMapping[_addr] = a;

        emit AdminAdded(_name, _addr);
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
    
    function registerGateway(string memory _name, string memory _gatewayEUI, address _addr) public adminAction notAssigned(_addr) {
        Gateway memory g = Gateway({name: _name, gatewayEUI: _gatewayEUI, registered: true, nodes: new address[](0)});
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

    function registerNode(address _nodeAddr, string memory _devEUI, string memory _name, address _gatewayAddr) public adminAction
    notAssigned(_nodeAddr) {
        //Check if gateway exists
        require(isGateway(_gatewayAddr), "The address given is not a gateway address or the gateway is not yet registered");
        
        /*
        //Check if node is already registered, if yes, check its associated gateway
        if(nodeMapping[_nodeAddr].registered) {
            address gatewayAddr = nodeGatewayMapping[_nodeAddr];
            revert(strConcat("Node already registered, associated gateway's address : ", toString(gatewayAddr)));
        }
        */
        
        Node memory n = Node({name: _name, devEUI: _devEUI, registered: true, locationHistory: new string[](0)});
        //Map node address to its object
        nodeMapping[_nodeAddr] = n;
        //Maps node address to its associated gateway
        nodeGatewayMapping[_nodeAddr] = _gatewayAddr;
        //Pushes node address to nodes array, representng all nodes managed by this contract
        nodes.push(_nodeAddr);
        //Pushes node's address to the given gateway's nodes list, representing all gateway's associated nodes
        gatewayMapping[_gatewayAddr].nodes.push(_nodeAddr);
    }
    
    function removeNode(address _nodeAddr) public adminAction {
        //Check if node exists
        require(nodeMapping[_nodeAddr].registered, "The address given isn't a node address or node is already removed");
        //Change node "registered" to false
        nodeMapping[_nodeAddr].registered = false;
        
        //Remove node from "nodes" list
        for(uint i = 0; i < nodes.length; i += 1) {
            uint index;
            
            if (nodes[i] == _nodeAddr) {
                index = i;
            } else if (i > index) {
                nodes[i] = nodes[i-1];
            }
        }
        
        //Remove node from associated gateway's "nodes" list
        address[] memory _nodes = gatewayMapping[nodeGatewayMapping[_nodeAddr]].nodes;
        for(uint i = 0; i < _nodes.length; i += 1) {
            uint index;
            
            if (_nodes[i] == _nodeAddr) {
                index = i;
            } else if (i > index) {
                _nodes[i] = _nodes[i-1];
            }
        }
    }
    
    function sendNodeLocationData(address _nodeAddr, string memory timestamp, string memory coordinate1, string memory coordinate2)
    public gatewayAction {
        string memory coordinates = strConcat("(", coordinate1, ", ", coordinate2, ")");
        string memory res = strConcat(timestamp, ", ", coordinates);
        
        nodeMapping[_nodeAddr].locationHistory.push(res);
        
        emit LocationDataAdded(_nodeAddr, res);
    }
    //
    
    //Helper functions//
    
    /**
     * Helper functions for string concatenation 
     * (http://cryptodir.blogspot.com.tr/2016/03/solidity-concat-string.html)
     */
    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e)
    internal pure returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }
    
    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }
    
    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return strConcat(_a, _b, "", "", "");
    }

    /**
     * Helper function to convert an ethereum address to a string
     */
    function toString(address x) internal pure returns (string memory) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }
    
    /**
     * Helper function to compare strings
     */
    function compareStrings(string memory a, string memory b) internal pure returns (bool){
        bytes memory aBytes = bytes(a);
        bytes memory bBytes = bytes(b);
        return keccak256(aBytes) == keccak256(bBytes);
    }
    //***//
}