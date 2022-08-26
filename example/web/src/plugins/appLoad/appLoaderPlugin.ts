import type { interfaces } from '@garfish/core';
import {
  getRenderNode,
} from '@garfish/utils';
declare module '@garfish/core' {
  export default interface Garfish {
    preLoadApp(
      appName: string,
      options?: Partial<Omit<interfaces.AppInfo, 'name'>>,
    ): Promise<interfaces.App | null>;
  }

  export namespace interfaces {
 
    export interface Config {
      preCompiled?: boolean
    }

    export interface AppInfo {
      preCompiled?: boolean
    }

    export interface App {
      compiled: boolean;
      asyncScripts: Promise<void>
    }
  }
}

interface Options {
 
}

export function AppLoader(_args?: Options) {
  return function (garfish: interfaces.Garfish): interfaces.Plugin {
    garfish.preLoadApp = async function (
      appName: string,
      options?: Partial<Omit<interfaces.AppInfo, 'name'>>,
    ): Promise<interfaces.App | null> {
      const app = await garfish.loadApp(appName, {
        cache: true,
        preCompiled: true,
        entry: options?.entry,
        ...options
      })
      const rets = await app?.compileAndRenderContainer();
      if (rets) {
        await rets.asyncScripts
      }
      
      return app
    }

    return {
      name: 'app-loader',
      version: "v0.1.0",
      afterLoad(appInfo, appInstance) {
        if (!appInfo.preCompiled || appInstance == undefined) {
          return
        }

        appInstance.compiled = false
        const originCompileAndRenderContainer = appInstance.compileAndRenderContainer
        appInstance.compileAndRenderContainer = async function() {
          if (this.compiled) {
            const wrapperNode = await getRenderNode(this.appInfo.domGetter);
            if (typeof wrapperNode.appendChild === 'function') {
              wrapperNode.appendChild(this.appContainer);
            }

            return {
              asyncScripts: this.asyncScripts,
            }
          }

          const promise = originCompileAndRenderContainer.call(this)
          const { asyncScripts } = await promise;
          this.compiled = true
          this.asyncScripts = asyncScripts;

          return {
            asyncScripts: asyncScripts,
          }
        }
      },
    }
  };
}
