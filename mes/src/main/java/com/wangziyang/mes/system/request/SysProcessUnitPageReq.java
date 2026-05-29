package com.wangziyang.mes.system.request;

import com.wangziyang.mes.common.BasePageReq;

public class SysProcessUnitPageReq extends BasePageReq {

    private String nameLike;

    private String codeLike;

    public String getNameLike() {
        return nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }

    public String getCodeLike() {
        return codeLike;
    }

    public void setCodeLike(String codeLike) {
        this.codeLike = codeLike;
    }
}