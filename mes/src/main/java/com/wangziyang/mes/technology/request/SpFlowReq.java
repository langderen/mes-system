package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;
/**
 * 流程分页对象
 * @author wangziyang
 * @since 2020/03/15
 */
public class SpFlowReq extends BasePageReq {
    private String flowLike;
    private String flowDescLike;
    private String flowCategoryId;

    public String getFlowLike() {
        return flowLike;
    }

    public void setFlowLike(String flowLike) {
        this.flowLike = flowLike;
    }

    public String getFlowDescLike() {
        return flowDescLike;
    }

    public void setFlowDescLike(String flowDescLike) {
        this.flowDescLike = flowDescLike;
    }

    public String getFlowCategoryId() {
        return flowCategoryId;
    }

    public void setFlowCategoryId(String flowCategoryId) {
        this.flowCategoryId = flowCategoryId;
    }
}
