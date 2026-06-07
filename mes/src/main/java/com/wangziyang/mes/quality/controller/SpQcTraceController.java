package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.SpQcActivity;
import com.wangziyang.mes.quality.entity.SpQcInspectionData;
import com.wangziyang.mes.quality.entity.SpQcInspectionDef;
import com.wangziyang.mes.quality.entity.SpQcInspectionPlan;
import com.wangziyang.mes.quality.entity.SpQcInspectionRecord;
import com.wangziyang.mes.quality.entity.SpQcInspectionTask;
import com.wangziyang.mes.quality.service.ISpQcActivityService;
import com.wangziyang.mes.quality.service.ISpQcInspectionDataService;
import com.wangziyang.mes.quality.service.ISpQcInspectionDefService;
import com.wangziyang.mes.quality.service.ISpQcInspectionPlanService;
import com.wangziyang.mes.quality.service.ISpQcInspectionRecordService;
import com.wangziyang.mes.quality.service.ISpQcInspectionTaskService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/quality/trace")
public class SpQcTraceController extends BaseController {

    @Autowired
    private ISpQcInspectionRecordService qcInspectionRecordService;

    @Autowired
    private ISpQcInspectionTaskService qcInspectionTaskService;

    @Autowired
    private ISpQcInspectionPlanService qcInspectionPlanService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @Autowired
    private ISpQcInspectionDataService qcInspectionDataService;

    @Autowired
    private ISpQcActivityService qcActivityService;

    @Autowired
    private ISysUserService userService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/trace/list";
    }

    @GetMapping("/trace")
    @ResponseBody
    public Result trace(String recordId, String taskId, String productCode, String planId) {
        if (StringUtils.isBlank(recordId) && StringUtils.isBlank(taskId)
                && StringUtils.isBlank(productCode) && StringUtils.isBlank(planId)) {
            return Result.failure("at least one query condition is required");
        }

        List<Map<String, Object>> traceList = new ArrayList<>();

        if (StringUtils.isNotBlank(recordId)) {
            SpQcInspectionRecord record = qcInspectionRecordService.getById(recordId);
            if (record != null) {
                traceList.add(buildRecordNode(record));
            }
        } else {
            QueryWrapper<SpQcInspectionRecord> wrapper = new QueryWrapper<SpQcInspectionRecord>()
                    .eq("is_deleted", "0");
            if (StringUtils.isNotBlank(taskId)) {
                wrapper.eq("task_id", taskId);
            }
            wrapper.orderByDesc("inspection_time");
            List<SpQcInspectionRecord> records = qcInspectionRecordService.list(wrapper);
            for (SpQcInspectionRecord record : records) {
                traceList.add(buildRecordNode(record));
            }
        }

        return Result.success(traceList);
    }

    private Map<String, Object> buildRecordNode(SpQcInspectionRecord record) {
        Map<String, Object> node = new HashMap<>();
        node.put("recordCode", record.getRecordCode());
        node.put("inspectionTime", record.getInspectionTime());
        node.put("result", record.getResult());
        node.put("defectType", record.getDefectType());
        node.put("defectDesc", record.getDefectDesc());
        node.put("defectSeverity", record.getDefectSeverity());
        node.put("measuredValue", record.getMeasuredValue());
        node.put("standardValue", record.getStandardValue());
        node.put("handleMethod", record.getHandleMethod());
        node.put("handleRemark", record.getHandleRemark());

        if (StringUtils.isNotBlank(record.getInspectorId())) {
            SysUser user = userService.getById(record.getInspectorId());
            if (user != null) {
                node.put("inspectorName", user.getName());
            }
        }

        if (StringUtils.isNotBlank(record.getInspectionDefId())) {
            SpQcInspectionDef def = qcInspectionDefService.getById(record.getInspectionDefId());
            if (def != null) {
                node.put("defName", def.getDefName());
                node.put("inspectionType", def.getInspectionType());
                node.put("inspectionItem", def.getInspectionItem());
                node.put("productCode", def.getProductCode());
                node.put("productName", def.getProductName());
            }
        }

        if (StringUtils.isNotBlank(record.getTaskId())) {
            SpQcInspectionTask task = qcInspectionTaskService.getById(record.getTaskId());
            if (task != null) {
                node.put("taskCode", task.getTaskCode());
                node.put("assignedQty", task.getAssignedQty());
                node.put("assignTime", task.getAssignTime());

                if (StringUtils.isNotBlank(task.getPlanId())) {
                    SpQcInspectionPlan plan = qcInspectionPlanService.getById(task.getPlanId());
                    if (plan != null) {
                        node.put("planCode", plan.getPlanCode());
                        node.put("planName", plan.getPlanName());
                        node.put("orderId", plan.getOrderId());

                        if (StringUtils.isNotBlank(plan.getActivityId())) {
                            SpQcActivity activity = qcActivityService.getById(plan.getActivityId());
                            if (activity != null) {
                                node.put("activityName", activity.getActivityName());
                                node.put("activityType", activity.getActivityType());
                            }
                        }
                    }
                }
            }
        }

        List<SpQcInspectionData> dataList = qcInspectionDataService.list(
                new QueryWrapper<SpQcInspectionData>()
                        .eq("record_id", record.getId())
                        .eq("is_deleted", "0"));
        List<Map<String, Object>> dataNodes = new ArrayList<>();
        for (SpQcInspectionData data : dataList) {
            Map<String, Object> dataNode = new HashMap<>();
            dataNode.put("parameterName", data.getParameterName());
            dataNode.put("measuredValue", data.getMeasuredValue());
            dataNode.put("standardValue", data.getStandardValue());
            dataNode.put("minValue", data.getMinValue());
            dataNode.put("maxValue", data.getMaxValue());
            dataNode.put("unit", data.getUnit());
            dataNode.put("isPass", data.getIsPass());
            dataNodes.add(dataNode);
        }
        node.put("dataItems", dataNodes);

        return node;
    }
}
