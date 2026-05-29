package com.wangziyang.mes.system.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_sys_equipment_group_equipment")
public class SysEquipmentGroupEquipment extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String equipmentGroupId;

    private String equipmentId;

    public String getEquipmentGroupId() {
        return equipmentGroupId;
    }

    public void setEquipmentGroupId(String equipmentGroupId) {
        this.equipmentGroupId = equipmentGroupId;
    }

    public String getEquipmentId() {
        return equipmentId;
    }

    public void setEquipmentId(String equipmentId) {
        this.equipmentId = equipmentId;
    }
}