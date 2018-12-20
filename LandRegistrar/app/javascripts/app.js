// Import the page's CSS. Webpack will know what to do with it.
//import "../stylesheets/app.css";

// Import libraries we need.
import {  default as Web3 } from 'web3';
import {  default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import assets_artifacts from '../../build/contracts/LandAssets.json'

// Conference is our usable abstraction, which we'll use through the code below.
var Assets = contract(assets_artifacts);

var sim,accounts;

window.App = { //where to close
    start: function() {
        var self = this;
		//alert("started")
        web3.eth.getAccounts(function(err, accs) {
            if (err != null) {
                alert("There was an error fetching your accounts.");
                return;
            }
			//alert(accs)
            if (accs.length == 0) {
                alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
                return;
            }
		accounts=accs;
		//alert(accounts);
        });
		
    },	
	transferAssets: function(seller,buyer,registar,assetId) {
		var sim;
		Assets.deployed().then(function(instance){
			sim=instance;
			sim.transferAssets(seller,buyer,registar,assetId, {from: accounts[0], gas:3000000}).
			then(function(value){
				//console.log(result);
				//console.log("Assets Transferred");
			});
			
			//.catch(function(error){console.log(error)});
		});
	},
	addAssets: function(assetId,owner) {
		var sim;
		Assets.deployed().then(function(instance){
			sim=instance;
			sim.addAssets(assetId, owner,{from: accounts[0], gas:3000000}).
			then(function(){return sim.status.call()}).
			then(function(value){
				console.log(value);
			})
		});
	},
	
	addRegistar: function(registar) {
		var sim;
		//alert("in add registar registar::::::::::"+ registar)
		Assets.deployed().then(function(instance){
			//alert("in add registar instance::::::::::"+ instance)
			sim=instance;
			sim.addRegistrar(registar,{from: accounts[0], gas:3000000}).then(function(){
				//alert("line");				
				return sim.status.call()}).then(function(value){console.log(value);
			});
		});
	},
	viewAssetsBasedOnOwner : function(assetView){
		//alert(assetView);
		var sim;
		$("#ownerInfo").text("Hello Amit Entry!");
		Assets.deployed().then(function(instance){
			sim=instance;
			sim.viewAssetsBasedOnOwner(assetView, {from: accounts[0], gas:3000000}).
			then(function(value){
				$("#ownerInfo").text(value);
			});
		});
		
	},

	intendToSell: function(buyer, assetId) {
		var sim;
		Assets.deployed().then(function(instance){
			sim=instance;
			sim.intendToSell(buyer, assetId, {from: accounts[0], gas:3000000}).			
			then(function(value){
				console.log(value);
			});
		});
	}	
	
};//loop for main
 



window.addEventListener('load', function() {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        console.warn("UAssetsng web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If uAssetsng MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
        // Use Mist/MetaMask's provider
        window.web3 = new Web3(web3.currentProvider);
    } else {
        console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. ConAssetsder switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    }
	//alert(web3.currentProvider.selectedAddress)
    Assets.setProvider(web3.currentProvider);
    App.start();

    // Wire up the UI elements
	
	$("#btn-transferAsset").click(function() {
	var seller = $('#transForm #sellerAdd').val();
    var buyer = $('#transForm #buyerAdd').val();
	var registar = $('#transForm #registarAdd').val();
	var assetId = $('#transForm #assetId').val();
		App.transferAssets(seller,buyer,registar,assetId);
		return false;
    });
	
	$("#btn-addAssets").click(function() {
	var assetId = $('#assetsForm #addAssets').val();
	var owner = $('#assetsForm #ownerAdd').val();
		App.addAssets(parseInt(assetId),owner);
		return false;
    });
	
	$("#btn-addReg").click(function() {
	var registar = $('#regForm #addRegistar').val();
		App.addRegistar(registar);
		return false;
	});
	
	$("#btn-viewAssets").click(function() {
		var assetView = document.getElementById("viewAsset").value;
			App.viewAssetsBasedOnOwner(assetView);
			return false;
	});

	$("#btn-intentToSell").click(function() {
		var assetId = $('#intentToSellForm #AssetsID').val();
		var owner = $('#intentToSellForm #ownerAdd').val();
			App.intendToSell(owner, assetId);
			return false;
	});

});