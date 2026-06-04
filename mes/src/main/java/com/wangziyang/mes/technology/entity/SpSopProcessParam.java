package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_sop_process_param")
public class SpSopProcessParam extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String sopContentId;
    private String workStepId;
    private String paramName;
    private String paramValue;
    private String paramUnit;
    private Integer sortNum;
    private String deleted;

    public String getSopContentId() {
        return sopContentId;
    }

    public void setSopContentId(String sopContentId) {
        this.sopContentId = sopContentId;
    }

    public String getWorkStepId() {
        return workStepId;
    }

    public void setWorkStepId(String workStepId) {
        this.workStepId = workStepId;
    }

    public String getParamName() {
        return paramName;
    }

    public void setParamName(String paramName) {
        this.paramName = paramName;
    }

    public String getParamValue() {
        return paramValue;
    }

    public void setParamValue(String paramValue) {
        this.paramValue = paramValue;
    }

    public String getParamUnit() {
        return paramUnit;
    }

    public void setParamUnit(String paramUnit) {
        this.paramUnit = paramUnit;
    }

    public Integer getSortNum() {
        return sortNum;
    }

    public void setSortNum(Integer sortNum) {
        this.sortNum = sortNum;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
