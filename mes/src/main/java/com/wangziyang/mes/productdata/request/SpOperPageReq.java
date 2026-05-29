package com.wangziyang.mes.productdata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpOperPageReq extends BasePageReq {
    private String operLike;
    private String operDescLike;
    private String operType;

    public String getOperLike() { return operLike; }
    public void setOperLike(String operLike) { this.operLike = operLike; }
    public String getOperDescLike() { return operDescLike; }
    public void setOperDescLike(String operDescLike) { this.operDescLike = operDescLike; }
    public String getOperType() { return operType; }
    public void setOperType(String operType) { this.operType = operType; }
}
