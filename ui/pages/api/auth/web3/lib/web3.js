import Web3 from 'web3';
import HDWalletProvider from '@truffle/hdwallet-provider';

const getProvider = async () => {
  if (typeof window !== 'undefined') {
    if (window.ethereum) {
      await window.ethereum.enable();
      return window.ethereum;
    } else if (window.web3) {
      return window.web3.currentProvider;
    } else {
      window.alert('Please install MetaMask!');
    }
  } else {
    const mnemonic = process.env.MNEMONIC;
    const rpcUrl = process.env.RPC_URL;
    return new HDWalletProvider(mnemonic, rpcUrl);
  }
};

export const getWeb3 = async () => {
  const provider = await getProvider();
  return new Web3(provider);
};