package com.wangziyang.mes.productdata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpProductBomPageReq extends BasePageReq {
    private String bomCodeLike;
    private String bomNameLike;
    private String bomType;
    private String state;

    public String getBomCodeLike() { return bomCodeLike; }
    public void setBomCodeLike(String bomCodeLike) { this.bomCodeLike = bomCodeLike; }
    public String getBomNameLike() { return bomNameLike; }
    public void setBomNameLike(String bomNameLike) { this.bomNameLike = bomNameLike; }
    public String getBomType() { return bomType; }
    public void setBomType(String bomType) { this.bomType = bomType; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
}
