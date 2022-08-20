import React from 'react';
import { Button } from '@arco-design/web-react';
import { useInjectedProvider } from '../../contexts/InjectedProviderContext';
import StarMaskOnboarding from '@starcoin/starmask-onboarding';
import { utils } from '@starcoin/starcoin';

export const initialClick = async () => {
  const initialStarCoin = () => {
    const currentUrl = new URL(window.location.href);
    const forwarderOrigin =
      currentUrl.hostname === 'localhost' ? 'http://localhost:9032' : undefined;

    const isStarMaskInstalled = StarMaskOnboarding.isStarMaskInstalled();
    const isStarMaskConnected = false;
    const accounts = [];

    let onboarding;
    try {
      onboarding = new StarMaskOnboarding({ forwarderOrigin });
    } catch (error) {
      console.error(error);
    }

    let chainInfo = {
      chain: '',
      network: '',
      accounts: '',
    };

    return {
      isStarMaskInstalled,
      isStarMaskConnected,
      accounts,
      onboarding,
      chainInfo,
    };
  };

  const initialData = initialStarCoin();
  const status = () => {
    if (!initialData.isStarMaskInstalled) {
      return 0;
    } else if (initialData.isStarMaskConnected) {
      initialData.onboarding?.stopOnboarding();
      return 2;
    } else {
      return 1;
    }
  };

  const _status = status();
  if (_status === 0) {
    initialData.onboarding.startOnboarding();
  } else if (_status === 1) {
    try {
      const newAccounts = await window.starcoin.request({
        method: 'stc_requestAccounts',
      });
    } catch (error) {
      console.error(error);
    }
  }
};

export const StarcoinSignIn = () => {
  const { requestWallet, address } = useInjectedProvider();

  return (
    <>
      {address ? (
        <Button type='outline'>
          {address}
        </Button>
      ) : (
        <Button type='outline' onClick={() => initialClick()}>
          Connect Wallet
        </Button>
      )}
    </>
  );
};

export default StarcoinSignIn;