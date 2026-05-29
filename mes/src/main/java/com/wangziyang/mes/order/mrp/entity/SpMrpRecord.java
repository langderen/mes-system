package com.wangziyang.mes.order.mrp.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_mrp_record")
public class SpMrpRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String mrpNo;
    private String orderCode;
    private String bomCode;
    private String productCode;
    private String productName;
    private String partCode;
    private String partName;
    private BigDecimal demandQty;
    private String unit;

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
}
