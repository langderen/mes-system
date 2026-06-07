package com.wangziyang.mes.system;

import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.entity.SysRoleMenu;
import com.wangziyang.mes.system.entity.SysUserRole;
import com.wangziyang.mes.system.mapper.SysRoleMapper;
import com.wangziyang.mes.system.service.ISysRoleMenuService;
import com.wangziyang.mes.system.service.ISysUserRoleService;
import com.wangziyang.mes.system.service.impl.SysRoleServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * SysRoleService 单元测试
 * 测试角色重建、权限分配逻辑
 */
@RunWith(MockitoJUnitRunner.class)
public class SysRoleServiceUnitTest {

    @Mock
    private SysRoleMapper sysRoleMapper;

    @Mock
    private ISysUserRoleService sysUserRoleService;

    @Mock
    private ISysRoleMenuService sysRoleMenuService;

    @InjectMocks
    private SysRoleServiceImpl sysRoleService;

    private SysUserDTO testUser;

    @Before
    public void setUp() {
        testUser = new SysUserDTO();
        testUser.setId("user-001");
        testUser.setUsername("testuser");
        testUser.setSysRoleIds(new String[]{"role-001", "role-002"});
    }

    @Test
    public void testRebuild_clearOldRoles() throws Exception {
        when(sysUserRoleService.remove(any())).thenReturn(true);
        when(sysUserRoleService.save(any(SysUserRole.class))).thenReturn(true);

        sysRoleService.rebuild(testUser);

        // 验证：先删除旧关系
        verify(sysUserRoleService).remove(any());
    }

    @Test
    public void testRebuild_addNewRoles() throws Exception {
        when(sysUserRoleService.remove(any())).thenReturn(true);
        when(sysUserRoleService.save(any(SysUserRole.class))).thenReturn(true);

        sysRoleService.rebuild(testUser);

        // 验证：保存了2个新的角色关系
        ArgumentCaptor<SysUserRole> captor = ArgumentCaptor.forClass(SysUserRole.class);
        verify(sysUserRoleService, times(2)).save(captor.capture());
        List<SysUserRole> savedRoles = captor.getAllValues();
        assertEquals("user-001", savedRoles.get(0).getUserId());
        assertEquals("role-001", savedRoles.get(0).getRoleId());
        assertEquals("role-002", savedRoles.get(1).getRoleId());
    }

    @Test
    public void testRebuildRoleMenu_clearOldMenus() throws Exception {
        SysRoleDTO roleDTO = new SysRoleDTO();
        roleDTO.setId("role-001");
        roleDTO.setMenuIds(new String[]{"menu-001", "menu-002"});

        when(sysRoleMenuService.remove(any())).thenReturn(true);
        when(sysRoleMenuService.save(any(SysRoleMenu.class))).thenReturn(true);

        sysRoleService.rebuildRoleMenu(roleDTO);

        verify(sysRoleMenuService).remove(any());
    }

    @Test
    public void testRebuildRoleMenu_addNewMenus() throws Exception {
        SysRoleDTO roleDTO = new SysRoleDTO();
        roleDTO.setId("role-001");
        roleDTO.setMenuIds(new String[]{"menu-001", "menu-002", "menu-003"});

        when(sysRoleMenuService.remove(any())).thenReturn(true);
        when(sysRoleMenuService.save(any(SysRoleMenu.class))).thenReturn(true);

        sysRoleService.rebuildRoleMenu(roleDTO);

        ArgumentCaptor<SysRoleMenu> captor = ArgumentCaptor.forClass(SysRoleMenu.class);
        verify(sysRoleMenuService, times(3)).save(captor.capture());
    }

    @Test
    public void testRebuild_emptyRoleIds() throws Exception {
        testUser.setSysRoleIds(new String[]{});

        when(sysUserRoleService.remove(any())).thenReturn(true);

        sysRoleService.rebuild(testUser);

        verify(sysUserRoleService).remove(any());
        verify(sysUserRoleService, never()).save(any(SysUserRole.class));
    }

    @Test
    public void testRebuild_nullRoleIds() throws Exception {
        testUser.setSysRoleIds(null);

        when(sysUserRoleService.remove(any())).thenReturn(true);

        sysRoleService.rebuild(testUser);

        verify(sysUserRoleService).remove(any());
        verify(sysUserRoleService, never()).save(any(SysUserRole.class));
    }
}