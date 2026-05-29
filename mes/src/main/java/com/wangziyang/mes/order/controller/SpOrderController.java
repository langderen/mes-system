package com.wangziyang.mes.order.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.mrp.entity.SpMrpRecord;
import com.wangziyang.mes.order.mrp.service.ISpMrpRecordService;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.production.entity.SpDispatchOrder;
import com.wangziyang.mes.production.service.ISpDispatchOrderService;
import com.wangziyang.mes.productdata.entity.SpProductBom;
import com.wangziyang.mes.productdata.entity.SpProductBomItem;
import com.wangziyang.mes.productdata.service.ISpProductBomItemService;
import com.wangziyang.mes.productdata.service.ISpProductBomService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order/release")
public class SpOrderController extends BaseController {

    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpDispatchOrderService dispatchOrderService;

    @Autowired
    private ISpProductBomService productBomService;

    @Autowired
    private ISpProductBomItemService bomItemService;

    @Autowired
    private ISpMrpRecordService mrpRecordService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "order/production/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        SpOrder result = StringUtils.isNotBlank(id) ? orderService.getById(id) : new SpOrder();
        if (result == null) {
            result = new SpOrder();
        }
        model.addAttribute("result", result);
        return "order/production/addOrUpdate";
    }

    @GetMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String orderCode, String orderDescription, Integer statue) {
        Page<SpOrder> page = new Page<>(current == null ? 1 : current, size == null ? 20 : size);
        QueryWrapper<SpOrder> wrapper = new QueryWrapper<SpOrder>().orderByDesc("create_time");
        if (StringUtils.isNotBlank(orderCode)) {
            wrapper.like("order_code", orderCode);
        }
        if (StringUtils.isNotBlank(orderDescription)) {
            wrapper.like("order_description", orderDescription);
        }
        if (statue != null) {
            wrapper.eq("statue", statue);
        }
        IPage<SpOrder> result = orderService.page(page, wrapper);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOrder record) {
        if (record.getStatue() == null) {
            record.setStatue(1);
        }
        orderService.saveOrUpdate(record);
        return Result.success(record);
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        if (StringUtils.isBlank(id)) {
            return Result.failure("parameter is required");
        }
        orderService.removeById(id);
        return Result.success();
    }

    @PostMapping("/approve")
    @ResponseBody
    public Result approve(String id) {
        SpOrder order = orderService.getById(id);
        if (order == null) {
            return Result.failure("production order not found");
        }
        order.setStatue(3);
        orderService.updateById(order);
        return Result.success();
    }

    @PostMapping("/execute")
    @ResponseBody
    public Result execute(String id) {
        SpOrder order = orderService.getById(id);
        if (order == null) {
            return Result.failure("production order not found");
        }
        if (order.getStatue() == null || order.getStatue() < 3) {
            return Result.failure("order is not approved");
        }
        if (StringUtils.isNotBlank(order.getGeneratedPlanNo()) || StringUtils.isNotBlank(order.getGeneratedMrpNo())) {
            return Result.failure("order already executed");
        }

        String planNo = buildDocumentNo("PLAN");
        String mrpNo = buildDocumentNo("MRP");

        SpDispatchOrder plan = new SpDispatchOrder();
        plan.setOrderNo(planNo);
        plan.setProductCode(order.getMateriel());
        plan.setProductName(order.getMaterielDesc());
        plan.setQty(order.getQty() == null ? BigDecimal.ZERO : order.getQty());
        plan.setPlanStartTime(parseDateTime(order.getPlanStartTime()));
        plan.setPlanEndTime(parseDateTime(order.getPlanEndTime()));
        plan.setPriority(2);
        plan.setStatus("draft");
        plan.setSourceOrderNo(order.getOrderCode());
        plan.setRemark(order.getOrderDescription());
        dispatchOrderService.save(plan);

        List<Map<String, Object>> mrpDetails = buildMrpDetails(order);
        saveMrpDetails(mrpNo, order, mrpDetails);

        order.setGeneratedPlanNo(planNo);
        order.setGeneratedMrpNo(mrpNo);
        order.setApprovalStatus("executed");
        order.setStatue(4);
        orderService.updateById(order);

        Map<String, Object> result = new HashMap<>();
        result.put("orderCode", order.getOrderCode());
        result.put("planNo", planNo);
        result.put("mrpNo", mrpNo);
        result.put("mrpDetails", mrpDetails);
        return Result.success(result, "execution completed, plan and mrp generated");
    }

    @ResponseBody
    @RequestMapping(value = "/gantt/list", method = RequestMethod.POST, produces = "application/json")
    public Result getListGantt(Map<String, Object> params) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<SpOrder> orders = orderService.list(new QueryWrapper<SpOrder>().orderByDesc("create_time").last("limit 20"));
        for (SpOrder order : orders) {
            Map<String, Object> node = new HashMap<>(8);
            node.put("id", order.getId());
            node.put("name", order.getOrderCode());
            node.put("desc", order.getOrderDescription());
            List<Map<String, Object>> values = new ArrayList<>();
            Map<String, Object> value = new HashMap<>(8);
            value.put("from", "/Date(" + System.currentTimeMillis() + ")/");
            value.put("to", "/Date(" + (System.currentTimeMillis() + 86400000L) + ")/");
            value.put("label", order.getStatue() != null && order.getStatue() >= 3 ? "approved" : "pending");
            value.put("desc", StringUtils.defaultIfBlank(order.getSourceOrderNo(), order.getOrderCode()));
            value.put("customClass", order.getStatue() != null && order.getStatue() >= 3 ? "ganttGreen" : "ganttRed");
            values.add(value);
            node.put("cssClass", "redLabel");
            node.put("values", values);
            result.add(node);
        }
        return Result.success(result);
    }

    private String buildDocumentNo(String prefix) {
        return prefix + "-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private LocalDateTime parseDateTime(String value) {
        if (StringUtils.isBlank(value)) {
            return null;
        }
        return LocalDateTime.parse(value, DATETIME_FORMATTER);
    }

    private List<Map<String, Object>> buildMrpDetails(SpOrder order) {
        List<Map<String, Object>> details = new ArrayList<>();
        if (StringUtils.isBlank(order.getMateriel())) {
            return details;
        }
        SpProductBom bom = productBomService.getOne(new QueryWrapper<SpProductBom>()
                .eq("product_part_code", order.getMateriel())
                .eq("is_deleted", "0")
                .orderByDesc("update_time")
                .last("limit 1"));
        if (bom == null) {
            return details;
        }
        List<SpProductBomItem> items = bomItemService.list(new QueryWrapper<SpProductBomItem>()
                .eq("bom_id", bom.getId())
                .eq("is_deleted", "0")
                .orderByAsc("level_no", "line_no"));
        BigDecimal qty = order.getQty() == null ? BigDecimal.ZERO : order.getQty();
        Map<String, BigDecimal> demandQtyMap = new HashMap<>();
        Map<String, SpProductBomItem> leafItemMap = new HashMap<>();
        Map<String, List<SpProductBomItem>> childrenMap = buildBomChildrenMap(items);
        List<SpProductBomItem> rootItems = new ArrayList<>();
        for (SpProductBomItem item : items) {
            if (StringUtils.isBlank(item.getParentItemId())) {
                rootItems.add(item);
            }
        }
        for (SpProductBomItem rootItem : rootItems) {
            collectLeafDemand(rootItem, qty, childrenMap, demandQtyMap, leafItemMap);
        }
        for (Map.Entry<String, BigDecimal> entry : demandQtyMap.entrySet()) {
            SpProductBomItem leafItem = leafItemMap.get(entry.getKey());
            if (leafItem == null) {
                continue;
            }
            Map<String, Object> detail = new HashMap<>();
            detail.put("partCode", leafItem.getPartCode());
            detail.put("partName", leafItem.getPartName());
            detail.put("qty", entry.getValue());
            detail.put("unit", leafItem.getUnit());
            detail.put("sourceOrderNo", order.getOrderCode());
            detail.put("bomCode", bom.getBomCode());
            details.add(detail);
        }
        return details;
    }

    private Map<String, List<SpProductBomItem>> buildBomChildrenMap(List<SpProductBomItem> items) {
        Map<String, List<SpProductBomItem>> childrenMap = new HashMap<>();
        for (SpProductBomItem item : items) {
            if (StringUtils.isBlank(item.getParentItemId())) {
                continue;
            }
            childrenMap.computeIfAbsent(item.getParentItemId(), key -> new ArrayList<>()).add(item);
        }
        return childrenMap;
    }

    private void collectLeafDemand(SpProductBomItem currentItem,
                                   BigDecimal parentDemandQty,
                                   Map<String, List<SpProductBomItem>> childrenMap,
                                   Map<String, BigDecimal> demandQtyMap,
                                   Map<String, SpProductBomItem> leafItemMap) {
        BigDecimal itemQty = currentItem.getQty() == null ? BigDecimal.ONE : currentItem.getQty();
        BigDecimal currentDemandQty = parentDemandQty.multiply(itemQty);
        List<SpProductBomItem> children = childrenMap.get(currentItem.getId());
        if (children == null || children.isEmpty()) {
            String partCode = currentItem.getPartCode();
            if (StringUtils.isBlank(partCode)) {
                return;
            }
            demandQtyMap.merge(partCode, currentDemandQty, BigDecimal::add);
            leafItemMap.putIfAbsent(partCode, currentItem);
            return;
        }
        for (SpProductBomItem child : children) {
            collectLeafDemand(child, currentDemandQty, childrenMap, demandQtyMap, leafItemMap);
        }
    }

    private void saveMrpDetails(String mrpNo, SpOrder order, List<Map<String, Object>> mrpDetails) {
        if (mrpDetails.isEmpty()) {
            return;
        }
        List<SpMrpRecord> records = new ArrayList<>();
        for (Map<String, Object> detail : mrpDetails) {
            SpMrpRecord record = new SpMrpRecord();
            record.setMrpNo(mrpNo);
            record.setOrderCode(order.getOrderCode());
            record.setBomCode((String) detail.get("bomCode"));
            record.setProductCode(order.getMateriel());
            record.setProductName(order.getMaterielDesc());
            record.setPartCode((String) detail.get("partCode"));
            record.setPartName((String) detail.get("partName"));
            record.setDemandQty(new BigDecimal(detail.get("qty").toString()));
            record.setUnit((String) detail.get("unit"));
            records.add(record);
        }
        mrpRecordService.saveBatch(records);
    }
}
