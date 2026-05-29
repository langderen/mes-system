package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.SpQcInspectionDef;
import com.wangziyang.mes.quality.service.ISpQcInspectionDefService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/quality/def")
public class SpQcDefController extends BaseController {

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/def/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotEmpty(id)) {
            SpQcInspectionDef def = qcInspectionDefService.getById(id);
            model.addAttribute("result", def);
        }
        return "quality/def/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String defCode, String defName, String inspectionType, String productCode, String status) {
        QueryWrapper<SpQcInspectionDef> wrapper = new QueryWrapper<SpQcInspectionDef>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(defCode), "def_code", defCode)
                .like(StringUtils.isNotBlank(defName), "def_name", defName)
                .eq(StringUtils.isNotBlank(inspectionType), "inspection_type", inspectionType)
                .eq(StringUtils.isNotBlank(productCode), "product_code", productCode)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .orderByAsc("sort_no")
                .orderByDesc("create_time");
        IPage<SpQcInspectionDef> result = qcInspectionDefService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @PostMapping("/save")
    @ResponseBody
    public Result save(@RequestBody SpQcInspectionDef record) {
        if (StringUtils.isBlank(record.getDefCode())) {
            return Result.failure("定义编码不能为空");
        }
        if (StringUtils.isBlank(record.getDefName())) {
            return Result.failure("定义名称不能为空");
        }
        QueryWrapper<SpQcInspectionDef> wrapper = new QueryWrapper<SpQcInspectionDef>()
                .eq("def_code", record.getDefCode())
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(record.getId())) {
            wrapper.ne("id", record.getId());
        }
        if (qcInspectionDefService.count(wrapper) > 0) {
            return Result.failure("定义编码已存在");
        }
        qcInspectionDefService.saveOrUpdate(record);
        return Result.success();
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        SpQcInspectionDef def = qcInspectionDefService.getById(id);
        return def != null ? Result.success(def) : Result.failure("数据不存在");
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcInspectionDef record = qcInspectionDefService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcInspectionDefService.updateById(record);
        }
        return Result.success();
    }
}