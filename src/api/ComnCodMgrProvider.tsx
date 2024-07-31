import { FC, useState } from "react";
import { createContext } from "react";

interface Context {
    searchKeyword: object;
    setSearchKeyword: (keyword:object) => void
};

const defaultValue: Context = {
    searchKeyword: {},
    setSearchKeyword: () => {}, // 빈 함수
};

export const ComnCodContext = createContext(defaultValue);

export const ComnCodProvider: FC<{children:React.ReactNode | React.ReactNode[]}> = ({children}) => {
    const [searchKeyword, setSearchKeyword] = useState({});
    return <ComnCodContext.Provider value={{searchKeyword, setSearchKeyword}}>{children}</ComnCodContext.Provider>
};