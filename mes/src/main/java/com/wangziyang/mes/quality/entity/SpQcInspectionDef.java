package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName(value = "sp_qc_inspection_def")
public class SpQcInspectionDef extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String defCode;
    private String defName;
    private String inspectionType;
    private String productCode;
    private String productName;
    private String bomId;
    private String operId;
    private String inspectionMethod;
    private String inspectionItem;
    private String standardValue;
    private BigDecimal toleranceUpper;
    private BigDecimal toleranceLower;
    private String unit;
    private String samplePlan;
    private String aqlLevel;
    private Integer sampleQty;
    private String isCritical;
    private Integer sortNo;
    private String status;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getDefCode() { return defCode; }
    public void setDefCode(String defCode) { this.defCode = defCode; }
    public String getDefName() { return defName; }
    public void setDefName(String defName) { this.defName = defName; }
    public String getInspectionType() { return inspectionType; }
    public void setInspectionType(String inspectionType) { this.inspectionType = inspectionType; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }
    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }
    public String getInspectionMethod() { return inspectionMethod; }
    public void setInspectionMethod(String inspectionMethod) { this.inspectionMethod = inspectionMethod; }
    public String getInspectionItem() { return inspectionItem; }
    public void setInspectionItem(String inspectionItem) { this.inspectionItem = inspectionItem; }
    public String getStandardValue() { return standardValue; }
    public void setStandardValue(String standardValue) { this.standardValue = standardValue; }
    public BigDecimal getToleranceUpper() { return toleranceUpper; }
    public void setToleranceUpper(BigDecimal toleranceUpper) { this.toleranceUpper = toleranceUpper; }
    public BigDecimal getToleranceLower() { return toleranceLower; }
    public void setToleranceLower(BigDecimal toleranceLower) { this.toleranceLower = toleranceLower; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getSamplePlan() { return samplePlan; }
    public void setSamplePlan(String samplePlan) { this.samplePlan = samplePlan; }
    public String getAqlLevel() { return aqlLevel; }
    public void setAqlLevel(String aqlLevel) { this.aqlLevel = aqlLevel; }
    public Integer getSampleQty() { return sampleQty; }
    public void setSampleQty(Integer sampleQty) { this.sampleQty = sampleQty; }
    public String getIsCritical() { return isCritical; }
    public void setIsCritical(String isCritical) { this.isCritical = isCritical; }
    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}