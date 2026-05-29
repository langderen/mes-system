package com.wangziyang.mes.order.inbound.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.inbound.entity.SpInboundOrder;
import com.wangziyang.mes.order.inbound.entity.SpInboundOrderItem;
import com.wangziyang.mes.order.inbound.service.ISpInboundOrderItemService;
import com.wangziyang.mes.order.inbound.service.ISpInboundOrderService;
import com.wangziyang.mes.order.mrp.entity.SpMrpRecord;
import com.wangziyang.mes.order.mrp.service.ISpMrpRecordService;
import com.wangziyang.mes.warehouse.entity.SpWarehouse;
import com.wangziyang.mes.warehouse.entity.SpWarehouseLocation;
import com.wangziyang.mes.warehouse.service.ISpWarehouseLocationService;
import com.wangziyang.mes.warehouse.service.ISpWarehouseService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

@Controller
@RequestMapping("/order/inbound")
public class SpInboundOrderController extends BaseController {

    private static final DateTimeFormatter NO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    @Autowired
    private ISpInboundOrderService inboundOrderService;

    @Autowired
    private ISpInboundOrderItemService inboundOrderItemService;

    @Autowired
    private ISpMrpRecordService mrpRecordService;

    @Autowired
    private ISpWarehouseService warehouseService;

    @Autowired
    private ISpWarehouseLocationService warehouseLocationService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "order/inbound/list";
    }

    @GetMapping("/detail-ui")
    public String detailUI(Model model, String id) {
        SpInboundOrder order = inboundOrderService.getById(id);
        model.addAttribute("result", order);
        if (order != null) {
            List<SpInboundOrderItem> items = inboundOrderItemService.list(new QueryWrapper<SpInboundOrderItem>()
                    .eq("inbound_order_id", id)
                    .eq("is_deleted", "0")
                    .orderByAsc("create_time"));
            model.addAttribute("items", items);
        }
        return "order/inbound/detail";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String inboundNo, String status, String sourceMrpNos) {
        Page<SpInboundOrder> page = new Page<>(current == null ? 1 : current, size == null ? 20 : size);
        QueryWrapper<SpInboundOrder> wrapper = new QueryWrapper<SpInboundOrder>()
                .eq("is_deleted", "0")
                .orderByDesc("create_time");
        if (StringUtils.isNotBlank(inboundNo)) {
            wrapper.like("inbound_no", inboundNo);
        }
        if (StringUtils.isNotBlank(status)) {
            wrapper.eq("status", status);
        }
        if (StringUtils.isNotBlank(sourceMrpNos)) {
            wrapper.like("source_mrp_nos", sourceMrpNos);
        }
        IPage<SpInboundOrder> result = inboundOrderService.page(page, wrapper);
        return Result.success(result);
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        SpInboundOrder order = inboundOrderService.getById(id);
        return order != null ? Result.success(order) : Result.failure("数据不存在");
    }

    @PostMapping("/generate")
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Result generate(String mrpIds) {
        return generateInternal(mrpIds, null, null);
    }

    @PostMapping("/generate-and-confirm")
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Result generateAndConfirm(String mrpIds, String warehouseId, String warehouseLocationId) {
        if (StringUtils.isBlank(warehouseId)) {
            return Result.failure("请选择库房");
        }
        return generateInternal(mrpIds, warehouseId, warehouseLocationId);
    }

    private Result generateInternal(String mrpIds, String warehouseId, String warehouseLocationId) {
        if (StringUtils.isBlank(mrpIds)) {
            return Result.failure("请选择要生成入库单的物料需求");
        }

        List<String> selectedIds = new ArrayList<>();
        for (String id : mrpIds.split(",")) {
            if (StringUtils.isNotBlank(id)) {
                selectedIds.add(id.trim());
            }
        }
        if (selectedIds.isEmpty()) {
            return Result.failure("请选择要生成入库单的物料需求");
        }

        List<SpMrpRecord> mrpRecords = new ArrayList<>(mrpRecordService.listByIds(selectedIds));
        if (mrpRecords.size() != selectedIds.size()) {
            return Result.failure("部分MRP数据已不存在，请刷新后重新选择");
        }

        List<SpInboundOrderItem> items = new ArrayList<>();
        StringJoiner mrpNoJoiner = new StringJoiner(",");
        BigDecimal totalQty = BigDecimal.ZERO;

        for (SpMrpRecord mrpRecord : mrpRecords) {
            List<SpInboundOrderItem> matched = inboundOrderItemService.list(new QueryWrapper<SpInboundOrderItem>()
                    .eq("source_mrp_record_id", mrpRecord.getId())
                    .eq("is_deleted", "0"));
            if (!matched.isEmpty()) {
                return Result.failure("选中的物料需求中存在已生成入库单的数据，请重新选择");
            }

            SpInboundOrderItem item = new SpInboundOrderItem();
            item.setSourceMrpRecordId(mrpRecord.getId());
            item.setMrpNo(mrpRecord.getMrpNo());
            item.setOrderCode(mrpRecord.getOrderCode());
            item.setBomCode(mrpRecord.getBomCode());
            item.setProductCode(mrpRecord.getProductCode());
            item.setProductName(mrpRecord.getProductName());
            item.setPartCode(mrpRecord.getPartCode());
            item.setPartName(mrpRecord.getPartName());
            item.setDemandQty(mrpRecord.getDemandQty());
            item.setUnit(mrpRecord.getUnit());
            item.setDeleted("0");
            items.add(item);

            if (StringUtils.isNotBlank(mrpRecord.getMrpNo())) {
                mrpNoJoiner.add(mrpRecord.getMrpNo());
            }
            if (mrpRecord.getDemandQty() != null) {
                totalQty = totalQty.add(mrpRecord.getDemandQty());
            }
        }

        String inboundNo = "IB-" + LocalDateTime.now().format(NO_FORMATTER);
        SpInboundOrder order = new SpInboundOrder();
        order.setInboundNo(inboundNo);
        order.setSourceMrpNos(mrpNoJoiner.toString());
        order.setStatus("draft");
        order.setItemCount(items.size());
        order.setTotalDemandQty(totalQty);
        order.setWarehouseId(warehouseId);
        order.setWarehouseLocationId(warehouseLocationId);
        order.setDeleted("0");
        inboundOrderService.save(order);

        for (SpInboundOrderItem item : items) {
            item.setInboundOrderId(order.getId());
        }
        inboundOrderItemService.saveBatch(items);

        if (StringUtils.isNotBlank(warehouseId)) {
            applyInventory(order, items, warehouseId, warehouseLocationId);
            order.setStatus("confirmed");
            inboundOrderService.updateById(order);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("id", order.getId());
        result.put("inboundNo", inboundNo);
        result.put("itemCount", items.size());
        result.put("totalDemandQty", totalQty);
        result.put("sourceMrpNos", order.getSourceMrpNos());
        result.put("status", order.getStatus());
        result.put("warehouseId", order.getWarehouseId());
        result.put("warehouseLocationId", order.getWarehouseLocationId());
        result.put("warehouseLocationIds", order.getWarehouseLocationIds());
        return Result.success(result, "计划入库单生成成功");
    }

    @PostMapping("/confirm")
    @ResponseBody
    public Result confirm(String id, String warehouseId, String warehouseLocationId) {
        SpInboundOrder order = inboundOrderService.getById(id);
        if (order == null) {
            return Result.failure("入库单不存在");
        }
        if ("confirmed".equals(order.getStatus())) {
            return Result.failure("该入库单已登账");
        }
        if (StringUtils.isBlank(warehouseId)) {
            return Result.failure("请选择库房");
        }

        List<SpInboundOrderItem> items = inboundOrderItemService.list(new QueryWrapper<SpInboundOrderItem>()
                .eq("inbound_order_id", id)
                .eq("is_deleted", "0"));

        order.setWarehouseId(warehouseId);
        applyInventory(order, items, warehouseId, warehouseLocationId);
        order.setStatus("confirmed");
        inboundOrderService.updateById(order);
        return Result.success();
    }

    @GetMapping("/warehouse-list")
    @ResponseBody
    public Result warehouseList() {
        List<SpWarehouse> warehouses = warehouseService.list(new QueryWrapper<SpWarehouse>()
                .eq("is_deleted", "0")
                .eq("status", "0")
                .orderByDesc("create_time"));
        return Result.success(warehouses);
    }

    @GetMapping("/warehouse-location-suggest")
    @ResponseBody
    public Result warehouseLocationSuggest(String warehouseId, BigDecimal demandQty) {
        if (StringUtils.isBlank(warehouseId)) {
            return Result.failure("请选择库房");
        }
        List<SpWarehouseLocation> locations = warehouseLocationService.list(new QueryWrapper<SpWarehouseLocation>()
                .eq("warehouse_id", warehouseId)
                .eq("is_deleted", "0")
                .orderByAsc("row_no", "col_no"));

        List<Map<String, Object>> candidates = new ArrayList<>();
        BigDecimal remaining = demandQty == null ? BigDecimal.ZERO : demandQty;
        for (SpWarehouseLocation location : locations) {
            BigDecimal current = location.getCurrentInventory() == null ? BigDecimal.ZERO : location.getCurrentInventory();
            BigDecimal max = location.getMaxCapacity() == null ? BigDecimal.ZERO : location.getMaxCapacity();
            BigDecimal free = max.subtract(current);
            if (free.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            Map<String, Object> item = new HashMap<>();
            item.put("id", location.getId());
            item.put("code", location.getCode());
            item.put("name", location.getName());
            item.put("rowNo", location.getRowNo());
            item.put("colNo", location.getColNo());
            item.put("locationType", location.getLocationType());
            item.put("maxCapacity", max);
            item.put("currentInventory", current);
            item.put("freeCapacity", free);
            candidates.add(item);
            remaining = remaining.subtract(free);
        }

        candidates.sort(Comparator.comparing((Map<String, Object> m) -> new BigDecimal(m.get("freeCapacity").toString())).reversed());
        Map<String, Object> result = new HashMap<>();
        result.put("candidates", candidates);
        result.put("canFulfill", demandQty == null || remaining.compareTo(BigDecimal.ZERO) <= 0);
        return Result.success(result);
    }

    private void applyInventory(SpInboundOrder order, List<SpInboundOrderItem> items, String warehouseId, String warehouseLocationId) {
        BigDecimal inboundQty = BigDecimal.ZERO;
        for (SpInboundOrderItem item : items) {
            if (item.getDemandQty() != null) {
                inboundQty = inboundQty.add(item.getDemandQty());
            }
        }

        SpWarehouse warehouse = warehouseService.getById(warehouseId);
        if (warehouse != null) {
            BigDecimal currentWarehouseInventory = warehouse.getTotalInventory() == null ? BigDecimal.ZERO : warehouse.getTotalInventory();
            warehouse.setTotalInventory(currentWarehouseInventory.add(inboundQty));
            warehouseService.updateById(warehouse);
        }

        if (StringUtils.isBlank(warehouseLocationId)) {
            order.setWarehouseLocationId(null);
            order.setWarehouseLocationIds(null);
            return;
        }

        BigDecimal remaining = inboundQty;
        List<String> usedLocationIds = new ArrayList<>();
        for (String locationId : warehouseLocationId.split(",")) {
            if (StringUtils.isBlank(locationId) || remaining.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            SpWarehouseLocation location = warehouseLocationService.getById(locationId.trim());
            if (location == null) {
                continue;
            }
            BigDecimal currentLocationInventory = location.getCurrentInventory() == null ? BigDecimal.ZERO : location.getCurrentInventory();
            BigDecimal maxCapacity = location.getMaxCapacity() == null ? BigDecimal.ZERO : location.getMaxCapacity();
            BigDecimal freeCapacity = maxCapacity.subtract(currentLocationInventory);
            if (freeCapacity.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            BigDecimal allocated = remaining.min(freeCapacity);
            location.setCurrentInventory(currentLocationInventory.add(allocated));
            warehouseLocationService.updateById(location);
            remaining = remaining.subtract(allocated);
            usedLocationIds.add(location.getId());
        }

        if (remaining.compareTo(BigDecimal.ZERO) > 0 && !usedLocationIds.isEmpty()) {
            SpWarehouseLocation location = warehouseLocationService.getById(usedLocationIds.get(0));
            if (location != null) {
                BigDecimal currentLocationInventory = location.getCurrentInventory() == null ? BigDecimal.ZERO : location.getCurrentInventory();
                location.setCurrentInventory(currentLocationInventory.add(remaining));
                warehouseLocationService.updateById(location);
            }
        }

        if (!usedLocationIds.isEmpty()) {
            order.setWarehouseLocationIds(String.join(",", usedLocationIds));
            order.setWarehouseLocationId(usedLocationIds.get(0));
        }
    }
}
