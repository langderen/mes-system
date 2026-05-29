package com.wangziyang.mes.system.dto;

import com.wangziyang.mes.system.entity.SysRole;

import java.util.List;

/**
 * <p>
 *
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
public class SysRoleDTO extends SysRole {

    /**
     * 角色是否选中
     */
    private boolean checked;

    /**
     * 菜单ID列表
     */
    private String[] menuIds;

    /**
     * 菜单列表
     */
    List<SysMenuDTO> sysMenuDtos;

    public boolean getChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public String[] getMenuIds() {
        return menuIds;
    }

    public void setMenuIds(String[] menuIds) {
        this.menuIds = menuIds;
    }

    public List<SysMenuDTO> getSysMenuDtos() {
        return sysMenuDtos;
    }

    public void setSysMenuDtos(List<SysMenuDTO> sysMenuDtos) {
        this.sysMenuDtos = sysMenuDtos;
    }
}
