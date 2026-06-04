package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_sop_quality_control")
public class SpSopQualityControl extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String sopContentId;
    private String workStepId;
    private String checkContent;
    private String checkStandard;
    private String defectHandling;
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

    public String getCheckContent() {
        return checkContent;
    }

    public void setCheckContent(String checkContent) {
        this.checkContent = checkContent;
    }

    public String getCheckStandard() {
        return checkStandard;
    }

    public void setCheckStandard(String checkStandard) {
        this.checkStandard = checkStandard;
    }

    public String getDefectHandling() {
        return defectHandling;
    }

    public void setDefectHandling(String defectHandling) {
        this.defectHandling = defectHandling;
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
