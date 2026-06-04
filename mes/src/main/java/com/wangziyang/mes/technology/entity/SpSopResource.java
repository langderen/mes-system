package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_sop_resource")
public class SpSopResource extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String sopContentId;
    private String resourceType;
    private String resourceId;
    private String resourceCode;
    private String resourceName;
    private String model;
    private String settingCondition;
    private Integer sortNum;
    private String deleted;

    public String getSopContentId() {
        return sopContentId;
    }

    public void setSopContentId(String sopContentId) {
        this.sopContentId = sopContentId;
    }

    public String getResourceType() {
        return resourceType;
    }

    public void setResourceType(String resourceType) {
        this.resourceType = resourceType;
    }

    public String getResourceId() {
        return resourceId;
    }

    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }

    public String getResourceCode() {
        return resourceCode;
    }

    public void setResourceCode(String resourceCode) {
        this.resourceCode = resourceCode;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getSettingCondition() {
        return settingCondition;
    }

    public void setSettingCondition(String settingCondition) {
        this.settingCondition = settingCondition;
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
