package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName(value = "sp_qc_inspection_plan")
public class SpQcInspectionPlan extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String planCode;
    private String planName;
    private String activityId;
    private String inspectionDefId;
    private String orderId;
    private String productCode;
    private BigDecimal planQty;
    private BigDecimal completedQty;
    private BigDecimal passQty;
    private BigDecimal failQty;
    private LocalDateTime planStartTime;
    private LocalDateTime planEndTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime actualEndTime;
    private String status;
    private Integer priority;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getPlanCode() { return planCode; }
    public void setPlanCode(String planCode) { this.planCode = planCode; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public String getActivityId() { return activityId; }
    public void setActivityId(String activityId) { this.activityId = activityId; }
    public String getInspectionDefId() { return inspectionDefId; }
    public void setInspectionDefId(String inspectionDefId) { this.inspectionDefId = inspectionDefId; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public BigDecimal getPlanQty() { return planQty; }
    public void setPlanQty(BigDecimal planQty) { this.planQty = planQty; }
    public BigDecimal getCompletedQty() { return completedQty; }
    public void setCompletedQty(BigDecimal completedQty) { this.completedQty = completedQty; }
    public BigDecimal getPassQty() { return passQty; }
    public void setPassQty(BigDecimal passQty) { this.passQty = passQty; }
    public BigDecimal getFailQty() { return failQty; }
    public void setFailQty(BigDecimal failQty) { this.failQty = failQty; }
    public LocalDateTime getPlanStartTime() { return planStartTime; }
    public void setPlanStartTime(LocalDateTime planStartTime) { this.planStartTime = planStartTime; }
    public LocalDateTime getPlanEndTime() { return planEndTime; }
    public void setPlanEndTime(LocalDateTime planEndTime) { this.planEndTime = planEndTime; }
    public LocalDateTime getActualStartTime() { return actualStartTime; }
    public void setActualStartTime(LocalDateTime actualStartTime) { this.actualStartTime = actualStartTime; }
    public LocalDateTime getActualEndTime() { return actualEndTime; }
    public void setActualEndTime(LocalDateTime actualEndTime) { this.actualEndTime = actualEndTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getPriority() { return priority; }
    public void setPriority(Integer priority) { this.priority = priority; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}