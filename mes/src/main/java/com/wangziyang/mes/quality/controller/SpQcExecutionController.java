package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.*;
import com.wangziyang.mes.quality.service.*;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@Controller
@RequestMapping("/quality/execution")
public class SpQcExecutionController extends BaseController {

    @Autowired
    private ISpQcInspectionRecordService qcInspectionRecordService;

    @Autowired
    private ISpQcInspectionTaskService qcInspectionTaskService;

    @Autowired
    private ISpQcInspectionPlanService qcInspectionPlanService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @Autowired
    private ISysUserService userService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/execution/list";
    }

    @GetMapping("/execute-ui")
    public String executeUI(String taskId, Model model) {
        SpQcInspectionTask task = qcInspectionTaskService.getById(taskId);
        if (task != null) {
            model.addAttribute("task", task);
            SpQcInspectionDef def = qcInspectionDefService.getById(task.getInspectionDefId());
            model.addAttribute("inspectionDef", def);
            SpQcInspectionPlan plan = qcInspectionPlanService.getById(task.getPlanId());
            model.addAttribute("plan", plan);
        }
        return "quality/execution/execute";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String recordCode, String taskId, String inspectorId, String result, String inspectionTime) {
        QueryWrapper<SpQcInspectionRecord> wrapper = new QueryWrapper<SpQcInspectionRecord>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(recordCode), "record_code", recordCode)
                .eq(StringUtils.isNotBlank(taskId), "task_id", taskId)
                .eq(StringUtils.isNotBlank(inspectorId), "inspector_id", inspectorId)
                .eq(StringUtils.isNotBlank(result), "result", result)
                .orderByDesc("create_time");
        if (StringUtils.isNotBlank(inspectionTime)) {
            wrapper.ge("inspection_time", inspectionTime + " 00:00:00")
                   .le("inspection_time", inspectionTime + " 23:59:59");
        }
        IPage<SpQcInspectionRecord> pageResult = qcInspectionRecordService.page(new Page<>(current, size), wrapper);
        List<Map<String, Object>> records = new ArrayList<>();
        for (SpQcInspectionRecord r : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("recordCode", r.getRecordCode());
            map.put("taskId", r.getTaskId());
            map.put("inspectionDefId", r.getInspectionDefId());
            map.put("inspectorId", r.getInspectorId());
            map.put("inspectionTime", r.getInspectionTime());
            map.put("result", r.getResult());
            map.put("defectType", r.getDefectType());
            map.put("defectDesc", r.getDefectDesc());
            map.put("defectQty", r.getDefectQty());
            map.put("defectSeverity", r.getDefectSeverity());
            map.put("measuredValue", r.getMeasuredValue());
            map.put("standardValue", r.getStandardValue());
            map.put("handleMethod", r.getHandleMethod());
            map.put("handleRemark", r.getHandleRemark());
            map.put("attachment", r.getAttachment());
            map.put("remark", r.getRemark());
            map.put("createTime", r.getCreateTime());
            map.put("createUsername", r.getCreateUsername());
            if (StringUtils.isNotBlank(r.getInspectorId())) {
                SysUser user = userService.getById(r.getInspectorId());
                if (user != null) {
                    map.put("inspectorName", user.getName());
                }
            }
            if (StringUtils.isNotBlank(r.getInspectionDefId())) {
                SpQcInspectionDef def = qcInspectionDefService.getById(r.getInspectionDefId());
                if (def != null) {
                    map.put("defName", def.getDefName());
                }
            }
            records.add(map);
        }
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("records", records);
        resultMap.put("total", pageResult.getTotal());
        resultMap.put("size", pageResult.getSize());
        resultMap.put("current", pageResult.getCurrent());
        resultMap.put("pages", pageResult.getPages());
        return Result.success(resultMap);
    }

    @PostMapping("/execute")
    @ResponseBody
    public Result execute(@RequestBody Map<String, Object> params) {
        String taskId = (String) params.get("taskId");
        String result = (String) params.get("result");
        String defectType = (String) params.get("defectType");
        String defectDesc = (String) params.get("defectDesc");
        String defectSeverity = (String) params.get("defectSeverity");
        String measuredValue = (String) params.get("measuredValue");
        Object defectQtyObj = params.get("defectQty");
        String handleMethod = (String) params.get("handleMethod");

        if (StringUtils.isBlank(taskId) || StringUtils.isBlank(result)) {
            return Result.failure("参数不能为空");
        }

        SpQcInspectionTask task = qcInspectionTaskService.getById(taskId);
        if (task == null) {
            return Result.failure("质检任务不存在");
        }
        if (!"assigned".equals(task.getStatus()) && !"started".equals(task.getStatus())) {
            return Result.failure("任务状态不允许执行检验");
        }

        BigDecimal defectQty = defectQtyObj != null ? new BigDecimal(defectQtyObj.toString()) : BigDecimal.ZERO;

        SpQcInspectionRecord record = new SpQcInspectionRecord();
        record.setRecordCode("QC-REC-" + System.currentTimeMillis());
        record.setTaskId(taskId);
        record.setInspectionDefId(task.getInspectionDefId());
        record.setInspectorId(task.getInspectorId());
        record.setInspectionTime(LocalDateTime.now());
        record.setResult(result);
        record.setDefectType(defectType);
        record.setDefectDesc(defectDesc);
        record.setDefectSeverity(defectSeverity);
        record.setMeasuredValue(measuredValue);
        record.setDefectQty(defectQty);
        record.setHandleMethod(handleMethod);
        qcInspectionRecordService.save(record);

        task.setCompletedQty(task.getCompletedQty().add(task.getAssignedQty()));
        if ("pass".equals(result)) {
            task.setPassQty(task.getPassQty().add(task.getAssignedQty()));
        } else {
            task.setFailQty(task.getFailQty().add(task.getAssignedQty()));
        }
        task.setEndTime(LocalDateTime.now());
        task.setStatus("completed");
        qcInspectionTaskService.updateById(task);

        SpQcInspectionPlan plan = qcInspectionPlanService.getById(task.getPlanId());
        if (plan != null) {
            plan.setCompletedQty(plan.getCompletedQty().add(task.getAssignedQty()));
            if ("pass".equals(result)) {
                plan.setPassQty(plan.getPassQty().add(task.getAssignedQty()));
            } else {
                plan.setFailQty(plan.getFailQty().add(task.getAssignedQty()));
            }
            if (plan.getCompletedQty().compareTo(plan.getPlanQty()) >= 0) {
                plan.setStatus("completed");
                plan.setActualEndTime(LocalDateTime.now());
            }
            qcInspectionPlanService.updateById(plan);
        }

        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcInspectionRecord record = qcInspectionRecordService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcInspectionRecordService.updateById(record);
        }
        return Result.success();
    }
}