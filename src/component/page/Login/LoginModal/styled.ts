import ReactModal from "react-modal";
import styled from "styled-components";

export const LoginModalStyled = styled(ReactModal)`
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1;
    font-weight: bold;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    .header {
        display: flex;
        align-items: center;
        padding: 16px;
        font-size: 20px;
        margin-right: auto;
    }

    .wrap {
        display: flex;
        min-width: 304px;
        padding: 16px;
        justify-content: center;
        align-items: center;
        flex-shrink: 0;
        border-radius: 12px;
        background: #fff;
        flex-direction: column;
    }

    select,
    input[type='text'], [type='password'], [type='date'] {
        padding: 8px;
        margin-top: 5px;
        margin-bottom: 5px;
        border-radius: 4px;
        border: 1px solid #ccc;
        width: 70%;
    }

    .font_red {
        color: red;
    }

    td .width_150 {
        width:150px;
    }
`;

export const LoginModalTableStyled = styled.table`

    margin-bottom: auto;
    th,
    td {
        padding: 8px;
        border-bottom: 1px solid #ddd;
        text-align: left;
    }

    th {
        background-color: #2676bf;
        color: #ddd;
        text-align: center;
    }
`;