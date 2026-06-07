package com.wangziyang.mes.util;

import com.wangziyang.mes.common.util.HashUtil;
import com.wangziyang.mes.common.util.IdUtil;
import org.junit.Test;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Set;

import static org.junit.Assert.*;

/**
 * 工具类单元测试
 * 测试 IdUtil, HashUtil 的核心逻辑
 */
public class UtilUnitTest {

    // ==================== HashUtil 测试 ====================

    @Test
    public void testSha1AsBytes_shouldReturn20Bytes() {
        byte[] result = HashUtil.sha1AsBytes("hello");
        assertEquals("SHA-1 应产生20字节", 20, result.length);
    }

    @Test
    public void testSha1AsBytes_sameInputSameOutput() {
        byte[] result1 = HashUtil.sha1AsBytes("test");
        byte[] result2 = HashUtil.sha1AsBytes("test");
        assertArrayEquals("相同输入应产生相同哈希", result1, result2);
    }

    @Test
    public void testSha1AsBytes_differentInputDifferentOutput() {
        byte[] result1 = HashUtil.sha1AsBytes("abc");
        byte[] result2 = HashUtil.sha1AsBytes("abd");
        boolean allSame = true;
        for (int i = 0; i < result1.length; i++) {
            if (result1[i] != result2[i]) {
                allSame = false;
                break;
            }
        }
        assertFalse("不同输入应产生不同哈希", allSame);
    }

    @Test
    public void testSha1AsBytes_emptyString() {
        byte[] result = HashUtil.sha1AsBytes("");
        assertNotNull("空字符串也能产生哈希", result);
        assertEquals(20, result.length);
    }

    @Test
    public void testSha1AsBytes_chineseString() {
        byte[] result = HashUtil.sha1AsBytes("中文测试");
        assertNotNull("中文字符串也能产生哈希", result);
        assertEquals(20, result.length);
    }

    // ==================== IdUtil 测试 ====================

    @Test
    public void testNextId_notNull() {
        String id = IdUtil.nextId();
        assertNotNull("生成的ID不应为null", id);
    }

    @Test
    public void testNextId_notEmpty() {
        String id = IdUtil.nextId();
        assertFalse("生成的ID不应为空", id.isEmpty());
    }

    @Test
    public void testNextId_isNumeric() {
        String id = IdUtil.nextId();
        assertTrue("生成的ID应为纯数字", id.matches("\\d+"));
    }

    @Test
    public void testNextId_uniqueness() {
        Set<String> ids = new HashSet<>();
        for (int i = 0; i < 1000; i++) {
            String id = IdUtil.nextId();
            assertFalse("生成的ID应唯一", ids.contains(id));
            ids.add(id);
        }
    }

    @Test
    public void testNextId_positive() {
        String id = IdUtil.nextId();
        long longId = Long.parseLong(id);
        assertTrue("生成的ID应为正数", longId > 0);
    }

    @Test
    public void testNextId_increasing() {
        String id1 = IdUtil.nextId();
        String id2 = IdUtil.nextId();
        assertTrue("后生成的ID应大于先生成的ID", Long.parseLong(id2) > Long.parseLong(id1));
    }

    @Test
    public void testStringIdToLongId_invalidInput() {
        try {
            IdUtil.stringIdToLongId("invalid");
            fail("无效输入应抛出异常");
        } catch (IllegalArgumentException e) {
            assertEquals("Invalid id: invalid", e.getMessage());
        }
    }

    @Test
    public void testStringIdToLongId_nullInput() {
        try {
            IdUtil.stringIdToLongId(null);
            fail("null输入应抛出异常");
        } catch (Exception e) {
            assertTrue(e instanceof IllegalArgumentException || e instanceof NullPointerException);
        }
    }

    @Test
    public void testStringIdToLongId_emptyInput() {
        try {
            IdUtil.stringIdToLongId("");
            fail("空字符串应抛出异常");
        } catch (IllegalArgumentException e) {
            assertTrue(e.getMessage().contains("Invalid id"));
        }
    }
}