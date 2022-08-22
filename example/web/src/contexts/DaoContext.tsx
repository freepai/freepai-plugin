import React, { useState, useContext, createContext} from 'react';
import { IApp } from '../extpoints/dao_app'

export const DaoContext = createContext();

export const DaoProvider = ({ children }) => {
  const [apps, setApps] = useState<Array<IApp>>([]);

  const registerApp = (appInfo)=> {
    apps.push(appInfo)
    setApps(apps)
  }

  return (
    <DaoContext.Provider
      value={{
        apps,
        registerApp,
      }}
    >
      {children}
    </DaoContext.Provider>
  );
};

export const useDao = () => {
  const {
    apps,
    registerApp,
  } = useContext(DaoContext);

  return {
    apps,
    registerApp,
  };
};
