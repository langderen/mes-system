package com.wangziyang.mes.entity;

import com.wangziyang.mes.basedata.entity.SpMaterialInfo;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.entity.SysRole;
import org.junit.Test;

import java.math.BigDecimal;

import static org.junit.Assert.*;

/**
 * 实体类单元测试
 * 测试实体类的 getter/setter 方法
 */
public class EntityUnitTest {

    // ==================== SysUser 测试 ====================

    @Test
    public void testSysUser_setAndGet() {
        SysUser user = new SysUser();
        user.setId("1001");
        user.setName("张三");
        user.setUsername("zhangsan");
        user.setPassword("encrypted");
        user.setEmail("zhangsan@example.com");
        user.setMobile("13800138000");
        user.setSex("1");
        user.setDeleted("0");

        assertEquals("1001", user.getId());
        assertEquals("张三", user.getName());
        assertEquals("zhangsan", user.getUsername());
        assertEquals("encrypted", user.getPassword());
        assertEquals("zhangsan@example.com", user.getEmail());
        assertEquals("13800138000", user.getMobile());
        assertEquals("1", user.getSex());
        assertEquals("0", user.getDeleted());
    }

    @Test
    public void testSysUser_defaultValues() {
        SysUser user = new SysUser();
        assertNull(user.getName());
        assertNull(user.getUsername());
        assertNull(user.getPassword());
        assertNull(user.getDeleted());
    }

    // ==================== SysRole 测试 ====================

    @Test
    public void testSysRole_setAndGet() {
        SysRole role = new SysRole();
        role.setId("role-001");
        role.setName("管理员");
        role.setCode("ADMIN");
        role.setDescr("系统管理员角色");
        role.setDeleted("0");

        assertEquals("role-001", role.getId());
        assertEquals("管理员", role.getName());
        assertEquals("ADMIN", role.getCode());
        assertEquals("系统管理员角色", role.getDescr());
        assertEquals("0", role.getDeleted());
    }

    // ==================== SpMaterialInfo 测试 ====================

    @Test
    public void testSpMaterialInfo_setAndGet() {
        SpMaterialInfo material = new SpMaterialInfo();
        material.setCode("MAT-001");
        material.setName("钢板");
        material.setMatType("原材料");
        material.setMatSource("国内");
        material.setUnit("kg");
        material.setTexture("304不锈钢");
        material.setLeadTime(new BigDecimal("5.5"));
        material.setSafetyStock(new BigDecimal("100"));
        material.setModel("GB-304");
        material.setSize("2000*1000*2");
        material.setDescr("测试物料");

        assertEquals("MAT-001", material.getCode());
        assertEquals("钢板", material.getName());
        assertEquals("原材料", material.getMatType());
        assertEquals("国内", material.getMatSource());
        assertEquals("kg", material.getUnit());
        assertEquals("304不锈钢", material.getTexture());
        assertEquals(new BigDecimal("5.5"), material.getLeadTime());
        assertEquals(new BigDecimal("100"), material.getSafetyStock());
        assertEquals("GB-304", material.getModel());
        assertEquals("2000*1000*2", material.getSize());
        assertEquals("测试物料", material.getDescr());
    }

    @Test
    public void testSpMaterialInfo_defaultValues() {
        SpMaterialInfo material = new SpMaterialInfo();
        assertNull(material.getCode());
        assertNull(material.getName());
        assertNull(material.getLeadTime());
        assertNull(material.getSafetyStock());
    }
}