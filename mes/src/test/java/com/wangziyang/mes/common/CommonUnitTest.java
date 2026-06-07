package com.wangziyang.mes.common;

import org.junit.Test;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

/**
 * 通用类单元测试
 * 测试 Result, BasePageReq, BaseEntity
 */
public class CommonUnitTest {

    // ==================== Result 测试 ====================

    @Test
    public void testResultSuccess_noData() {
        Result result = Result.success();
        assertNotNull(result);
        assertEquals(0, result.getCode().intValue());
        assertEquals("操作成功", result.getMsg());
        assertNull(result.getData());
    }

    @Test
    public void testResultSuccess_withData() {
        String data = "test-data";
        Result result = Result.success(data);
        assertEquals(0, result.getCode().intValue());
        assertEquals("操作成功", result.getMsg());
        assertEquals(data, result.getData());
    }

    @Test
    public void testResultError() {
        Result result = Result.error("自定义错误");
        assertEquals(1, result.getCode().intValue());
        assertEquals("自定义错误", result.getMsg());
        assertNull(result.getData());
    }

    @Test
    public void testResultError_default() {
        Result result = Result.error();
        assertEquals(1, result.getCode().intValue());
        assertEquals("操作失败", result.getMsg());
    }

    @Test
    public void testResultErrorWithCode() {
        Result result = Result.error(500, "服务器错误");
        assertEquals(500, result.getCode().intValue());
        assertEquals("服务器错误", result.getMsg());
    }

    @Test
    public void testResultSetAndGet() {
        Result result = new Result();
        result.setCode(200);
        result.setMsg("成功");
        result.setData("data");

        assertEquals(200, result.getCode().intValue());
        assertEquals("成功", result.getMsg());
        assertEquals("data", result.getData());
    }

    // ==================== BasePageReq 测试 ====================

    @Test
    public void testBasePageReq_defaultOrderBy() {
        BasePageReq req = new BasePageReq();
        assertEquals("update_time", req.getOrderBy());
    }

    @Test
    public void testBasePageReq_customOrderBy() {
        BasePageReq req = new BasePageReq();
        req.setOrderBy("create_time");
        assertEquals("create_time", req.getOrderBy());
    }

    @Test
    public void testBasePageReq_pagination() {
        BasePageReq req = new BasePageReq();
        req.setCurrent(3);
        req.setSize(20);
        assertEquals(3, (int) req.getCurrent());
        assertEquals(20, (int) req.getSize());
    }

    // ==================== BaseEntity 测试 ====================

    @Test
    public void testBaseEntity_setAndGet() {
        BaseEntity entity = new BaseEntity();
        entity.setId("1001");
        entity.setCreateUsername("admin");

        LocalDateTime now = LocalDateTime.now();
        entity.setCreateTime(now);
        entity.setUpdateTime(now);
        entity.setUpdateUsername("admin");

        assertEquals("1001", entity.getId());
        assertEquals("admin", entity.getCreateUsername());
        assertEquals(now, entity.getCreateTime());
        assertEquals(now, entity.getUpdateTime());
        assertEquals("admin", entity.getUpdateUsername());
    }

    @Test
    public void testBaseEntity_defaultValues() {
        BaseEntity entity = new BaseEntity();
        assertNull(entity.getId());
        assertNull(entity.getCreateTime());
        assertNull(entity.getCreateUsername());
        assertNull(entity.getUpdateTime());
        assertNull(entity.getUpdateUsername());
    }
}