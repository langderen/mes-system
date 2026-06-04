package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("sp_sop_content")
public class SpSopContent extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String sopCode;
    private String sopName;
    private String productId;
    private String productCode;
    private String productName;
    private String partId;
    private String partCode;
    private String partName;
    private String flowDefinitionId;
    private String operId;
    private String operCode;
    private String operName;
    private String contentOverview;
    private String processRequirement;
    private BigDecimal standardCapacity;
    private Integer personnelRequirement;
    private String laborProtection;
    private String remark;
    private String version;
    private String state;
    private String isLatest;
    private String compileUserId;
    private String compileUsername;
    private LocalDateTime compileDate;
    private LocalDateTime submitAuditTime;
    private LocalDateTime auditTime;
    private String auditUsername;
    private String auditComment;
    private LocalDateTime publishTime;
    private String publishUserId;
    private String deleted;

    public String getSopCode() {
        return sopCode;
    }

    public void setSopCode(String sopCode) {
        this.sopCode = sopCode;
    }

    public String getSopName() {
        return sopName;
    }

    public void setSopName(String sopName) {
        this.sopName = sopName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getPartId() {
        return partId;
    }

    public void setPartId(String partId) {
        this.partId = partId;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public String getFlowDefinitionId() {
        return flowDefinitionId;
    }

    public void setFlowDefinitionId(String flowDefinitionId) {
        this.flowDefinitionId = flowDefinitionId;
    }

    public String getOperId() {
        return operId;
    }

    public void setOperId(String operId) {
        this.operId = operId;
    }

    public String getOperCode() {
        return operCode;
    }

    public void setOperCode(String operCode) {
        this.operCode = operCode;
    }

    public String getOperName() {
        return operName;
    }

    public void setOperName(String operName) {
        this.operName = operName;
    }

    public String getContentOverview() {
        return contentOverview;
    }

    public void setContentOverview(String contentOverview) {
        this.contentOverview = contentOverview;
    }

    public String getProcessRequirement() {
        return processRequirement;
    }

    public void setProcessRequirement(String processRequirement) {
        this.processRequirement = processRequirement;
    }

    public BigDecimal getStandardCapacity() {
        return standardCapacity;
    }

    public void setStandardCapacity(BigDecimal standardCapacity) {
        this.standardCapacity = standardCapacity;
    }

    public Integer getPersonnelRequirement() {
        return personnelRequirement;
    }

    public void setPersonnelRequirement(Integer personnelRequirement) {
        this.personnelRequirement = personnelRequirement;
    }

    public String getLaborProtection() {
        return laborProtection;
    }

    public void setLaborProtection(String laborProtection) {
        this.laborProtection = laborProtection;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getIsLatest() {
        return isLatest;
    }

    public void setIsLatest(String isLatest) {
        this.isLatest = isLatest;
    }

    public String getCompileUserId() {
        return compileUserId;
    }

    public void setCompileUserId(String compileUserId) {
        this.compileUserId = compileUserId;
    }

    public String getCompileUsername() {
        return compileUsername;
    }

    public void setCompileUsername(String compileUsername) {
        this.compileUsername = compileUsername;
    }

    public LocalDateTime getCompileDate() {
        return compileDate;
    }

    public void setCompileDate(LocalDateTime compileDate) {
        this.compileDate = compileDate;
    }

    public LocalDateTime getSubmitAuditTime() {
        return submitAuditTime;
    }

    public void setSubmitAuditTime(LocalDateTime submitAuditTime) {
        this.submitAuditTime = submitAuditTime;
    }

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    public String getAuditUsername() {
        return auditUsername;
    }

    public void setAuditUsername(String auditUsername) {
        this.auditUsername = auditUsername;
    }

    public String getAuditComment() {
        return auditComment;
    }

    public void setAuditComment(String auditComment) {
        this.auditComment = auditComment;
    }

    public LocalDateTime getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(LocalDateTime publishTime) {
        this.publishTime = publishTime;
    }

    public String getPublishUserId() {
        return publishUserId;
    }

    public void setPublishUserId(String publishUserId) {
        this.publishUserId = publishUserId;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
