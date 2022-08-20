import React from 'react';
import { Button } from '@arco-design/web-react';
import { useInjectedProvider } from '../../contexts/InjectedProviderContext';

export const Web3SignIn = () => {
  const { requestWallet, address } = useInjectedProvider();

  return (
    <>
      {address ? (
        <Button variant='outline'>
          {address}
        </Button>
      ) : (
        <Button variant='outline' onClick={() => requestWallet()}>
          Connect Wallet
        </Button>
      )}
    </>
  );
};

export default Web3SignIn;