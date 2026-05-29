package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.dto.SysEquipmentGroupDTO;
import com.wangziyang.mes.system.entity.SysEquipmentGroup;

public interface ISysEquipmentGroupService extends IService<SysEquipmentGroup> {

    void rebuildEquipmentGroupEquipment(SysEquipmentGroupDTO sysEquipmentGroupDTO) throws Exception;
}