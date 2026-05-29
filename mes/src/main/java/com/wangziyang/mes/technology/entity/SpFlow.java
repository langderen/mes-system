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
    private String productPartId;
    private String productPartCode;
    private String version;
    private String state;

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
    public String getProductPartId() { return this.productPartId; }
    public void setProductPartId(String productPartId) { this.productPartId = productPartId; }
    public String getProductPartCode() { return this.productPartCode; }
    public void setProductPartCode(String productPartCode) { this.productPartCode = productPartCode; }
    public String getVersion() { return this.version; }
    public void setVersion(String version) { this.version = version; }
    public String getState() { return this.state; }
    public void setState(String state) { this.state = state; }
    public String getDeleted() { return this.deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    @Override
    public String toString() {
        return "SpFlow{" +
            "flow=" + flow +
            ", flowDesc=" + flowDesc +
            ", process=" + process +
            ", flowType=" + flowType +
            ", productPartCode=" + productPartCode +
            "}";
    }
}
