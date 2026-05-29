package com.wangziyang.mes.production.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.production.entity.*;
import com.wangziyang.mes.production.service.*;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("spDispatchController")
@RequestMapping("/production/dispatch")
public class SpDispatchController extends BaseController {

    @Autowired
    private ISpDispatchOrderService dispatchOrderService;

    @Autowired
    private ISpDispatchRecordService dispatchRecordService;

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
        return "production/dispatch/list";
    }

    @GetMapping("/dispatch-ui")
    public String dispatchUI(String orderId, Model model) {
        model.addAttribute("orderId", orderId);
        return "production/dispatch/dispatch";
    }

    @GetMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String orderNo, String productCode, String status) {
        Page<SpDispatchOrder> page = new Page<>(current, size);
        QueryWrapper<SpDispatchOrder> wrapper = new QueryWrapper<SpDispatchOrder>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(orderNo), "order_no", orderNo)
                .like(StringUtils.isNotBlank(productCode), "product_code", productCode)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .orderByDesc("create_time");
        IPage<SpDispatchOrder> result = dispatchOrderService.page(page, wrapper);
        return Result.success(result);
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        if (StringUtils.isBlank(id)) {
            return Result.failure("参数不能为空");
        }
        SpDispatchOrder order = dispatchOrderService.getOne(
                new QueryWrapper<SpDispatchOrder>()
                        .eq("id", id)
                        .eq("is_deleted", "0"));
        if (order == null) {
            return Result.failure("工单不存在");
        }
        return Result.success(order);
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
                new QueryWrapper<SysGroupUser>()
                        .eq("group_id", unit.getGroupId()));

        List<Map<String, Object>> result = new ArrayList<>();
        for (SysGroupUser gu : groupUsers) {
            SysUser user = userService.getById(gu.getUserId());
            if (user != null) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", user.getId());
                map.put("userName", user.getName());
                map.put("username", user.getUsername());
                map.put("groupId", gu.getGroupId());
                result.add(map);
            }
        }
        return Result.success(result);
    }

    @PostMapping("/person-dispatch")
    @ResponseBody
    public Result personDispatch(@RequestBody Map<String, Object> params) {
        String orderId = (String) params.get("orderId");
        String userId = (String) params.get("userId");
        String processUnitId = (String) params.get("processUnitId");
        Object qtyObj = params.get("qty");

        if (StringUtils.isBlank(orderId) || StringUtils.isBlank(userId) || StringUtils.isBlank(processUnitId)) {
            return Result.failure("参数不能为空");
        }

        SpDispatchOrder order = dispatchOrderService.getOne(
                new QueryWrapper<SpDispatchOrder>()
                        .eq("id", orderId)
                        .eq("is_deleted", "0"));
        if (order == null) {
            return Result.failure("工单不存在");
        }

        if (!"draft".equals(order.getStatus()) && !"assigned".equals(order.getStatus())) {
            return Result.failure("当前工单状态不允许派工");
        }

        SysUser user = userService.getById(userId);
        if (user == null) {
            return Result.failure("用户不存在");
        }

        SysProcessUnit processUnit = processUnitService.getById(processUnitId);
        if (processUnit == null) {
            return Result.failure("加工单元不存在");
        }

        BigDecimal qty = new BigDecimal(qtyObj != null ? qtyObj.toString() : order.getQty().toString());

        SpDispatchRecord record = new SpDispatchRecord();
        record.setDispatchOrderId(orderId);
        record.setDispatchType("person");
        record.setProcessUnitId(processUnitId);
        record.setTeamId(processUnit.getGroupId());
        record.setUserId(userId);
        record.setPlanQty(qty);
        record.setDispatchTime(LocalDateTime.now());
        record.setStatus("pending");
        dispatchRecordService.save(record);

        order.setStatus("assigned");
        dispatchOrderService.updateById(order);

        return Result.success();
    }

    @PostMapping("/start-work")
    @ResponseBody
    public Result startWork(String recordId) {
        if (StringUtils.isBlank(recordId)) {
            return Result.failure("参数不能为空");
        }

        SpDispatchRecord record = dispatchRecordService.getOne(
                new QueryWrapper<SpDispatchRecord>()
                        .eq("id", recordId)
                        .eq("is_deleted", "0"));
        if (record == null) {
            return Result.failure("派工记录不存在");
        }

        if (!"pending".equals(record.getStatus())) {
            return Result.failure("当前状态不允许开工");
        }

        record.setStatus("started");
        record.setStartTime(LocalDateTime.now());
        dispatchRecordService.updateById(record);

        SpDispatchOrder order = dispatchOrderService.getOne(
                new QueryWrapper<SpDispatchOrder>()
                        .eq("id", record.getDispatchOrderId())
                        .eq("is_deleted", "0"));
        if (order != null && "assigned".equals(order.getStatus())) {
            order.setStatus("started");
            order.setActualStartTime(LocalDateTime.now());
            dispatchOrderService.updateById(order);
        }

        return Result.success();
    }

    @PostMapping("/complete-work")
    @ResponseBody
    public Result completeWork(@RequestBody Map<String, Object> params) {
        String recordId = (String) params.get("recordId");
        Object qualifiedObj = params.get("qualifiedQty");
        Object scrapObj = params.get("scrapQty");

        if (StringUtils.isBlank(recordId)) {
            return Result.failure("参数不能为空");
        }

        SpDispatchRecord record = dispatchRecordService.getOne(
                new QueryWrapper<SpDispatchRecord>()
                        .eq("id", recordId)
                        .eq("is_deleted", "0"));
        if (record == null) {
            return Result.failure("派工记录不存在");
        }

        if (!"started".equals(record.getStatus())) {
            return Result.failure("当前状态不允许完工");
        }

        BigDecimal qualifiedQty = new BigDecimal(qualifiedObj != null ? qualifiedObj.toString() : "0");
        BigDecimal scrapQty = new BigDecimal(scrapObj != null ? scrapObj.toString() : "0");
        BigDecimal completedQty = qualifiedQty.add(scrapQty);

        record.setCompletedQty(completedQty);
        record.setQualifiedQty(qualifiedQty);
        record.setScrapQty(scrapQty);
        record.setStatus("completed");
        record.setEndTime(LocalDateTime.now());
        if (record.getStartTime() != null) {
            long hours = java.time.Duration.between(record.getStartTime(), record.getEndTime()).toMinutes();
            record.setWorkHours(new BigDecimal(hours).divide(new BigDecimal(60), 2, BigDecimal.ROUND_HALF_UP));
        }
        dispatchRecordService.updateById(record);

        SpDispatchOrder order = dispatchOrderService.getOne(
                new QueryWrapper<SpDispatchOrder>()
                        .eq("id", record.getDispatchOrderId())
                        .eq("is_deleted", "0"));
        if (order != null) {
            order.setCompletedQty(order.getCompletedQty().add(completedQty));
            order.setQualifiedQty(order.getQualifiedQty().add(qualifiedQty));
            order.setScrapQty(order.getScrapQty().add(scrapQty));

            if (order.getCompletedQty().compareTo(order.getQty()) >= 0) {
                order.setStatus("completed");
                order.setActualEndTime(LocalDateTime.now());
            } else {
                order.setStatus("inspected");
            }
            dispatchOrderService.updateById(order);
        }

        return Result.success();
    }

    @GetMapping("/records")
    @ResponseBody
    public Result records(String orderId) {
        if (StringUtils.isBlank(orderId)) {
            return Result.success(new ArrayList<>());
        }

        List<SpDispatchRecord> records = dispatchRecordService.list(
                new QueryWrapper<SpDispatchRecord>()
                        .eq("dispatch_order_id", orderId)
                        .eq("is_deleted", "0")
                        .orderByAsc("dispatch_time"));

        List<Map<String, Object>> result = new ArrayList<>();
        for (SpDispatchRecord record : records) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", record.getId());
            map.put("dispatchOrderId", record.getDispatchOrderId());
            map.put("dispatchType", record.getDispatchType());
            map.put("operatorId", record.getOperatorId());
            map.put("planQty", record.getPlanQty());
            map.put("completedQty", record.getCompletedQty());
            map.put("qualifiedQty", record.getQualifiedQty());
            map.put("scrapQty", record.getScrapQty());
            map.put("workHours", record.getWorkHours());
            map.put("dispatchTime", record.getDispatchTime());
            map.put("startTime", record.getStartTime());
            map.put("endTime", record.getEndTime());
            map.put("status", record.getStatus());

            if ("person".equals(record.getDispatchType()) && StringUtils.isNotBlank(record.getUserId())) {
                SysUser user = userService.getById(record.getUserId());
                if (user != null) {
                    map.put("operatorName", user.getName());
                    map.put("operatorNo", user.getUsername());
                }
            }

            if (StringUtils.isNotBlank(record.getProcessUnitId())) {
                SysProcessUnit unit = processUnitService.getById(record.getProcessUnitId());
                if (unit != null) {
                    map.put("processUnitName", unit.getName());
                }
            }

            result.add(map);
        }
        return Result.success(result);
    }
}
