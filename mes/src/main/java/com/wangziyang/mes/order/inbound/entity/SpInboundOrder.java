package com.wangziyang.mes.order.inbound.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_inbound_order")
public class SpInboundOrder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String inboundNo;
    private String sourceMrpNos;
    private String status;
    private Integer itemCount;
    private BigDecimal totalDemandQty;
    private String remark;
    private String warehouseId;
    private String warehouseLocationId;
    private String warehouseLocationIds;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getInboundNo() {
        return inboundNo;
    }

    public void setInboundNo(String inboundNo) {
        this.inboundNo = inboundNo;
    }

    public String getSourceMrpNos() {
        return sourceMrpNos;
    }

    public void setSourceMrpNos(String sourceMrpNos) {
        this.sourceMrpNos = sourceMrpNos;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public BigDecimal getTotalDemandQty() {
        return totalDemandQty;
    }

    public void setTotalDemandQty(BigDecimal totalDemandQty) {
        this.totalDemandQty = totalDemandQty;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getWarehouseLocationId() {
        return warehouseLocationId;
    }

    public void setWarehouseLocationId(String warehouseLocationId) {
        this.warehouseLocationId = warehouseLocationId;
    }

    public String getWarehouseLocationIds() {
        return warehouseLocationIds;
    }

    public void setWarehouseLocationIds(String warehouseLocationIds) {
        this.warehouseLocationIds = warehouseLocationIds;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
