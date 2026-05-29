package com.wangziyang.mes.productdata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName(value = "sp_product_bom_item")
public class SpProductBomItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String bomId;
    private String parentItemId;
    private String partId;
    private String partCode;
    private String partName;
    private Integer lineNo;
    private Integer levelNo;
    private BigDecimal qty;
    private String unit;
    private BigDecimal scrapRate;
    private String operId;
    private String operCode;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }
    public String getParentItemId() { return parentItemId; }
    public void setParentItemId(String parentItemId) { this.parentItemId = parentItemId; }
    public String getPartId() { return partId; }
    public void setPartId(String partId) { this.partId = partId; }
    public String getPartCode() { return partCode; }
    public void setPartCode(String partCode) { this.partCode = partCode; }
    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }
    public Integer getLineNo() { return lineNo; }
    public void setLineNo(Integer lineNo) { this.lineNo = lineNo; }
    public Integer getLevelNo() { return levelNo; }
    public void setLevelNo(Integer levelNo) { this.levelNo = levelNo; }
    public BigDecimal getQty() { return qty; }
    public void setQty(BigDecimal qty) { this.qty = qty; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public BigDecimal getScrapRate() { return scrapRate; }
    public void setScrapRate(BigDecimal scrapRate) { this.scrapRate = scrapRate; }
    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }
    public String getOperCode() { return operCode; }
    public void setOperCode(String operCode) { this.operCode = operCode; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
