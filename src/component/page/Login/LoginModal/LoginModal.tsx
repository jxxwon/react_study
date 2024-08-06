import { FC, useEffect, useRef, useState} from "react";
import { LoginModalStyled, LoginModalTableStyled } from "./styled";
import { useRecoilState } from "recoil";
import { modalState } from "../../../../stores/modalState";
import { Button } from "../../../common/Button/Button";
import axios, { AxiosResponse } from "axios";
import AddrModal from "../AddrModal/AddrModal";

export interface ILoginModalProps {
    onSuccess: ( ) => void;
}

export interface IPostResponse {
    result: 'SUCCESS';
}

export const LoginModal:FC<ILoginModalProps> = ({onSuccess}) => {
    const [modal, setModal] = useRecoilState<boolean>(modalState);
    
    const [loginID, setLoginID] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [registerPwdOk, setRegisterPwdOk] = useState<string>('');
    const [registerChk, setRegisterChk] = useState<boolean>(false);
    const [name, setName] = useState<string>('');
    const [gender_cd, setGender_cd] = useState<string>('');
    const birthday = useRef<HTMLInputElement | null>(null);
    const [user_email, setUser_email] = useState<string>('');
    const user_zipcode = useRef<HTMLInputElement | null>(null);
    const user_address = useRef<HTMLInputElement | null>(null);
    const user_dt_address = useRef<HTMLInputElement | null>(null);
    const [user_tel1, setUser_tel1] = useState<string>('');
    const [user_tel2, setUser_tel2] = useState<string>('');
    const [user_tel3, setUser_tel3] = useState<string>('');
    const [user_type, setUser_type] = useState<string>('');
    
    useEffect(() => {}, [modal]);
    
    // ID 중복 확인
    const loginIdChk = async(): Promise<boolean> => {
        const idRules =  /^[a-zA-Z0-9]{6,20}$/g ;
        if(!idRules.test(loginID)){
            alert('아이디는 숫자, 영문자 조합으로 6~20자리를 사용해야 합니다.');
            return false;
        } else {
            try{
                const res: AxiosResponse<number> = await axios.post('/checkLoginID.do', { loginID });
                if(res.data === 0){
                    alert('사용할 수 있는 아이디입니다.');
                    setRegisterChk(true);
                    return true;
                } else{
                    alert('중복된 아이디가 존재합니다.');
                    setRegisterChk(false);
                    return false;
                }
            } catch (error){
                alert('오류가 발생하였습니다.');
                setRegisterChk(false);
                return false;
            }
        }
    };

    // 비밀번호 확인
    const pwRules = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;

    function pwChk(password: string):boolean{
        if(!pwRules.test(password)){
            alert('비밀번호는 숫자, 영문자, 특수문자 조합으로 8~15자리를 사용해야 합니다.');
            return false;
        } else if(registerPwdOk === ''){
            alert('비밀번호 확인을 입력하세요.');
            return false;
        } else if(password !== registerPwdOk){
            alert('비밀번호가 맞지 않습니다.');
            return false;
        } else {
            return true;
        }
    }

    // 성별 가져오기
    const handlerGenderCd = (event:React.ChangeEvent<HTMLSelectElement>) => {
        setGender_cd(event?.target.value);
    }

    // 이메일 형식 확인
    const emailRules = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

    function emailChk(user_email:string):boolean{
        if(!emailRules.test(user_email)){
            alert('이메일 형식을 확인해주세요.');
            return false;
        } else {
            return true;
        }
    }

    // 전화번호 형식 확인
    const handlerUserTel = (part: 'tel1' | 'tel2' | 'tel3') => (event: React.ChangeEvent<HTMLInputElement>) => {
        const input = event.target as HTMLInputElement;
        input.value = input.value.replace(/[^0-9]/g, '');

        if (part === 'tel1') {
            setUser_tel1(input.value);
        } else if (part === 'tel2') {
            setUser_tel2(input.value);
        } else if (part === 'tel3') {
            setUser_tel3(input.value);
        }
    };

    // 회원유형 가져오기
    const handlerUserType = (event:React.ChangeEvent<HTMLSelectElement>) => {
        setUser_type(event?.target.value);
    }

    // 회원가입
        const handlerSave = ( ) => {
        axios
            .post('/registerJson.do', {
                action: 'I',
                loginID,
                password,
                name,
                gender_cd,
                birthday : birthday.current?.value,
                user_email,
                user_zipcode : user_zipcode.current?.value,
                user_address : user_address.current?.value,
                user_dt_address : user_dt_address.current?.value,
                user_tel1,
                user_tel2,
                user_tel3,
                user_type
            }) 
            .then((res: AxiosResponse<IPostResponse>) => {
                if (res.data.result === 'SUCCESS'){
                    setModal(!modal);
                    onSuccess();
                    alert('회원가입 요청이 완료되었습니다.');
                }
            })
    };

    const handlerRegist = async () => { 
        
        if(loginID.trim() === ''){
            alert('아이디를 입력하세요.');
            return;
        } 
        if(registerChk === false){
            alert('아이디 중복확인을 진행하세요.');
            return;
        } 
        if(password.trim() === ''){
            alert('비밀번호를 입력하세요.');
            return;
        } 
        if(!pwChk(password)){
            return;
        }
        if(name.trim() === ''){
            alert('이름을 입력하세요.');
            return;
        }
        if(user_email.trim() === ''){
            alert('이메일을 입력하세요.');
            return;
        }
        if(!emailChk(user_email)){
            return;
        }
        if(user_zipcode.current?.value === ''){
            alert('주소를 입력하세요.');
            return;
        }
        if(user_tel1.trim() === '' || user_tel2.trim() === '' || user_tel3.trim() === ''){
            alert('전화번호를 입력하세요.');
            return;
        }
        if(user_type.trim() === ''){
            alert('회원유형을 선택해주세요.');
            return;
        }
        handlerSave();
    };

    return(
        <>
            <LoginModalStyled isOpen={modal} ariaHideApp={false}>
                <div className="wrap">
                    <div className="header">회원가입</div>
                    <LoginModalTableStyled>
                        <thead></thead>
                        <tbody>
                            <tr>
                                <th>아이디 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input 
                                        type="text" 
                                        name="loginID"
                                        placeholder="숫자, 영문자 조합으로 6~20자리"
                                        onChange={(e) => {setLoginID(e.target.value)}}>
                                    </input>
                                    <Button onClick={loginIdChk}>중복확인</Button>
                                </td>
                            </tr>
                            <tr>
                                <th>비밀번호 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input 
                                        type="password" 
                                        name="password" 
                                        placeholder="숫자, 영문자, 특수문자 조합으로 8~15자리"
                                        onChange={(e) => setPassword(e.target.value)}>
                                    </input>
                                </td>
                            </tr>
                            <tr>
                                <th>비밀번호 확인 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input 
                                        type="password"
                                        name="registerPwdOk"
                                        onChange={(e) => setRegisterPwdOk(e.target.value)}>
                                    </input>
                                </td>
                            </tr>
                            <tr>
                                <th>이름 <span className="font_red">*</span></th>
                                <td>
                                    <input 
                                        type="text"
                                        name="name"
                                        onChange={(e) => setName(e.target.value)}>
                                    </input>
                                </td>
                                <th>성별</th>
                                <td>
                                    <select name="gender_cd" defaultValue="" className="width_150" onChange={handlerGenderCd}>
                                        <option value="">선택</option>
                                        <option value="male">남자</option>
                                        <option value="female">여자</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>생년월일</th>
                                <td colSpan={3}><input type="date" name="birthday" ref={birthday}></input></td>
                            </tr>
                            <tr>
                                <th>이메일 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input 
                                        type="text" 
                                        name="user_email"
                                        onChange={(e) => setUser_email(e.target.value)}>
                                    </input>
                                </td>
                            </tr>
                            <tr>
                                <th>우편번호 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input 
                                        type="text" 
                                        name="user_zipcode" 
                                        className="width_150" 
                                        ref={user_zipcode} 
                                        readOnly>
                                    </input>
                                    <AddrModal
                                        zipCodeRef={user_zipcode}
                                        addressRef={user_address}
                                    ></AddrModal>
                                </td>
                            </tr>
                            <tr>
                                <th>주소 <span className="font_red">*</span></th>
                                <td colSpan={3}><input type="text" name="user_address" ref={user_address} readOnly></input></td>
                            </tr>
                            <tr>
                                <th>상세주소</th>
                                <td colSpan={3}><input type="text" name="user_dt_address" ref={user_dt_address}></input></td>
                            </tr>
                            <tr>
                                <th>전화번호 <span className="font_red">*</span></th>
                                <td colSpan={3}>
                                    <input
                                        type="text"
                                        name="user_tel1"
                                        className="width_150"
                                        onChange={handlerUserTel("tel1")}
                                        maxLength={3}>
                                    </input>
                                    -
                                    <input 
                                        type="text" 
                                        name="user_tel2" 
                                        className="width_150"
                                        onChange={handlerUserTel("tel2")}
                                        maxLength={4}>
                                    </input>
                                    -
                                    <input 
                                        type="text" 
                                        name="user_tel3" 
                                        className="width_150"
                                        onChange={handlerUserTel("tel3")}
                                        maxLength={4}>
                                    </input>
                                </td>
                            </tr>
                            <th>회원유형 <span className="font_red">*</span></th>
                            <td colSpan={3}>
                                <select name="user_type" defaultValue="" onChange={handlerUserType}>
                                    <option value="">선택</option>
                                    <option value="A">임직원</option>
                                    <option value="C">관리 사원</option>
                                    <option value="E">구매 담당</option>
                                    <option value="D">배송 담당</option>
                                    <option value="B" id="cust">고객</option>
                                </select>
                            </td>
                        </tbody>
                    </LoginModalTableStyled>
                    <div className="btn-group">
                        <Button onClick={handlerRegist}>회원가입 완료</Button>
                        <Button onClick={() => setModal(!modal)}>취소</Button>
                    </div>
                </div>
            </LoginModalStyled>
        </>
    );
}