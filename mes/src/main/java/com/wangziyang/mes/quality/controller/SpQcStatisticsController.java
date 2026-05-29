package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.*;
import com.wangziyang.mes.quality.service.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/quality/statistics")
public class SpQcStatisticsController extends BaseController {

    @Autowired
    private ISpQcInspectionRecordService qcInspectionRecordService;

    @Autowired
    private ISpQcInspectionPlanService qcInspectionPlanService;

    @Autowired
    private ISpQcInspectionTaskService qcInspectionTaskService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/statistics/list";
    }

    @GetMapping("/summary")
    @ResponseBody
    public Result summary(String startDate, String endDate, String inspectionType, String productCode) {
        Map<String, Object> result = new HashMap<>();

        QueryWrapper<SpQcInspectionPlan> planWrapper = new QueryWrapper<SpQcInspectionPlan>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(startDate)) {
            planWrapper.ge("create_time", startDate + " 00:00:00");
        }
        if (StringUtils.isNotBlank(endDate)) {
            planWrapper.le("create_time", endDate + " 23:59:59");
        }
        List<SpQcInspectionPlan> plans = qcInspectionPlanService.list(planWrapper);

        int totalPlans = plans.size();
        int completedPlans = 0;
        int executingPlans = 0;
        int pendingPlans = 0;
        for (SpQcInspectionPlan p : plans) {
            switch (p.getStatus()) {
                case "completed": completedPlans++; break;
                case "executing": executingPlans++; break;
                case "pending": pendingPlans++; break;
            }
        }

        result.put("totalPlans", totalPlans);
        result.put("completedPlans", completedPlans);
        result.put("executingPlans", executingPlans);
        result.put("pendingPlans", pendingPlans);

        QueryWrapper<SpQcInspectionRecord> recordWrapper = new QueryWrapper<SpQcInspectionRecord>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(startDate)) {
            recordWrapper.ge("inspection_time", startDate + " 00:00:00");
        }
        if (StringUtils.isNotBlank(endDate)) {
            recordWrapper.le("inspection_time", endDate + " 23:59:59");
        }
        if (StringUtils.isNotBlank(inspectionType)) {
            recordWrapper.eq("result", inspectionType);
        }
        List<SpQcInspectionRecord> records = qcInspectionRecordService.list(recordWrapper);

        int totalRecords = records.size();
        int passCount = 0;
        int failCount = 0;
        for (SpQcInspectionRecord r : records) {
            if ("pass".equals(r.getResult())) {
                passCount++;
            } else {
                failCount++;
            }
        }

        result.put("totalRecords", totalRecords);
        result.put("passCount", passCount);
        result.put("failCount", failCount);
        result.put("passRate", totalRecords > 0 ? Math.round(passCount * 10000.0 / totalRecords) / 100.0 : 0);

        return Result.success(result);
    }

    @GetMapping("/defect-analysis")
    @ResponseBody
    public Result defectAnalysis(String startDate, String endDate) {
        QueryWrapper<SpQcInspectionRecord> wrapper = new QueryWrapper<SpQcInspectionRecord>()
                .eq("is_deleted", "0")
                .ne("defect_type", "")
                .isNotNull("defect_type");
        if (StringUtils.isNotBlank(startDate)) {
            wrapper.ge("inspection_time", startDate + " 00:00:00");
        }
        if (StringUtils.isNotBlank(endDate)) {
            wrapper.le("inspection_time", endDate + " 23:59:59");
        }
        List<SpQcInspectionRecord> records = qcInspectionRecordService.list(wrapper);

        Map<String, Integer> defectTypeMap = new LinkedHashMap<>();
        Map<String, Integer> defectSeverityMap = new LinkedHashMap<>();
        for (SpQcInspectionRecord r : records) {
            defectTypeMap.merge(r.getDefectType(), 1, Integer::sum);
            if (StringUtils.isNotBlank(r.getDefectSeverity())) {
                defectSeverityMap.merge(r.getDefectSeverity(), 1, Integer::sum);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("defectByType", defectTypeMap);
        result.put("defectBySeverity", defectSeverityMap);
        return Result.success(result);
    }

    @GetMapping("/pass-rate-trend")
    @ResponseBody
    public Result passRateTrend(String startDate, String endDate) {
        QueryWrapper<SpQcInspectionRecord> wrapper = new QueryWrapper<SpQcInspectionRecord>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(startDate)) {
            wrapper.ge("inspection_time", startDate + " 00:00:00");
        }
        if (StringUtils.isNotBlank(endDate)) {
            wrapper.le("inspection_time", endDate + " 23:59:59");
        }
        wrapper.orderByAsc("inspection_time");
        List<SpQcInspectionRecord> records = qcInspectionRecordService.list(wrapper);

        Map<String, Map<String, Object>> dailyStats = new LinkedHashMap<>();
        for (SpQcInspectionRecord r : records) {
            if (r.getInspectionTime() == null) continue;
            String day = r.getInspectionTime().toLocalDate().toString();
            dailyStats.computeIfAbsent(day, k -> {
                Map<String, Object> m = new HashMap<>();
                m.put("total", 0);
                m.put("pass", 0);
                return m;
            });
            Map<String, Object> stats = dailyStats.get(day);
            stats.put("total", (Integer) stats.get("total") + 1);
            if ("pass".equals(r.getResult())) {
                stats.put("pass", (Integer) stats.get("pass") + 1);
            }
        }

        List<Map<String, Object>> trend = new ArrayList<>();
        for (Map.Entry<String, Map<String, Object>> entry : dailyStats.entrySet()) {
            Map<String, Object> stats = entry.getValue();
            int total = (Integer) stats.get("total");
            int pass = (Integer) stats.get("pass");
            Map<String, Object> point = new HashMap<>();
            point.put("date", entry.getKey());
            point.put("total", total);
            point.put("pass", pass);
            point.put("rate", total > 0 ? Math.round(pass * 10000.0 / total) / 100.0 : 0);
            trend.add(point);
        }

        return Result.success(trend);
    }
}