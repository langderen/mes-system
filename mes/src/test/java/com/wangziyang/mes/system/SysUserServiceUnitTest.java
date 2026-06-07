package com.wangziyang.mes.system;

import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.mapper.SysUserMapper;
import com.wangziyang.mes.system.service.ISysMenuService;
import com.wangziyang.mes.system.service.ISysRoleService;
import com.wangziyang.mes.system.service.impl.SysUserServiceImpl;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * SysUserService 单元测试
 * 测试用户保存、更新、密码加密逻辑
 */
@RunWith(MockitoJUnitRunner.class)
public class SysUserServiceUnitTest {

    @Mock
    private SysUserMapper sysUserMapper;

    @Mock
    private ISysMenuService sysMenuService;

    @Mock
    private ISysRoleService sysRoleService;

    @InjectMocks
    private SysUserServiceImpl sysUserService;

    private SysUserDTO testUser;

    @Before
    public void setUp() {
        testUser = new SysUserDTO();
        testUser.setId("user-001");
        testUser.setUsername("testuser");
        testUser.setPassword("123456");
        testUser.setName("测试用户");
        testUser.setEmail("test@example.com");
        testUser.setSysRoleIds(new String[]{"role-001", "role-002"});
    }

    @Test
    public void testSave_passwordEncrypted() throws Exception {
        when(sysUserMapper.insert(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.save(testUser);

        // 密码应是 MD5(username + password, 3次) 的结果
        String expectedPassword = new Md5Hash("123456", "testuser", 3).toString();
        assertEquals(expectedPassword, testUser.getPassword());
        verify(sysUserMapper).insert(testUser);
        verify(sysRoleService).rebuild(testUser);
    }

    @Test
    public void testSave_passwordNotPlaintext() throws Exception {
        when(sysUserMapper.insert(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.save(testUser);

        assertNotEquals("密码不应为明文", "123456", testUser.getPassword());
        assertTrue("密码应为MD5格式(32位hex)", testUser.getPassword().matches("[a-f0-9]{32}"));
    }

    @Test
    public void testUpdate_withPassword() throws Exception {
        testUser.setPassword("newPassword");
        when(sysUserMapper.updateById(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.update(testUser);

        String expectedPassword = new Md5Hash("newPassword", "testuser", 3).toString();
        assertEquals(expectedPassword, testUser.getPassword());
        verify(sysUserMapper).updateById(testUser);
    }

    @Test
    public void testUpdate_withoutPassword() throws Exception {
        testUser.setPassword(null);
        when(sysUserMapper.updateById(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.update(testUser);

        assertNull("不传密码时password应为null", testUser.getPassword());
        verify(sysUserMapper).updateById(testUser);
    }

    @Test
    public void testUpdate_emptyPassword() throws Exception {
        testUser.setPassword("");
        when(sysUserMapper.updateById(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.update(testUser);

        assertNull("空字符串密码应设为null", testUser.getPassword());
    }

    @Test
    public void testSave_rolesRebuilt() throws Exception {
        when(sysUserMapper.insert(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.save(testUser);

        verify(sysRoleService).rebuild(testUser);
    }

    @Test
    public void testUpdate_rolesRebuilt() throws Exception {
        testUser.setPassword("newPass");
        when(sysUserMapper.updateById(any(SysUserDTO.class))).thenReturn(1);
        doNothing().when(sysRoleService).rebuild(any(SysUserDTO.class));

        sysUserService.update(testUser);

        verify(sysRoleService).rebuild(testUser);
    }
}