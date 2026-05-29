package com.wangziyang.mes.productdata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpPartPageReq extends BasePageReq {
    private String partCodeLike;
    private String partNameLike;
    private String partType;

    public String getPartCodeLike() { return partCodeLike; }
    public void setPartCodeLike(String partCodeLike) { this.partCodeLike = partCodeLike; }
    public String getPartNameLike() { return partNameLike; }
    public void setPartNameLike(String partNameLike) { this.partNameLike = partNameLike; }
    public String getPartType() { return partType; }
    public void setPartType(String partType) { this.partType = partType; }
}
