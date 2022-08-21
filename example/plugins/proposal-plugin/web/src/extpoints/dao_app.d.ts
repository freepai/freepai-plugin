import React from 'react';

export interface IApp {
    name: string,
    activeWhen: string,
    entry: React.ReactNode
}

export interface IDAO {
    registerApp(app: IApp)
}