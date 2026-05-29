package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.*;
import com.wangziyang.mes.quality.service.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/quality/plan")
public class SpQcPlanController extends BaseController {

    @Autowired
    private ISpQcInspectionPlanService qcInspectionPlanService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @Autowired
    private ISpQcActivityService qcActivityService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/plan/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotEmpty(id)) {
            SpQcInspectionPlan plan = qcInspectionPlanService.getById(id);
            model.addAttribute("result", plan);
        }
        return "quality/plan/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String planCode, String planName, String status, String productCode) {
        QueryWrapper<SpQcInspectionPlan> wrapper = new QueryWrapper<SpQcInspectionPlan>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(planCode), "plan_code", planCode)
                .like(StringUtils.isNotBlank(planName), "plan_name", planName)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .eq(StringUtils.isNotBlank(productCode), "product_code", productCode)
                .orderByDesc("create_time");
        IPage<SpQcInspectionPlan> result = qcInspectionPlanService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @PostMapping("/save")
    @ResponseBody
    public Result save(@RequestBody SpQcInspectionPlan record) {
        if (StringUtils.isBlank(record.getPlanCode())) {
            return Result.failure("计划编码不能为空");
        }
        if (StringUtils.isBlank(record.getInspectionDefId())) {
            return Result.failure("请选择质检定义");
        }
        QueryWrapper<SpQcInspectionPlan> wrapper = new QueryWrapper<SpQcInspectionPlan>()
                .eq("plan_code", record.getPlanCode())
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(record.getId())) {
            wrapper.ne("id", record.getId());
        }
        if (qcInspectionPlanService.count(wrapper) > 0) {
            return Result.failure("计划编码已存在");
        }
        qcInspectionPlanService.saveOrUpdate(record);
        return Result.success();
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        SpQcInspectionPlan plan = qcInspectionPlanService.getById(id);
        return plan != null ? Result.success(plan) : Result.failure("数据不存在");
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcInspectionPlan record = qcInspectionPlanService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcInspectionPlanService.updateById(record);
        }
        return Result.success();
    }

    @PostMapping("/execute")
    @ResponseBody
    public Result execute(String id) {
        SpQcInspectionPlan plan = qcInspectionPlanService.getById(id);
        if (plan == null) {
            return Result.failure("调度计划不存在");
        }
        if (!"pending".equals(plan.getStatus())) {
            return Result.failure("当前状态不允许执行");
        }
        plan.setStatus("executing");
        plan.setActualStartTime(LocalDateTime.now());
        qcInspectionPlanService.updateById(plan);
        return Result.success();
    }

    @GetMapping("/def-list")
    @ResponseBody
    public Result defList() {
        QueryWrapper<SpQcInspectionDef> wrapper = new QueryWrapper<SpQcInspectionDef>()
                .eq("is_deleted", "0")
                .eq("status", "active")
                .orderByAsc("sort_no");
        return Result.success(qcInspectionDefService.list(wrapper));
    }

    @GetMapping("/activity-list")
    @ResponseBody
    public Result activityList() {
        QueryWrapper<SpQcActivity> wrapper = new QueryWrapper<SpQcActivity>()
                .eq("is_deleted", "0")
                .eq("status", "active")
                .orderByDesc("create_time");
        return Result.success(qcActivityService.list(wrapper));
    }
}