import { useEffect, useRef } from "react";
import { Button } from "../../../common/Button/Button";

const id = "daum-postcode"; // script가 이미 rending 되어 있는지 확인하기 위한 ID
const src = "//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js";

declare global {
  type DaumPostcodeData = {
    zonecode: number;
    address: string;
    addressEnglish: string;
    addressType: "R" | "J";
    userSelectedType: "R" | "J";
    noSelected: "Y" | "N";
    userLanguageType: "K" | "E";
    roadAddress: string;
  };

  type DaumPostcodeSearchData = {
    q?: string;
    count?: boolean;
  };

  type DaumPostcodeOption = {
    oncomplete?: (data: DaumPostcodeData) => void;
    onclose?: () => void;
    onresize?: () => void;
    onsearch?: (data: DaumPostcodeSearchData) => void;
    width?: number | string;
    height?: number | string;
    animation?: boolean;
    focusInput?: boolean;
    autoMapping?: boolean;
  };

  type PostcodeOperator = {
    open: () => void;
    embed: (wrap: Element, options: { q: string; autoClose: boolean }) => void;
  };

  interface Window {
    daum: {
      Postcode: new (options?: DaumPostcodeOption) => PostcodeOperator;
      postcode: {
        load: (fn: () => void) => void;
      };
    };
  }
}

// input에서 받을 수 있도록 prop 추가
interface AddrModalProps {
  zipCodeRef: React.RefObject<HTMLInputElement>;
  addressRef: React.RefObject<HTMLInputElement>;
}

export default function AddrModal({zipCodeRef, addressRef} : AddrModalProps) {
  const postcodeRef = useRef<HTMLDivElement | null>(null);

  const loadLayout = () => {
    window.daum.postcode.load(() => {
      const postcode = new window.daum.Postcode({
        oncomplete: function (data) {
          if (zipCodeRef.current) {
            zipCodeRef.current.value = data.zonecode.toString();
          }
          if (addressRef.current) {
            addressRef.current.value = data.roadAddress;
          }
        }
      });
      postcode.open();
    });
  };

  useEffect(() => {
    const isAlready = document.getElementById(id);

    if (!isAlready) {
      const script = document.createElement("script");
      script.src = src;
      script.id = id;
      document.body.append(script);
    }
  }, []);

  return (
    <>
        <Button onClick={loadLayout}>우편번호 찾기</Button>
    </>
  );
}