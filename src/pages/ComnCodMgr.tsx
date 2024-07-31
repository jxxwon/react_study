import { ContentBox } from "../component/common/ContentBox/ContentBox";
import { ComnCodMgrMain } from "../component/page/ComnCodMgr/ComnCodMgrMain/ComCodMgrMain";
import { ComnCodSearch } from "../component/page/ComnCodMgr/ComnCodSearch/ComnCodSearch";
import { ComnCodProvider } from "../api/ComnCodMgrProvider";



export const ComnCodMgr = () => {

    return (
        <>
            <ComnCodProvider>
                <ContentBox>공통코드 관리</ContentBox>
                <ComnCodMgrMain/>
                <ComnCodSearch/>
            </ComnCodProvider>
        </>
    )
};