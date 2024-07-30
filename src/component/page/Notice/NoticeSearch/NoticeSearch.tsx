import { useRef, useState } from "react";
import { Button } from "../../../common/Button/Button";
import { NoticeSearchStyled } from "./styled";
import { useNavigate } from "react-router-dom";
import { useRecoilState } from "recoil";
import { modalState } from "../../../../stores/modalState";

export const NoticeSearch = () => {
    const [startDate, setStartDate] = useState<String>();
    const [endDate, setEndDate] = useState<String>();
    const title = useRef<HTMLInputElement>(null);
    const [modal, setModal] = useRecoilState<boolean>(modalState);
    const navigate = useNavigate();

    const handlerSearch = () => {
        // 검색 버튼을 누르면 조회가 됨
        const query: string[] = []; // query라는 이름의 변수를 선언했음( : string[]은 문자열 배열이라고 타입을 지정해준 것)

        !title.current?.value || query.push(`searchTitle=${title.current?.value}`);
        !startDate || query.push(`startDate=${startDate}`);
        !endDate || query.push(`endDate=${endDate}`);        

        const queryString = query.length > 0 ? `?${query.join(`&`)}` : '';
        navigate(`/react/system/notice.do${queryString}`);
    };

    const handlerModal = () => {
        setModal(!modal); 
    }; 

    return (
        <NoticeSearchStyled>
            <input ref={title}></input>
            <input type="date" onChange={(e) => setStartDate(e.target.value)}></input>
            <input type="date" onChange={(e) => setEndDate(e.target.value)}></input>
            <Button onClick={handlerSearch}>검색</Button>
            <Button onClick={handlerModal}>등록</Button>
        </NoticeSearchStyled>
    );
}