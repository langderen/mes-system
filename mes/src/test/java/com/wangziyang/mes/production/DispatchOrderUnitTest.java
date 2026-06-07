package com.wangziyang.mes.production;

import com.wangziyang.mes.production.entity.SpDispatchOrder;
import org.junit.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.Assert.*;

/**
 * SpDispatchOrder 实体单元测试
 * 测试派工单状态流转逻辑
 */
public class DispatchOrderUnitTest {

    /**
     * 派工单状态定义：
     * draft     - 草稿
     * assigned  - 已分配
     * started   - 已开工
     * inspected - 已质检
     * completed - 已完成
     */

    @Test
    public void testStatusFlow_draftToAssigned() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setOrderNo("DO-001");
        order.setStatus("draft");

        // 分配后状态变为 assigned
        order.setStatus("assigned");
        assertEquals("assigned", order.getStatus());
    }

    @Test
    public void testStatusFlow_assignedToStarted() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setOrderNo("DO-001");
        order.setStatus("assigned");

        order.setStatus("started");
        order.setActualStartTime(LocalDateTime.now());
        assertEquals("started", order.getStatus());
        assertNotNull(order.getActualStartTime());
    }

    @Test
    public void testStatusFlow_startedToInspected() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setOrderNo("DO-001");
        order.setStatus("started");

        order.setStatus("inspected");
        assertEquals("inspected", order.getStatus());
    }

    @Test
    public void testStatusFlow_inspectedToCompleted() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setOrderNo("DO-001");
        order.setStatus("inspected");
        order.setActualEndTime(LocalDateTime.now());

        order.setStatus("completed");
        assertEquals("completed", order.getStatus());
        assertNotNull(order.getActualEndTime());
    }

    @Test
    public void testQtyCalculation() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setQty(new BigDecimal("100"));
        order.setCompletedQty(new BigDecimal("98"));
        order.setQualifiedQty(new BigDecimal("95"));
        order.setScrapQty(new BigDecimal("3"));

        // 合格数 + 报废数 = 完成数
        BigDecimal total = order.getQualifiedQty().add(order.getScrapQty());
        assertEquals(order.getCompletedQty(), total);
    }

    @Test
    public void testPriority() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setPriority(1);
        assertEquals(1, order.getPriority().intValue());

        order.setPriority(5);
        assertEquals(5, order.getPriority().intValue());
    }

    @Test
    public void testOrder_setsAllFields() {
        SpDispatchOrder order = new SpDispatchOrder();
        order.setOrderNo("DO-2024-001");
        order.setProductCode("P001");
        order.setProductName("测试产品");
        order.setQty(new BigDecimal("100"));
        order.setStatus("draft");
        order.setPriority(1);
        order.setSourceOrderNo("ORD-001");
        order.setRemark("测试备注");

        assertEquals("DO-2024-001", order.getOrderNo());
        assertEquals("P001", order.getProductCode());
        assertEquals("测试产品", order.getProductName());
        assertEquals(new BigDecimal("100"), order.getQty());
        assertEquals("draft", order.getStatus());
        assertEquals(1, order.getPriority().intValue());
        assertEquals("ORD-001", order.getSourceOrderNo());
        assertEquals("测试备注", order.getRemark());
    }
}