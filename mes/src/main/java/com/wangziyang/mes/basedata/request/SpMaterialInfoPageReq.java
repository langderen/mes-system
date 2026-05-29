package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpMaterialInfoPageReq extends BasePageReq {

    private String codeLike;

    private String nameLike;

    private String matTypeLike;

    public String getCodeLike() {
        return codeLike;
    }

    public void setCodeLike(String codeLike) {
        this.codeLike = codeLike;
    }

    public String getNameLike() {
        return nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }

    public String getMatTypeLike() {
        return matTypeLike;
    }

    public void setMatTypeLike(String matTypeLike) {
        this.matTypeLike = matTypeLike;
    }
}