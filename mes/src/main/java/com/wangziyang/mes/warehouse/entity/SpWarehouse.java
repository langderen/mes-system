package com.wangziyang.mes.warehouse.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_warehouse")
public class SpWarehouse extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String code;

    private String name;

    private String type;

    private String address;

    private String status;

    private String descr;

    private BigDecimal totalInventory;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescr() {
        return descr;
    }

    public void setDescr(String descr) {
        this.descr = descr;
    }

    public BigDecimal getTotalInventory() {
        return totalInventory;
    }

    public void setTotalInventory(BigDecimal totalInventory) {
        this.totalInventory = totalInventory;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
