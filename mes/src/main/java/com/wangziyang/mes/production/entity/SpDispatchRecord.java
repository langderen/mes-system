package com.wangziyang.mes.production.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName(value = "sp_dispatch_record")
public class SpDispatchRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String dispatchOrderId;
    private String dispatchType;
    private String teamId;
    private String operatorId;
    private String userId;
    private String processUnitId;
    private String equipmentId;
    private BigDecimal planQty;
    private BigDecimal completedQty;
    private BigDecimal qualifiedQty;
    private BigDecimal scrapQty;
    private BigDecimal workHours;
    private LocalDateTime dispatchTime;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getDispatchOrderId() { return dispatchOrderId; }
    public void setDispatchOrderId(String dispatchOrderId) { this.dispatchOrderId = dispatchOrderId; }
    public String getDispatchType() { return dispatchType; }
    public void setDispatchType(String dispatchType) { this.dispatchType = dispatchType; }
    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }
    public String getOperatorId() { return operatorId; }
    public void setOperatorId(String operatorId) { this.operatorId = operatorId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getProcessUnitId() { return processUnitId; }
    public void setProcessUnitId(String processUnitId) { this.processUnitId = processUnitId; }
    public String getEquipmentId() { return equipmentId; }
    public void setEquipmentId(String equipmentId) { this.equipmentId = equipmentId; }
    public BigDecimal getPlanQty() { return planQty; }
    public void setPlanQty(BigDecimal planQty) { this.planQty = planQty; }
    public BigDecimal getCompletedQty() { return completedQty; }
    public void setCompletedQty(BigDecimal completedQty) { this.completedQty = completedQty; }
    public BigDecimal getQualifiedQty() { return qualifiedQty; }
    public void setQualifiedQty(BigDecimal qualifiedQty) { this.qualifiedQty = qualifiedQty; }
    public BigDecimal getScrapQty() { return scrapQty; }
    public void setScrapQty(BigDecimal scrapQty) { this.scrapQty = scrapQty; }
    public BigDecimal getWorkHours() { return workHours; }
    public void setWorkHours(BigDecimal workHours) { this.workHours = workHours; }
    public LocalDateTime getDispatchTime() { return dispatchTime; }
    public void setDispatchTime(LocalDateTime dispatchTime) { this.dispatchTime = dispatchTime; }
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