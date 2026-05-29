package com.wangziyang.mes.system.dto;

import com.wangziyang.mes.system.entity.SysMenu;

import java.util.List;

/**
 * <p>
 *
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
public class SysMenuDTO extends SysMenu {

    private boolean checked;

    private List<SysMenuDTO> children;

    public boolean getChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public List<SysMenuDTO> getChildren() {
        return children;
    }

    public void setChildren(List<SysMenuDTO> children) {
        this.children = children;
    }
}
