package com.wangziyang.mes.warehouse.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.warehouse.entity.SpWarehouse;
import com.wangziyang.mes.warehouse.entity.SpWarehouseLocation;
import com.wangziyang.mes.warehouse.request.SpWarehousePageReq;
import com.wangziyang.mes.warehouse.service.ISpWarehouseLocationService;
import com.wangziyang.mes.warehouse.service.ISpWarehouseService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/warehouse/warehouse")
public class WarehouseController extends BaseController {

    Logger logger = LoggerFactory.getLogger(WarehouseController.class);

    @Autowired
    private ISpWarehouseService warehouseService;

    @Autowired
    private ISpWarehouseLocationService locationService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "warehouse/warehouse/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotBlank(id)) {
            SpWarehouse warehouse = warehouseService.getById(id);
            model.addAttribute("warehouse", warehouse);

            List<SpWarehouseLocation> locations = locationService.list(
                    new QueryWrapper<SpWarehouseLocation>()
                            .eq("warehouse_id", id)
                            .eq("is_deleted", "0")
                            .orderByAsc("row_no", "col_no"));
            model.addAttribute("locations", locations);
        }
        return "warehouse/warehouse/addOrUpdate";
    }

    @GetMapping("/board-ui")
    public String boardUI(Model model) {
        List<SpWarehouse> warehouses = warehouseService.list(
                new QueryWrapper<SpWarehouse>()
                        .eq("is_deleted", "0")
                        .eq("status", "0"));
        model.addAttribute("warehouses", warehouses);
        return "warehouse/warehouse/board";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpWarehousePageReq req) {
        QueryWrapper<SpWarehouse> wrapper = new QueryWrapper<SpWarehouse>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(req.getNameLike())) {
            wrapper.like("name", req.getNameLike());
        }
        if (StringUtils.isNotBlank(req.getCodeLike())) {
            wrapper.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotBlank(req.getTypeLike())) {
            wrapper.like("type", req.getTypeLike());
        }
        wrapper.orderByDesc("create_time");

        IPage<SpWarehouse> page = warehouseService.page(req, wrapper);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWarehouse warehouse) {
        warehouseService.saveOrUpdate(warehouse);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpWarehouse warehouse = warehouseService.getById(id);
        if (warehouse != null) {
            warehouse.setDeleted("1");
            warehouseService.updateById(warehouse);
        }
        return Result.success();
    }

    @PostMapping("/location/page")
    @ResponseBody
    public Result locationPage(SpWarehousePageReq req) {
        IPage<SpWarehouseLocation> page = locationService.pageByWarehouseId(req, req.getWarehouseId());
        return Result.success(page);
    }

    @PostMapping("/location/add-or-update")
    @ResponseBody
    public Result locationAddOrUpdate(SpWarehouseLocation location) {
        locationService.saveOrUpdate(location);
        return Result.success();
    }

    @PostMapping("/location/delete")
    @ResponseBody
    public Result locationDelete(String id) {
        SpWarehouseLocation location = locationService.getById(id);
        if (location != null) {
            location.setDeleted("1");
            locationService.updateById(location);
        }
        return Result.success();
    }

    @GetMapping("/board-data")
    @ResponseBody
    public Result boardData(String warehouseId) {
        List<SpWarehouseLocation> locations = locationService.list(
                new QueryWrapper<SpWarehouseLocation>()
                        .eq("warehouse_id", warehouseId)
                        .eq("is_deleted", "0")
                        .orderByAsc("row_no", "col_no"));

        int maxRow = 0;
        int maxCol = 0;
        for (SpWarehouseLocation loc : locations) {
            if (loc.getRowNo() != null && loc.getRowNo() > maxRow) {
                maxRow = loc.getRowNo();
            }
            if (loc.getColNo() != null && loc.getColNo() > maxCol) {
                maxCol = loc.getColNo();
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("locations", locations);
        result.put("maxRow", maxRow + 1);
        result.put("maxCol", maxCol + 1);
        return Result.success(result);
    }
}