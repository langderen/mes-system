package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpFlowCategoryPageReq extends BasePageReq {
    private String categoryCodeLike;
    private String categoryNameLike;

    public String getCategoryCodeLike() {
        return categoryCodeLike;
    }

    public void setCategoryCodeLike(String categoryCodeLike) {
        this.categoryCodeLike = categoryCodeLike;
    }

    public String getCategoryNameLike() {
        return categoryNameLike;
    }

    public void setCategoryNameLike(String categoryNameLike) {
        this.categoryNameLike = categoryNameLike;
    }
}
