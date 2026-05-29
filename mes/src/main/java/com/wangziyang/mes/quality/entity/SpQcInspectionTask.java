package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName(value = "sp_qc_inspection_task")
public class SpQcInspectionTask extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String taskCode;
    private String planId;
    private String inspectionDefId;
    private String inspectorId;
    private String processUnitId;
    private BigDecimal assignedQty;
    private BigDecimal completedQty;
    private BigDecimal passQty;
    private BigDecimal failQty;
    private LocalDateTime assignTime;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getTaskCode() { return taskCode; }
    public void setTaskCode(String taskCode) { this.taskCode = taskCode; }
    public String getPlanId() { return planId; }
    public void setPlanId(String planId) { this.planId = planId; }
    public String getInspectionDefId() { return inspectionDefId; }
    public void setInspectionDefId(String inspectionDefId) { this.inspectionDefId = inspectionDefId; }
    public String getInspectorId() { return inspectorId; }
    public void setInspectorId(String inspectorId) { this.inspectorId = inspectorId; }
    public String getProcessUnitId() { return processUnitId; }
    public void setProcessUnitId(String processUnitId) { this.processUnitId = processUnitId; }
    public BigDecimal getAssignedQty() { return assignedQty; }
    public void setAssignedQty(BigDecimal assignedQty) { this.assignedQty = assignedQty; }
    public BigDecimal getCompletedQty() { return completedQty; }
    public void setCompletedQty(BigDecimal completedQty) { this.completedQty = completedQty; }
    public BigDecimal getPassQty() { return passQty; }
    public void setPassQty(BigDecimal passQty) { this.passQty = passQty; }
    public BigDecimal getFailQty() { return failQty; }
    public void setFailQty(BigDecimal failQty) { this.failQty = failQty; }
    public LocalDateTime getAssignTime() { return assignTime; }
    public void setAssignTime(LocalDateTime assignTime) { this.assignTime = assignTime; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}