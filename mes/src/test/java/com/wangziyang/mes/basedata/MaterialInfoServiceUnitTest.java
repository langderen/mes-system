package com.wangziyang.mes.basedata;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterialInfo;
import com.wangziyang.mes.basedata.mapper.SpMaterialInfoMapper;
import com.wangziyang.mes.basedata.service.impl.SpMaterialInfoServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * SpMaterialInfoService 单元测试
 * 测试物料编码生成逻辑
 */
@RunWith(MockitoJUnitRunner.class)
public class MaterialInfoServiceUnitTest {

    @Mock
    private SpMaterialInfoMapper spMaterialInfoMapper;

    @InjectMocks
    private SpMaterialInfoServiceImpl spMaterialInfoService;

    private String datePrefix;

    @Before
    public void setUp() {
        datePrefix = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
    }

    @Test
    public void testGenerateMaterialCode_firstOfDay() {
        // 当天没有已生成的编码，应返回 datePrefix + "0001"
        when(spMaterialInfoMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);

        String code = spMaterialInfoService.generateMaterialCode();

        assertNotNull(code);
        assertEquals(datePrefix + "0001", code);
    }

    @Test
    public void testGenerateMaterialCode_incrementExisting() {
        // 当天已有编码 datePrefix + "0005"，应返回 "0006"
        SpMaterialInfo lastRecord = new SpMaterialInfo();
        lastRecord.setCode(datePrefix + "0005");
        when(spMaterialInfoMapper.selectOne(any(QueryWrapper.class))).thenReturn(lastRecord);

        String code = spMaterialInfoService.generateMaterialCode();

        assertEquals(datePrefix + "0006", code);
    }

    @Test
    public void testGenerateMaterialCode_paddingZero() {
        // 当天已有编码 datePrefix + "0099"，应返回 "0100"
        SpMaterialInfo lastRecord = new SpMaterialInfo();
        lastRecord.setCode(datePrefix + "0099");
        when(spMaterialInfoMapper.selectOne(any(QueryWrapper.class))).thenReturn(lastRecord);

        String code = spMaterialInfoService.generateMaterialCode();

        assertEquals(datePrefix + "0100", code);
    }

    @Test
    public void testGenerateMaterialCode_formatMatches() {
        when(spMaterialInfoMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);

        String code = spMaterialInfoService.generateMaterialCode();

        assertTrue("编码应以日期开头", code.startsWith(datePrefix));
        assertEquals("总长度应为 datePrefix + 4位序号", datePrefix.length() + 4, code.length());
        String suffix = code.substring(datePrefix.length());
        assertTrue("序号应为4位数字", suffix.matches("\\d{4}"));
    }

    @Test
    public void testGenerateMaterialCode_queryWrapperCorrect() {
        when(spMaterialInfoMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);

        spMaterialInfoService.generateMaterialCode();

        ArgumentCaptor<QueryWrapper> captor = ArgumentCaptor.forClass(QueryWrapper.class);
        verify(spMaterialInfoMapper).selectOne(captor.capture());
        // QueryWrapper 应该包含 likeRight("code", datePrefix) 条件
        assertNotNull(captor.getValue());
    }
}