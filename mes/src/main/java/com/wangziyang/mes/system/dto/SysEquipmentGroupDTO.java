package com.wangziyang.mes.system.dto;

import com.wangziyang.mes.system.entity.SysEquipmentGroup;

public class SysEquipmentGroupDTO extends SysEquipmentGroup {

    private String[] equipmentIds;

    public String[] getEquipmentIds() {
        return equipmentIds;
    }

    public void setEquipmentIds(String[] equipmentIds) {
        this.equipmentIds = equipmentIds;
    }
}