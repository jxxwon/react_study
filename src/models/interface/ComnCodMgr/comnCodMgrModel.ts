export interface IComnCod {
    grp_cod: string;
    grp_cod_nm: string;
    use_poa: string;
    grp_cod_eplti: string;
};

export interface IComnCodList extends IComnCod {
    row_num:number;
    reg_date: string | null;
    fst_enlm_dtt: number;
    detailcnt: number;
};

export interface IComnDetailList extends IComnCod{
    row_num: number;
    dtl_cod: string;
    dtl_cod_nm: string;
    dtl_cod_eplti: string;
    use_poa: string;
    fst_enlm_dtt: string;
    fst_rgst_sst_id: string;
    fnl_mdfd_dtt: string;
}

export interface ISearchComnCod {
    totalCount: number;
    listComnGrpCodModel: IComnCodList[];
};

export interface IComnGrpCodModel {
    grp_cod: string;
    grp_cod_nm: string;
    grp_cod_eplti: string;
    use_poa: string;
}

export interface IListComnDtlCodJsonResponse {
    totalCntComnDtlCod: number;
    listComnDtlCodModel: IComnDetailList[];
    pageSize: number;
    currentPageComnDtlCod: number;
}

export interface IPostResponse {
    result: "SUCCESS";
}

export interface IDetailResponse extends IPostResponse { //IPostResponse
    comnGrpCodModel: IComnGrpCodModel;
    resultMsg: string;
}

export interface ISelectComnDtlCodResponse extends IPostResponse{
    comnDtlCodModel: IComnDtlCodModel;
};

export interface ISelectComnDtlCod extends IPostResponse{
    resultMsg: string;
}

export interface IComnDtlCodModel {
    row_num: number;
    grp_cod: string;
    grp_cod_nm: string;
    dtl_cod: string;
    dtl_cod_nm: string;
    dtl_cod_eplti: string;
    use_poa: string;
}
