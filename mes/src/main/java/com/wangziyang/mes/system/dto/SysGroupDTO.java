package com.wangziyang.mes.system.dto;

import com.wangziyang.mes.system.entity.SysGroup;

public class SysGroupDTO extends SysGroup {

    private String[] userIds;

    public String[] getUserIds() {
        return userIds;
    }

    public void setUserIds(String[] userIds) {
        this.userIds = userIds;
    }
}