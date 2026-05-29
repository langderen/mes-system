package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.time.LocalDateTime;

@TableName(value = "sp_qc_inspection_data")
public class SpQcInspectionData extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String recordId;
    private String taskId;
    private String parameterName;
    private String parameterCode;
    private String measuredValue;
    private String standardValue;
    private String minValue;
    private String maxValue;
    private String unit;
    private String isPass;
    private LocalDateTime collectTime;
    private String collectMethod;
    private String equipmentId;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getRecordId() { return recordId; }
    public void setRecordId(String recordId) { this.recordId = recordId; }
    public String getTaskId() { return taskId; }
    public void setTaskId(String taskId) { this.taskId = taskId; }
    public String getParameterName() { return parameterName; }
    public void setParameterName(String parameterName) { this.parameterName = parameterName; }
    public String getParameterCode() { return parameterCode; }
    public void setParameterCode(String parameterCode) { this.parameterCode = parameterCode; }
    public String getMeasuredValue() { return measuredValue; }
    public void setMeasuredValue(String measuredValue) { this.measuredValue = measuredValue; }
    public String getStandardValue() { return standardValue; }
    public void setStandardValue(String standardValue) { this.standardValue = standardValue; }
    public String getMinValue() { return minValue; }
    public void setMinValue(String minValue) { this.minValue = minValue; }
    public String getMaxValue() { return maxValue; }
    public void setMaxValue(String maxValue) { this.maxValue = maxValue; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getIsPass() { return isPass; }
    public void setIsPass(String isPass) { this.isPass = isPass; }
    public LocalDateTime getCollectTime() { return collectTime; }
    public void setCollectTime(LocalDateTime collectTime) { this.collectTime = collectTime; }
    public String getCollectMethod() { return collectMethod; }
    public void setCollectMethod(String collectMethod) { this.collectMethod = collectMethod; }
    public String getEquipmentId() { return equipmentId; }
    public void setEquipmentId(String equipmentId) { this.equipmentId = equipmentId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}