package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.*;
import com.wangziyang.mes.quality.service.*;
import com.wangziyang.mes.system.entity.SysGroup;
import com.wangziyang.mes.system.entity.SysGroupUser;
import com.wangziyang.mes.system.entity.SysProcessUnit;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysGroupService;
import com.wangziyang.mes.system.service.ISysGroupUserService;
import com.wangziyang.mes.system.service.ISysProcessUnitService;
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
@RequestMapping("/quality/task")
public class SpQcTaskController extends BaseController {

    @Autowired
    private ISpQcInspectionTaskService qcInspectionTaskService;

    @Autowired
    private ISpQcInspectionPlanService qcInspectionPlanService;

    @Autowired
    private ISpQcInspectionDefService qcInspectionDefService;

    @Autowired
    private ISysProcessUnitService processUnitService;

    @Autowired
    private ISysGroupService groupService;

    @Autowired
    private ISysGroupUserService groupUserService;

    @Autowired
    private ISysUserService userService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/task/list";
    }

    @GetMapping("/assign-ui")
    public String assignUI(String planId, Model model) {
        model.addAttribute("planId", planId);
        return "quality/task/assign";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String taskCode, String planId, String inspectorId, String status) {
        QueryWrapper<SpQcInspectionTask> wrapper = new QueryWrapper<SpQcInspectionTask>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(taskCode), "task_code", taskCode)
                .eq(StringUtils.isNotBlank(planId), "plan_id", planId)
                .eq(StringUtils.isNotBlank(inspectorId), "inspector_id", inspectorId)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .orderByDesc("create_time");
        IPage<SpQcInspectionTask> result = qcInspectionTaskService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @GetMapping("/process-units")
    @ResponseBody
    public Result processUnits() {
        List<SysProcessUnit> units = processUnitService.list(
                new QueryWrapper<SysProcessUnit>()
                        .eq("is_deleted", "0")
                        .eq("status", "0")
                        .orderByAsc("code"));
        List<Map<String, Object>> result = new ArrayList<>();
        for (SysProcessUnit unit : units) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", unit.getId());
            map.put("code", unit.getCode());
            map.put("name", unit.getName());
            map.put("groupId", unit.getGroupId());
            if (StringUtils.isNotBlank(unit.getGroupId())) {
                SysGroup group = groupService.getById(unit.getGroupId());
                if (group != null) {
                    map.put("groupName", group.getName());
                }
            }
            result.add(map);
        }
        return Result.success(result);
    }

    @GetMapping("/group-users")
    @ResponseBody
    public Result groupUsers(String processUnitId) {
        if (StringUtils.isBlank(processUnitId)) {
            return Result.success(new ArrayList<>());
        }
        SysProcessUnit unit = processUnitService.getById(processUnitId);
        if (unit == null || StringUtils.isBlank(unit.getGroupId())) {
            return Result.success(new ArrayList<>());
        }
        List<SysGroupUser> groupUsers = groupUserService.list(
                new QueryWrapper<SysGroupUser>().eq("group_id", unit.getGroupId()));
        List<Map<String, Object>> result = new ArrayList<>();
        for (SysGroupUser gu : groupUsers) {
            SysUser user = userService.getById(gu.getUserId());
            if (user != null) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", user.getId());
                map.put("userName", user.getName());
                map.put("username", user.getUsername());
                result.add(map);
            }
        }
        return Result.success(result);
    }

    @PostMapping("/assign")
    @ResponseBody
    public Result assign(@RequestBody Map<String, Object> params) {
        String planId = (String) params.get("planId");
        String userId = (String) params.get("userId");
        String processUnitId = (String) params.get("processUnitId");
        Object qtyObj = params.get("assignedQty");

        if (StringUtils.isBlank(planId) || StringUtils.isBlank(userId) || StringUtils.isBlank(processUnitId)) {
            return Result.failure("参数不能为空");
        }

        SpQcInspectionPlan plan = qcInspectionPlanService.getById(planId);
        if (plan == null) {
            return Result.failure("调度计划不存在");
        }

        SpQcInspectionTask task = new SpQcInspectionTask();
        task.setTaskCode("QC-TASK-" + System.currentTimeMillis());
        task.setPlanId(planId);
        task.setInspectionDefId(plan.getInspectionDefId());
        task.setInspectorId(userId);
        task.setProcessUnitId(processUnitId);
        task.setAssignedQty(new BigDecimal(qtyObj != null ? qtyObj.toString() : "0"));
        task.setAssignTime(LocalDateTime.now());
        task.setStatus("assigned");
        qcInspectionTaskService.save(task);

        if ("pending".equals(plan.getStatus())) {
            plan.setStatus("executing");
            plan.setActualStartTime(LocalDateTime.now());
            qcInspectionPlanService.updateById(plan);
        }

        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcInspectionTask record = qcInspectionTaskService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcInspectionTaskService.updateById(record);
        }
        return Result.success();
    }
}