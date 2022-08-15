import reactSvg from '../static/icons/React.svg';
import vueSvg from '../static/icons/Vue.svg';
import viteSvg from '../static/icons/Vite.svg';
import angularSvg from '../static/icons/Angular.svg';
import multiInstanceSvg from '../static/icons/MultiInstance.svg';

export const subAppMenus = [
  {
    key: 'react17',
    path: '/react17',
    icon: <img src={reactSvg} className="sidebar-item-icon" />,
    title: '【子应用】react17',
    routes: [
      { path: 'react17/home', title: '首页' },
      { path: 'react17/list', title: '员工列表' },
      { path: 'react17/detail', title: '员工详情', query: { id: '002' } },
    ],
  },
  {
    key: 'react16',
    path: '/react16',
    icon: <img src={reactSvg} className="sidebar-item-icon" />,
    title: '【子应用】react16',
    routes: [
      { path: 'react16/home', title: '首页' },
      { path: 'react16/about', title: '关于' },
    ],
  }
];
