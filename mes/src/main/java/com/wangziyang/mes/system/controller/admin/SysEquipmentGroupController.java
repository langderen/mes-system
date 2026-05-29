package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysEquipmentGroupDTO;
import com.wangziyang.mes.system.entity.*;
import com.wangziyang.mes.system.request.SysEquipmentGroupPageReq;
import com.wangziyang.mes.system.service.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
@RequestMapping("/admin/sys/equipmentgroup")
public class SysEquipmentGroupController extends BaseController {

    @Autowired
    private ISysEquipmentGroupService sysEquipmentGroupService;

    @Autowired
    private ISysEquipmentGroupEquipmentService sysEquipmentGroupEquipmentService;

    @Autowired
    private ISysEquipmentService sysEquipmentService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/equipmentgroup/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysEquipmentGroupPageReq req) {
        QueryWrapper<SysEquipmentGroup> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        qw.orderByDesc(req.getOrderBy());
        IPage<SysEquipmentGroup> result = sysEquipmentGroupService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysEquipmentGroup record) {
        Set<String> checkedEquipmentIds = new HashSet<>();
        if (StringUtils.isNotEmpty(record.getId())) {
            SysEquipmentGroup group = sysEquipmentGroupService.getById(record.getId());
            model.addAttribute("group", group);

            QueryWrapper<SysEquipmentGroupEquipment> eqw = new QueryWrapper<>();
            eqw.eq("equipment_group_id", record.getId());
            List<SysEquipmentGroupEquipment> groupEquipments = sysEquipmentGroupEquipmentService.list(eqw);
            for (SysEquipmentGroupEquipment ge : groupEquipments) {
                checkedEquipmentIds.add(ge.getEquipmentId());
            }
        }

        List<SysEquipment> allEquipments = sysEquipmentService.list(
                new QueryWrapper<SysEquipment>().eq("is_deleted", "0").orderByAsc("code"));
        List<Map<String, Object>> equipmentList = new ArrayList<>();
        for (SysEquipment eq : allEquipments) {
            Map<String, Object> eqMap = new LinkedHashMap<>();
            eqMap.put("id", eq.getId());
            eqMap.put("code", eq.getCode());
            eqMap.put("name", eq.getName());
            eqMap.put("model", eq.getModel());
            eqMap.put("type", eq.getType());
            eqMap.put("checked", checkedEquipmentIds.contains(eq.getId()));
            equipmentList.add(eqMap);
        }
        model.addAttribute("equipmentList", equipmentList);
        return "admin/system/equipmentgroup/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysEquipmentGroupDTO record) throws Exception {
        sysEquipmentGroupService.saveOrUpdate(record);
        sysEquipmentGroupService.rebuildEquipmentGroupEquipment(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysEquipmentGroup record) {
        sysEquipmentGroupService.removeById(record.getId());
        return Result.success();
    }
}