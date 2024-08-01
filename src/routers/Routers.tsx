import { RouteObject, createBrowserRouter } from 'react-router-dom';
import { Login } from '../pages/Login';
import { DashBoard } from '../component/layout/DashBoard/DashBoard';
import { NotFound } from '../component/common/NotFound/NotFound';
import { Children } from 'react';
import { Notice } from '../pages/Notice';
import { ComnCodMgr } from '../pages/ComnCodMgr';
import { ComnCodMgrDetailMain } from '../component/page/ComnCodMgr/ComnCodMgrDetailMain/ComnCodMgrDetailMain';

const routers: RouteObject[] = [
    { path: '*', element: <NotFound /> },
    { path: '/', element: <Login /> },
    {
        path: '/react',
        element: <DashBoard />,
        children: [
            { 
                path: 'system', 
                children: [
                    {path: 'notice.do', element: <Notice/>}, 
                    {path: 'comnCodMgr.do', element:<ComnCodMgr/>},
                    {path: 'comnCodMgr.do/:grpCod', element: <ComnCodMgrDetailMain/>}
                ],
            },
        ],
    },
];

export const Routers = createBrowserRouter(routers);
