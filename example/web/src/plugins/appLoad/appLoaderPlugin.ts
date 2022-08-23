import type { interfaces } from '@garfish/core';

type App = interfaces.App;

interface Options {
 
}

export function AppLoader(_args?: Options) {
  return function (garfish: interfaces.Garfish): interfaces.Plugin {
    return {
      name: 'app-loader'
    }
  };
}
