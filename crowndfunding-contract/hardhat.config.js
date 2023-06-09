/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config()

module.exports = {
  solidity: {
    version: '0.8.9',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    bscTestnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545',
      accounts: [
        process.env.PRIVATE_KEY,
      ],
    },
  },
  
};
