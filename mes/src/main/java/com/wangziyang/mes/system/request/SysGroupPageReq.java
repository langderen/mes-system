package com.wangziyang.mes.system.request;

import com.wangziyang.mes.common.BasePageReq;

public class SysGroupPageReq extends BasePageReq {

    private String nameLike;

    public String getNameLike() {
        return nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }
}