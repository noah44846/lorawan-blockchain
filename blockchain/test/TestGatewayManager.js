var GatewayManager = artifacts.require("GatewayManager");

contract("GatewayManager", function (accounts) {
    it("admin should be added", function () {
        var instance;
        var _name = "admin";
        return GatewayManager.deployed().then(function (_instance) {
            instance = _instance;
            return instance.addAdmin(_name, accounts[1], {from: accounts[0]});
        }).then(function () {
            return instance.adminMapping.call(accounts[1], {from: accounts[0]});
        }).then(function (admin) {
            assert.equal(admin[0], _name);
            assert.isTrue(admin[1]);
        });
    });
});