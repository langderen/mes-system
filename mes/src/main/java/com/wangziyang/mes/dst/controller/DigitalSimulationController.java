package com.wangziyang.mes.dst.controller;



import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.warehouse.entity.SpWarehouse;
import com.wangziyang.mes.warehouse.service.ISpWarehouseService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 数字仿真控制器 基于three.js
 * </p>
 *
 * @author WangZiYang
 * @since 2020-08-18
 */
@Controller
@RequestMapping("/digital/simulation")
public class DigitalSimulationController extends BaseController {

    @Autowired
    private ISpWarehouseService warehouseService;

    /**
     * 数字仿真界面
     *
     * @return 数字仿真界面
     */
    @ApiOperation("数字仿真3D教学UI")
    @GetMapping("/list-ui")
    public String addOrUpdateUI() {
        return "digitization/3DProject";
    }

    /**
     * 获取仓库数据列表
     *
     * @return 仓库数据列表
     */
    @ApiOperation("获取仓库数据列表")
    @GetMapping("/warehouse/list")
    @ResponseBody
    public Result list() {
        List<SpWarehouse> warehouseList = warehouseService.list();
        Map<String, Object> data = new HashMap<>();
        data.put("warehouseList", warehouseList);
        return Result.success(data);
    }

}
