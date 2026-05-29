package com.wangziyang.mes.system.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_sys_process_unit")
public class SysProcessUnit extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String code;

    private String name;

    private String groupId;

    private String equipmentGroupId;

    private BigDecimal dailyStandardCapacity;

    private String hasLimitedSideStorage;

    private BigDecimal sideStorageCapacity;

    private String status;

    private String descr;

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

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getEquipmentGroupId() {
        return equipmentGroupId;
    }

    public void setEquipmentGroupId(String equipmentGroupId) {
        this.equipmentGroupId = equipmentGroupId;
    }

    public BigDecimal getDailyStandardCapacity() {
        return dailyStandardCapacity;
    }

    public void setDailyStandardCapacity(BigDecimal dailyStandardCapacity) {
        this.dailyStandardCapacity = dailyStandardCapacity;
    }

    public String getHasLimitedSideStorage() {
        return hasLimitedSideStorage;
    }

    public void setHasLimitedSideStorage(String hasLimitedSideStorage) {
        this.hasLimitedSideStorage = hasLimitedSideStorage;
    }

    public BigDecimal getSideStorageCapacity() {
        return sideStorageCapacity;
    }

    public void setSideStorageCapacity(BigDecimal sideStorageCapacity) {
        this.sideStorageCapacity = sideStorageCapacity;
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

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}