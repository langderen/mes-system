package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpSopContentReq extends BasePageReq {
    private String sopCodeLike;
    private String sopNameLike;
    private String productCodeLike;
    private String operCodeLike;
    private String state;

    public String getSopCodeLike() {
        return sopCodeLike;
    }

    public void setSopCodeLike(String sopCodeLike) {
        this.sopCodeLike = sopCodeLike;
    }

    public String getSopNameLike() {
        return sopNameLike;
    }

    public void setSopNameLike(String sopNameLike) {
        this.sopNameLike = sopNameLike;
    }

    public String getProductCodeLike() {
        return productCodeLike;
    }

    public void setProductCodeLike(String productCodeLike) {
        this.productCodeLike = productCodeLike;
    }

    public String getOperCodeLike() {
        return operCodeLike;
    }

    public void setOperCodeLike(String operCodeLike) {
        this.operCodeLike = operCodeLike;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}
