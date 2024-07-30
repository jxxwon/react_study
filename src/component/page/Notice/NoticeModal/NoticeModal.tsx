import { useRecoilState } from 'recoil';
import { NoticeModalStyled } from './styled';
import { modalState } from '../../../../stores/modalState';
import { ChangeEvent, FC, useEffect, useRef, useState } from 'react';
import axios, { AxiosRequestConfig, AxiosResponse } from 'axios';
import { loginInfoState } from '../../../../stores/userInfo';
import NoImage from '../../../../assets/noImage.jpg';

export interface INoticeModalProps {
    noticeSeq?: number;
    onSuccess: () => void;
    // handlerModal: () => void; // handlerModal을 통해 noticeSeq를 undefined로 바꾼거임
    setNoticeSeq : (notiSeq: undefined) => void;
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

export interface IPostResponse {
    result: 'Success';
    // result: string으로 해도 상관 없음 위에가 더 보수적임
}

// export const NoticeModal: FC<INoticeModalProps> = ({ noticeSeq, onSuccess, handlerModal}) => {
export const NoticeModal: FC<INoticeModalProps> = ({noticeSeq, onSuccess, setNoticeSeq}) => {
    const [modal, setModal] = useRecoilState<boolean>(modalState);
    const [noticeDetail, setNoticeDetail] = useState<INoticeDetail>();
    const [userInfo] = useRecoilState(loginInfoState);
    const title = useRef<HTMLInputElement>(null);
    const content = useRef<HTMLInputElement>(null);
    const [imageUrl, setImageUrl] = useState<string>('notImage');
    const [fileData, setFileData] = useState<File>();

    useEffect(() => {
        if(noticeSeq) searchDetail();

        return () => {
            setNoticeSeq(undefined);
        };
    },[]);

    const searchDetail = () => {
        axios.post('/system/noticeDetail.do', { noticeSeq }).then((res:AxiosResponse<INoticeDetailResponse>) => {
            if(res.data.detailValue){
                setNoticeDetail(res.data.detailValue);
                const fileExt = res.data.detailValue.file_ext;
                if(fileExt === 'jpg' || fileExt === 'gif' || fileExt === 'png'){
                    setImageUrl(res.data.detailValue.logical_path || NoImage);
                } else {
                    setImageUrl(NoImage);
                }
            }
        });
    };

    // text만 저장
    // const handlerSave = ( ) => {
    //     axios
    //         .post('/system/noticeSave.do', {
    //             title: title.current?.value,
    //             content: content.current?.value,
    //             loginId: userInfo.loginId,
    //         }) 
    //         .then((res: AxiosResponse<IPostResponse>) => {
    //             if (res.data.result === 'Success'){
    //                 //setModal(!modal);
    //                 onSuccess();
    //             }
    //         })
    // };

    // 파일 저장도 같이
    const handlerSave = () => {
        const fileForm = new FormData();
        // text 데이터와 파일 데이터가 따로 보낼 것임
        const textData = {
            title: title.current?.value,
            content: content.current?.value,
            loginId: userInfo.loginId,
        };
        if(fileData) fileForm.append('file', fileData);
        fileForm.append('text', new Blob([JSON.stringify(textData)], {type:'application/json'})); // json으로 textdata를 보내겠다는 뜻
        // 위에까지가 axios로 보낼 데이터를 만든 것임(text와 file)
        axios.post('/system/noticeFileSaveJson.do', fileForm).then((res: AxiosResponse<IPostResponse>) => {
            if(res.data.result === 'Success'){
                onSuccess();
            }
        });
    };

    // 기존 수정
    // const handlerUpdate = () => {
    //     axios.post('/system/noticeUpdate.do', {
    //         title: title.current?.value,
    //         content: content.current?.value,
    //         noticeSeq: noticeSeq,
    //     }).then((res:AxiosResponse<IPostResponse>) => {
    //         if(res.data.result === 'Success'){
    //             onSuccess();
    //         }
    //     });
    // };

    // 파일도 수정
    const handlerUpdate = () => {
        const fileForm = new FormData();
        // text 데이터와 파일 데이터가 따로 보낼 것임
        const textData = {
            title: title.current?.value,
            content: content.current?.value,
            loginId: userInfo.loginId,
            noticeSeq, //key와 value값의 이름이 같을 때에는 이렇게 한 번만 써줘도 됨
        };
        if(fileData) fileForm.append('file', fileData);
        fileForm.append('text', new Blob([JSON.stringify(textData)], {type:'application/json'})); // json으로 textdata를 보내겠다는 뜻

        axios.post('/system/noticeFileUpdateJson.do', fileForm).then((res: AxiosResponse<IPostResponse>) => {
            if(res.data.result === 'Success'){
                onSuccess();
            }
        });
    };

    const handlerDelete = () => {
        axios.post('/system/noticeDelete.do', {
            noticeSeq: noticeSeq,
        }).then((res:AxiosResponse<IPostResponse>) => {
            if(res.data.result === 'Success'){
                onSuccess();
            }
        })
    };

    // 파일 미리보기
    const handlerFile = (e : ChangeEvent<HTMLInputElement>) => {
        const fileInfo = e.target.files;
        if(fileInfo?.length){
            const fileInfoSplit = fileInfo[0].name.split('.');
            const fileExtension = fileInfoSplit[1].toLowerCase();

            if(fileExtension === 'jpg' || fileExtension === 'gif' || fileExtension === 'png'){
                setImageUrl(URL.createObjectURL(fileInfo[0]));
            } else {
                setImageUrl('notImage');
            }
            setFileData(fileInfo[0]);
        }
    };

    // 파일 다운로드
    const downloadFile = async () => {
        let param = new URLSearchParams({noticeSeq: noticeSeq?.toString() as string});
        param.append('noticeSeq', noticeSeq?.toString() as string); //noticeSeq는 null이 될 수 없다는 뜻

        const postAction: AxiosRequestConfig = {
            url: '/system/noticeDownload.do',
            method: 'POST',
            data: param, // param은 url searchParam을 얘기하는 것임
            responseType: 'blob', // return을 받았을 때의 데이터 타입을 지정, blob은 0과 1로 이루어진 대용량 데이터
        }; 

        await axios(postAction).then((res) => {
            console.log(res.data);
            const url = window.URL.createObjectURL(new Blob([res.data]));
            console.log(url);

            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', noticeDetail?.file_name as string);
            document.body.appendChild(link);
            link.click(); // 내가 클릭 안해도 클릭이 되게끔

            link.remove();
        })
    };

    return (
        <NoticeModalStyled>
            <div className="container">
                <label>
                    제목 :<input type="text" defaultValue={noticeDetail?.noti_title} ref={title}></input>
                </label>
                <label>
                    내용 : <input type="text" defaultValue={noticeDetail?.noti_content} ref={content}></input>
                </label>
                    파일 : <input type="file" id="fileInput" style={{ display: 'none' }} onChange={handlerFile}></input>
                <label className="img-label" htmlFor="fileInput">
                    파일 첨부하기
                </label>
                <div onClick={downloadFile}>
                    {imageUrl === 'notImage' ? (
                        <div>
                            <label>파일명</label>
                            {fileData?.name || noticeDetail?.file_name} 
                        </div>
                    ) : (
                        <div>
                            <label>미리보기</label>
                            <img src={imageUrl} alt='imageUrl'/>
                        </div>
                    )}
                </div>
                <div className={'button-container'}>
                    <button onClick={noticeSeq ? handlerUpdate : handlerSave}>{noticeSeq ? '수정' : '등록'}</button>
                    {/* <button onClick={handlerUpdate}>수정</button> */}
                    {noticeSeq ? <button onClick={handlerDelete}>삭제</button> : null}
                    {/* <button onClick={() => handlerModal()}>나가기</button>  */}
                    {<button onClick={() => setModal(!modal)}>나가기</button>}
                </div>
            </div>
        </NoticeModalStyled>
    )
};