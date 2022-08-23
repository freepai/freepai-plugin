import React from 'react';

export function Provider(this: any, appInfo: any, props: any) : Promise<{
    render: (appInfo: any) => any;
    destroy: (appInfo: any) => any;
}>

export interface IApp {
    name: string,
    activeWhen: string,
    provider: Provider
}

export interface IDAO {
    registerApp(app: IApp)
}