package com.wangziyang.mes.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.system.dto.SysGroupDTO;
import com.wangziyang.mes.system.entity.SysGroup;
import com.wangziyang.mes.system.entity.SysGroupUser;
import com.wangziyang.mes.system.mapper.SysGroupMapper;
import com.wangziyang.mes.system.service.ISysGroupService;
import com.wangziyang.mes.system.service.ISysGroupUserService;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SysGroupServiceImpl extends ServiceImpl<SysGroupMapper, SysGroup> implements ISysGroupService {

    @Autowired
    private ISysGroupUserService sysGroupUserService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rebuildGroupUser(SysGroupDTO sysGroupDTO) throws Exception {
        if (StringUtils.isNotEmpty(sysGroupDTO.getId())) {
            QueryWrapper<SysGroupUser> deleteWrapper = new QueryWrapper<>();
            deleteWrapper.eq("group_id", sysGroupDTO.getId());
            sysGroupUserService.remove(deleteWrapper);
        }
        if (ArrayUtils.isNotEmpty(sysGroupDTO.getUserIds())) {
            for (String userId : sysGroupDTO.getUserIds()) {
                if (StringUtils.isEmpty(userId)) {
                    continue;
                }
                SysGroupUser sysGroupUser = new SysGroupUser();
                sysGroupUser.setGroupId(sysGroupDTO.getId());
                sysGroupUser.setUserId(userId);
                sysGroupUserService.save(sysGroupUser);
            }
        }
    }
}