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
import java.util.*;

@Controller
@RequestMapping("/quality/data")
public class SpQcDataController extends BaseController {

    @Autowired
    private ISpQcInspectionDataService qcInspectionDataService;

    @Autowired
    private ISpQcInspectionRecordService qcInspectionRecordService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @GetMapping("/list-ui")
    public String listUI(Model model, String recordId) {
        model.addAttribute("recordId", recordId);
        return "quality/data/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String recordId, String taskId, String parameterCode, String parameterName) {
        QueryWrapper<SpQcInspectionData> wrapper = new QueryWrapper<SpQcInspectionData>()
                .eq("is_deleted", "0")
                .eq(StringUtils.isNotBlank(recordId), "record_id", recordId)
                .eq(StringUtils.isNotBlank(taskId), "task_id", taskId)
                .like(StringUtils.isNotBlank(parameterCode), "parameter_code", parameterCode)
                .like(StringUtils.isNotBlank(parameterName), "parameter_name", parameterName)
                .orderByDesc("collect_time");
        IPage<SpQcInspectionData> result = qcInspectionDataService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @PostMapping("/collect")
    @ResponseBody
    public Result collect(@RequestBody Map<String, Object> params) {
        String recordId = (String) params.get("recordId");
        String taskId = (String) params.get("taskId");
        List<Map<String, Object>> dataList = (List<Map<String, Object>>) params.get("dataList");

        if (StringUtils.isBlank(recordId) || dataList == null || dataList.isEmpty()) {
            return Result.failure("参数不能为空");
        }

        SpQcInspectionRecord record = qcInspectionRecordService.getById(recordId);
        if (record == null) {
            return Result.failure("检验记录不存在");
        }

        for (Map<String, Object> item : dataList) {
            SpQcInspectionData data = new SpQcInspectionData();
            data.setRecordId(recordId);
            data.setTaskId(taskId);
            data.setParameterCode((String) item.get("parameterCode"));
            data.setParameterName((String) item.get("parameterName"));
            data.setMeasuredValue((String) item.get("measuredValue"));
            data.setStandardValue((String) item.get("standardValue"));
            data.setMinValue((String) item.get("minValue"));
            data.setMaxValue((String) item.get("maxValue"));
            data.setUnit((String) item.get("unit"));
            data.setIsPass((String) item.get("isPass"));
            data.setCollectTime(LocalDateTime.now());
            data.setCollectMethod((String) item.getOrDefault("collectMethod", "manual"));
            qcInspectionDataService.save(data);
        }

        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcInspectionData record = qcInspectionDataService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcInspectionDataService.updateById(record);
        }
        return Result.success();
    }
}