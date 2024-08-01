import { useRecoilState } from "recoil";
import { ComnCodDetalTableStyled, ComnCodMgrDetailModalStyled } from "./styled";
import { modalState } from "../../../../stores/modalState";
import { Button } from "../../../common/Button/Button";
import { useLocation, useParams } from "react-router-dom";
import { FC, useEffect, useState } from "react";
import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import { IComnDtlCodModel, ISelectComnDtlCod, ISelectComnDtlCodResponse } from "../../../../models/interface/ComnCodMgr/comnCodMgrModel";

export interface IComnCodeMgrDetailModalProps{
    detailCod: string;
    onPostSuccess: () => void;
};

export const ComnCodMgrDetailModal: FC<IComnCodeMgrDetailModalProps> = ({detailCod, onPostSuccess}) => {
    const [modal, setModal] = useRecoilState(modalState);
    const { grpCod } = useParams();
    const { state } = useLocation();
    const [comnDetail, setComnDetail] = useState<IComnDtlCodModel>();

    useEffect(()=>{
        if(modal && detailCod) searchDetail();
    },[detailCod]);

    const searchDetail = () => {
        const postAction: AxiosRequestConfig = {
            method: 'POST',
            url: '/system/selectComnDtlCod.do',
            data: { grp_cod: grpCod, dtl_cod: detailCod },
            headers : {
                'Content-Type' : 'application/json',
            }
        }
        axios(postAction).then((res:AxiosResponse<ISelectComnDtlCodResponse>) => {
            if(res.data.result === 'SUCCESS'){
                setComnDetail(res.data.comnDtlCodModel);
            }
        })
    };

    const handlerSave = () => {
        const postAction: AxiosRequestConfig = {
            method: 'POST',
            url: '/system/saveComnDtlCodJson.do',
            data: {...comnDetail, dtl_grp_cod: grpCod},
            headers : {
                'Content-Type' : 'application/json'
            }
        };

        axios(postAction).then((res:AxiosResponse<ISelectComnDtlCod>) => {
            if (res.data.result === 'SUCCESS') onPostSuccess();
        })
    };

    const handlerUpdate = () => {
        const postAction: AxiosRequestConfig = {
            method: 'POST',
            url: '/system/updateComnDtlCodJson.do',
            data: {...comnDetail, dtl_grp_cod: grpCod},
            headers : {
                'Content-Type' : 'application/json'
            }
        };

        axios(postAction).then((res:AxiosResponse<ISelectComnDtlCod>) => {
            if (res.data.result === 'SUCCESS') onPostSuccess();
        })
    };

    const handlerDelete = () => {
        const postAction: AxiosRequestConfig = {
            method: 'POST',
            url: '/system/deleteComnDtlCodJson.do',
            data: {dtl_cod: detailCod, dtl_grp_cod: grpCod},
            headers : {
                'Content-Type' : 'application/json'
            }
        };
        
        axios(postAction).then((res:AxiosResponse<ISelectComnDtlCod>) => {
            if (res.data.result === 'SUCCESS') onPostSuccess();
        })
    };

    const cleanUp = () => {
        setComnDetail(undefined);
    };

    return (
        <>
            <ComnCodMgrDetailModalStyled ariaHideApp={false} isOpen={modal} onAfterClose={cleanUp}>
                <div className="wrap">
                    <div className="header">상세 코드 관리</div>
                    <ComnCodDetalTableStyled>
                        <tbody>
                            <tr>
                                <th>그룹 코드 id</th>
                                <td>
                                    <input type="text" name="grp_cod" defaultValue={state.grp_cod} readOnly={true}></input>
                                </td>
                                <th>그룹 코드 명</th>
                                <td>
                                    <input type="text" name="grp_cod_nm" defaultValue={state.grp_cod_nm} readOnly={true}></input>
                                </td>
                            </tr>
                            <tr>
                                <th>상세 코드 id </th>
                                <td>
                                    <input type="text" defaultValue={comnDetail?.dtl_cod} readOnly={detailCod ? true : false}></input>
                                </td>
                                <th>상세 코드 명</th>
                                <td>
                                    <input type="text"> defaultValue={comnDetail?.dtl_cod_nm} </input>
                                </td>
                            </tr>
                            <tr>
                                <th>코드 설명</th>
                                <td colSpan={3}>
                                    <input type="text" defaultValue={comnDetail?.dtl_cod_eplti}></input>
                                </td>
                            </tr>
                            <tr>
                                <th>사용 유무 *</th>
                                <td colSpan={3}>
                                    <input type="radio" name="useYn" value={'Y'} checked={comnDetail?.use_poa === "Y"}></input>
                                    사용
                                    <input type="radio" name="useYn" value={'N'} checked={comnDetail?.use_poa === "N"}></input>
                                    미사용
                                </td>
                            </tr>
                        </tbody>
                    </ComnCodDetalTableStyled>
                    <div className="btn-group">
                        <Button onClick={detailCod ? handlerUpdate : handlerSave}>{detailCod ? '수정' : '저장'}</Button>
                        {detailCod? <Button onClick={handlerDelete}>삭제</Button> : null}
                        <Button onClick={() => setModal(!modal)}>닫기</Button>
                    </div>
                </div>
            </ComnCodMgrDetailModalStyled>
        </>
    );
}