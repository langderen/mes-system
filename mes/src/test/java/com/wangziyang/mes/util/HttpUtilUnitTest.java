package com.wangziyang.mes.util;

import com.wangziyang.mes.common.util.HttpUtil;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import static org.junit.Assert.*;

/**
 * HttpUtil 单元测试
 */
public class HttpUtilUnitTest {

    @Test
    public void testIsAjax_true() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("x-requested-with", "XMLHttpRequest");
        assertTrue("Ajax请求应返回true", HttpUtil.isAjax(request));
    }

    @Test
    public void testIsAjax_false_noHeader() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        assertFalse("无X-Requested-With头应返回false", HttpUtil.isAjax(request));
    }

    @Test
    public void testIsAjax_false_wrongValue() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("x-requested-with", "not-ajax");
        assertFalse("X-Requested-With值不正确应返回false", HttpUtil.isAjax(request));
    }

    @Test
    public void testIsAjax_false_emptyValue() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("x-requested-with", "");
        assertFalse("空值应返回false", HttpUtil.isAjax(request));
    }
}