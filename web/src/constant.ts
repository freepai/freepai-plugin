import GarfishInstance from 'garfish';
import portMap from '../config.json';

export const loadApp = 'loadApp';
export const basename = 'examples';
export const prefixCls = 'main-app';

type AppInfo = NonNullable<Parameters<typeof GarfishInstance.run>[0]>['apps'];

const getProxyHost = (appName: string) =>
  `http://localhost:${portMap[appName].port}`;

export const localApps: AppInfo = [
  {
    // 每个应用的 name 需要保持唯一
    name: 'react17',
    activeWhen: '/react17',
    // 子应用的入口地址，可以为 HTML 地址和 JS 地址
    // 注意：entry 地址不可以与主应用+子应用激活地址相同，否则刷新时将会直接返回子应用内容
    entry: getProxyHost('dev/react17'),
  },
  {
    name: 'react16',
    activeWhen: '/react16',
    entry: getProxyHost('dev/react16'),
  }
];
