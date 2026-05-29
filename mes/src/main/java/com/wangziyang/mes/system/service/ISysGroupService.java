package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.dto.SysGroupDTO;
import com.wangziyang.mes.system.entity.SysGroup;

public interface ISysGroupService extends IService<SysGroup> {

    void rebuildGroupUser(SysGroupDTO sysGroupDTO) throws Exception;
}