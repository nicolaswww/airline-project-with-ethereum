const HDWalletProvider = require('truffle-hdwallet-provider');
const { mnemonic, rinkebyUrl } = require('./credentials');

module.exports = {
  networks: {
    development: {      
      host: 'localhost',
      port: 7545,
      network_id: '*',
      gas: 5000000
    },
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, rinkebyUrl),
      network_id: 4
    }
  }
}