package com.wangziyang.mes.productdata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpFlowPageReq extends BasePageReq {
    private String flowLike;
    private String flowDescLike;
    private String flowType;

    public String getFlowLike() { return flowLike; }
    public void setFlowLike(String flowLike) { this.flowLike = flowLike; }
    public String getFlowDescLike() { return flowDescLike; }
    public void setFlowDescLike(String flowDescLike) { this.flowDescLike = flowDescLike; }
    public String getFlowType() { return flowType; }
    public void setFlowType(String flowType) { this.flowType = flowType; }
}
