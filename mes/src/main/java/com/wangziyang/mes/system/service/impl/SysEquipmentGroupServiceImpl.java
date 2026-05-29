package com.wangziyang.mes.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.system.dto.SysEquipmentGroupDTO;
import com.wangziyang.mes.system.entity.SysEquipmentGroup;
import com.wangziyang.mes.system.entity.SysEquipmentGroupEquipment;
import com.wangziyang.mes.system.mapper.SysEquipmentGroupMapper;
import com.wangziyang.mes.system.service.ISysEquipmentGroupEquipmentService;
import com.wangziyang.mes.system.service.ISysEquipmentGroupService;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SysEquipmentGroupServiceImpl extends ServiceImpl<SysEquipmentGroupMapper, SysEquipmentGroup> implements ISysEquipmentGroupService {

    @Autowired
    private ISysEquipmentGroupEquipmentService sysEquipmentGroupEquipmentService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rebuildEquipmentGroupEquipment(SysEquipmentGroupDTO sysEquipmentGroupDTO) throws Exception {
        if (StringUtils.isNotEmpty(sysEquipmentGroupDTO.getId())) {
            QueryWrapper<SysEquipmentGroupEquipment> deleteWrapper = new QueryWrapper<>();
            deleteWrapper.eq("equipment_group_id", sysEquipmentGroupDTO.getId());
            sysEquipmentGroupEquipmentService.remove(deleteWrapper);
        }
        if (ArrayUtils.isNotEmpty(sysEquipmentGroupDTO.getEquipmentIds())) {
            for (String equipmentId : sysEquipmentGroupDTO.getEquipmentIds()) {
                if (StringUtils.isEmpty(equipmentId)) {
                    continue;
                }
                SysEquipmentGroupEquipment entity = new SysEquipmentGroupEquipment();
                entity.setEquipmentGroupId(sysEquipmentGroupDTO.getId());
                entity.setEquipmentId(equipmentId);
                sysEquipmentGroupEquipmentService.save(entity);
            }
        }
    }
}