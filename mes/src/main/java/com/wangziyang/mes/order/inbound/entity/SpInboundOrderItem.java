package com.wangziyang.mes.order.inbound.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_inbound_order_item")
public class SpInboundOrderItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String inboundOrderId;
    private String sourceMrpRecordId;
    private String mrpNo;
    private String orderCode;
    private String bomCode;
    private String productCode;
    private String productName;
    private String partCode;
    private String partName;
    private BigDecimal demandQty;
    private String unit;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getInboundOrderId() {
        return inboundOrderId;
    }

    public void setInboundOrderId(String inboundOrderId) {
        this.inboundOrderId = inboundOrderId;
    }

    public String getSourceMrpRecordId() {
        return sourceMrpRecordId;
    }

    public void setSourceMrpRecordId(String sourceMrpRecordId) {
        this.sourceMrpRecordId = sourceMrpRecordId;
    }

    public String getMrpNo() {
        return mrpNo;
    }

    public void setMrpNo(String mrpNo) {
        this.mrpNo = mrpNo;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getBomCode() {
        return bomCode;
    }

    public void setBomCode(String bomCode) {
        this.bomCode = bomCode;
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

    public BigDecimal getDemandQty() {
        return demandQty;
    }

    public void setDemandQty(BigDecimal demandQty) {
        this.demandQty = demandQty;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
