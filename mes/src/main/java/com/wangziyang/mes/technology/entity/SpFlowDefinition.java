package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName(value = "sp_flow_definition")
public class SpFlowDefinition extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String flowCode;
    private String flowName;
    private String flowCategoryId;
    private String flowCategoryName;
    private String flowType;
    private String version;
    private String state;
    private String description;
    private String bindType;
    private String buttonCode;
    private String scriptContent;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getFlowCode() { return flowCode; }
    public void setFlowCode(String flowCode) { this.flowCode = flowCode; }
    public String getFlowName() { return flowName; }
    public void setFlowName(String flowName) { this.flowName = flowName; }
    public String getFlowCategoryId() { return flowCategoryId; }
    public void setFlowCategoryId(String flowCategoryId) { this.flowCategoryId = flowCategoryId; }
    public String getFlowCategoryName() { return flowCategoryName; }
    public void setFlowCategoryName(String flowCategoryName) { this.flowCategoryName = flowCategoryName; }
    public String getFlowType() { return flowType; }
    public void setFlowType(String flowType) { this.flowType = flowType; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getBindType() { return bindType; }
    public void setBindType(String bindType) { this.bindType = bindType; }
    public String getButtonCode() { return buttonCode; }
    public void setButtonCode(String buttonCode) { this.buttonCode = buttonCode; }
    public String getScriptContent() { return scriptContent; }
    public void setScriptContent(String scriptContent) { this.scriptContent = scriptContent; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    @Override
    public String toString() {
        return "SpFlowDefinition{" +
            "flowCode=" + flowCode +
            ", flowName=" + flowName +
            ", flowCategoryName=" + flowCategoryName +
            ", flowType=" + flowType +
            ", version=" + version +
            "}";
    }
}
