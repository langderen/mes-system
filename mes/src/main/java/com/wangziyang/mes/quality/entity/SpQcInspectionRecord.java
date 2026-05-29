package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName(value = "sp_qc_inspection_record")
public class SpQcInspectionRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String recordCode;
    private String taskId;
    private String inspectionDefId;
    private String inspectorId;
    private LocalDateTime inspectionTime;
    private String result;
    private String defectType;
    private String defectDesc;
    private BigDecimal defectQty;
    private String defectSeverity;
    private String measuredValue;
    private String standardValue;
    private String handleMethod;
    private String handleRemark;
    private String attachment;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getRecordCode() { return recordCode; }
    public void setRecordCode(String recordCode) { this.recordCode = recordCode; }
    public String getTaskId() { return taskId; }
    public void setTaskId(String taskId) { this.taskId = taskId; }
    public String getInspectionDefId() { return inspectionDefId; }
    public void setInspectionDefId(String inspectionDefId) { this.inspectionDefId = inspectionDefId; }
    public String getInspectorId() { return inspectorId; }
    public void setInspectorId(String inspectorId) { this.inspectorId = inspectorId; }
    public LocalDateTime getInspectionTime() { return inspectionTime; }
    public void setInspectionTime(LocalDateTime inspectionTime) { this.inspectionTime = inspectionTime; }
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    public String getDefectType() { return defectType; }
    public void setDefectType(String defectType) { this.defectType = defectType; }
    public String getDefectDesc() { return defectDesc; }
    public void setDefectDesc(String defectDesc) { this.defectDesc = defectDesc; }
    public BigDecimal getDefectQty() { return defectQty; }
    public void setDefectQty(BigDecimal defectQty) { this.defectQty = defectQty; }
    public String getDefectSeverity() { return defectSeverity; }
    public void setDefectSeverity(String defectSeverity) { this.defectSeverity = defectSeverity; }
    public String getMeasuredValue() { return measuredValue; }
    public void setMeasuredValue(String measuredValue) { this.measuredValue = measuredValue; }
    public String getStandardValue() { return standardValue; }
    public void setStandardValue(String standardValue) { this.standardValue = standardValue; }
    public String getHandleMethod() { return handleMethod; }
    public void setHandleMethod(String handleMethod) { this.handleMethod = handleMethod; }
    public String getHandleRemark() { return handleRemark; }
    public void setHandleRemark(String handleRemark) { this.handleRemark = handleRemark; }
    public String getAttachment() { return attachment; }
    public void setAttachment(String attachment) { this.attachment = attachment; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}