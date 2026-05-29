package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName(value = "sp_flow")
public class SpFlow extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String flow;
    private String flowDesc;
    private String process;
    private String flowType;
    private String flowCategoryId;
    private String flowCategoryName;
    private String productPartId;
    private String productPartCode;
    private String version;
    private String state;
    private String scriptContent;
    private String bindType;
    private String buttonCode;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getFlow() { return this.flow; }
    public void setFlow(String flow) { this.flow = flow; }
    public String getFlowDesc() { return this.flowDesc; }
    public void setFlowDesc(String flowDesc) { this.flowDesc = flowDesc; }
    public String getProcess() { return this.process; }
    public void setProcess(String process) { this.process = process; }
    public String getFlowType() { return this.flowType; }
    public void setFlowType(String flowType) { this.flowType = flowType; }
    public String getFlowCategoryId() { return this.flowCategoryId; }
    public void setFlowCategoryId(String flowCategoryId) { this.flowCategoryId = flowCategoryId; }
    public String getFlowCategoryName() { return this.flowCategoryName; }
    public void setFlowCategoryName(String flowCategoryName) { this.flowCategoryName = flowCategoryName; }
    public String getProductPartId() { return this.productPartId; }
    public void setProductPartId(String productPartId) { this.productPartId = productPartId; }
    public String getProductPartCode() { return this.productPartCode; }
    public void setProductPartCode(String productPartCode) { this.productPartCode = productPartCode; }
    public String getVersion() { return this.version; }
    public void setVersion(String version) { this.version = version; }
    public String getState() { return this.state; }
    public void setState(String state) { this.state = state; }
    public String getScriptContent() { return this.scriptContent; }
    public void setScriptContent(String scriptContent) { this.scriptContent = scriptContent; }
    public String getBindType() { return this.bindType; }
    public void setBindType(String bindType) { this.bindType = bindType; }
    public String getButtonCode() { return this.buttonCode; }
    public void setButtonCode(String buttonCode) { this.buttonCode = buttonCode; }
    public String getDeleted() { return this.deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    @Override
    public String toString() {
        return "SpFlow{" +
            "flow=" + flow +
            ", flowDesc=" + flowDesc +
            ", process=" + process +
            ", flowType=" + flowType +
            ", flowCategoryName=" + flowCategoryName +
            ", productPartCode=" + productPartCode +
            "}";
    }
}
