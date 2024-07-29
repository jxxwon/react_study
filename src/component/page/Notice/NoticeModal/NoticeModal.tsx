import { useRecoilState } from 'recoil';
import { NoticeModalStyled } from './styled';
import { modalState } from '../../../../stores/modalState';
import { FC, useEffect, useState } from 'react';
import axios, { AxiosResponse } from 'axios';

export interface INoticeModalProps {
    noticeSeq?: number;
}

export interface INoticeDetail {
    noti_seq:number;
    loginID: string;
    noti_title: string;
    noti_content: string;
    noti_date: string;
    file_name: string | null;
    physical_path: string | null;
    logical_path: string | null;
    file_size: number | null;
    file_ext: string | null;
}

export interface INoticeDetailResponse {
    detailValue: INoticeDetail;
}

export const NoticeModal: FC<INoticeModalProps> = ({ noticeSeq }) => {
    const [modal, setModal] = useRecoilState<boolean>(modalState);
    const [noticeDetail, setNoticeDetail] = useState<INoticeDetail>();

    useEffect(() => {
        searchDetail();
    },[]);

    const searchDetail = () => {
        axios.post('/system/noticeDetail.do', { noticeSeq }).then((res:AxiosResponse<INoticeDetailResponse>) => {
            setNoticeDetail(res.data.detailValue);
        });
        console.log(noticeDetail);
    };
    return (
        <NoticeModalStyled>
            <div className="container">
                <label>
                    제목 :<input type="text" defaultValue={noticeDetail?.noti_title}></input>
                </label>
                <label>
                    내용 : <input type="text" defaultValue={noticeDetail?.noti_content}></input>
                </label>
                <div className={'button-container'}>
                    <button>등록</button>
                    <button>삭제</button>

                    <button onClick={() => setModal(!modal)}>나가기</button>
                </div>
            </div>
        </NoticeModalStyled>
    )
};