import type { interfaces } from '@garfish/core';

interface Options {
 
}

export function AppLoader(_args?: Options) {
  return function (garfish: interfaces.Garfish): interfaces.Plugin {
    return {
      name: 'app-loader',

      beforeLoad(appInfo: interfaces.AppInfo) {
        const appName = appInfo.name;

        const appInstance = new interfaces.App(
          this,
          appInfo,
          manager,
          resources,
          isHtmlMode,
          appInfo.customLoader,
        );

        garfish.cacheApps[appName] = appInstance
      }
    }
  };
}
