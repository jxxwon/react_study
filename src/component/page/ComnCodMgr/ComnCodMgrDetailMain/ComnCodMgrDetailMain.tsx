import { useNavigate, useParams } from "react-router-dom"
import { ComnCodMgrDetailMainStyled } from "./styled"
import { ContentBox } from "../../../common/ContentBox/ContentBox";
import { Button } from "../../../common/Button/Button";
import { StyledTable, StyledTd, StyledTh } from "../../../common/styled/StyledTable";
import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import { useEffect, useState } from "react";
import { ComnCodMgrDetailModal } from "../ComnCodMgrDetailModal/ComnCodMgrDetailModal";
import { useRecoilState } from "recoil";
import { modalState } from "../../../../stores/modalState";
import { IComnDetailList, IListComnDtlCodJsonResponse } from "../../../../models/interface/ComnCodMgr/comnCodMgrModel";


export const ComnCodMgrDetailMain = () => {
    const { grpCod } = useParams();
    const navigate = useNavigate();
    const [comnDetailList, setComnDetailList] = useState<IComnDetailList[]>();
    const [modal, setModal] = useRecoilState(modalState);
    const [detailCod, setDetailCod] = useState<string>('');

    useEffect(() => {
        searchComnCodDetail();
    }, []);

    const searchComnCodDetail = (cpage?:number) => {
        cpage = cpage || 1;
        const postAction: AxiosRequestConfig = {
            method:'POST',
            url: '/system/listComnDtlCodJson.do',
            data: { grp_cod: grpCod, currentPage: cpage, pageSize: 5 },
            headers: {
                'Content-Type' : 'application/json',
            },
        };

        axios(postAction).then((res:AxiosResponse<IListComnDtlCodJsonResponse>) => {
            setComnDetailList(res.data.listComnDtlCodModel);
        });
    };

    const handlerSave = () => {

    }

    const handlerModal = (dtlCd:string) => {
        setModal(!modal);
        setDetailCod(dtlCd);
    };

    const onPostSuccess = () => {
        setModal(!modal);
        // searchComnCodDetail(cpage);
    }

    return (
        <ComnCodMgrDetailMainStyled>
            <ContentBox>공통코드 상세조회</ContentBox>
            <Button onClick={() => navigate(-1)}>뒤로가기</Button>
            <Button>신규등록</Button>
            <StyledTable>
                <thead>
                    <tr>
                        <StyledTh size={10}>그룹코드</StyledTh>
                        <StyledTh size={10}>상세코드</StyledTh>
                        <StyledTh size={7}>상세코드명</StyledTh>
                        <StyledTh size={10}>상세코드 설명</StyledTh>
                        <StyledTh size={5}>사용여부</StyledTh>
                    </tr>
                </thead>
                <tbody>
                    {comnDetailList && comnDetailList.length > 0 ? (
                        comnDetailList.map((a) => {
                            return (
                                <tr key={a.dtl_cod} onClick={() => handlerModal(a.dtl_cod)}>
                                    <StyledTd>{a.grp_cod}</StyledTd>
                                    <StyledTd>{a.dtl_cod}</StyledTd>
                                    <StyledTd>{a.dtl_cod_nm}</StyledTd>
                                    <StyledTd>{a.dtl_cod_eplti}</StyledTd>
                                    <StyledTd>{a.use_poa}</StyledTd>
                                </tr>
                            )
                        })
                    ) : (
                        <tr>
                            <StyledTd colSpan={6}>데이터가 없습니다.</StyledTd>
                        </tr>
                    )}
                </tbody>
                <ComnCodMgrDetailModal detailCod={detailCod} onPostSuccess={onPostSuccess}></ComnCodMgrDetailModal>
            </StyledTable>
        </ComnCodMgrDetailMainStyled>);
}