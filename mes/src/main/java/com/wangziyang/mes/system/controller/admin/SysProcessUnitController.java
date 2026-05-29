package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysEquipmentGroup;
import com.wangziyang.mes.system.entity.SysGroup;
import com.wangziyang.mes.system.entity.SysProcessUnit;
import com.wangziyang.mes.system.request.SysProcessUnitPageReq;
import com.wangziyang.mes.system.service.ISysEquipmentGroupService;
import com.wangziyang.mes.system.service.ISysGroupService;
import com.wangziyang.mes.system.service.ISysProcessUnitService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/admin/sys/processunit")
public class SysProcessUnitController extends BaseController {

    @Autowired
    private ISysProcessUnitService sysProcessUnitService;

    @Autowired
    private ISysGroupService sysGroupService;

    @Autowired
    private ISysEquipmentGroupService sysEquipmentGroupService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/processunit/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysProcessUnitPageReq req) {
        QueryWrapper<SysProcessUnit> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.likeRight("code", req.getCodeLike());
        }
        qw.orderByDesc(req.getOrderBy());
        IPage<SysProcessUnit> result = sysProcessUnitService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysProcessUnit record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysProcessUnit processUnit = sysProcessUnitService.getById(record.getId());
            model.addAttribute("processUnit", processUnit);
        }
        List<SysGroup> groups = sysGroupService.list(
                new QueryWrapper<SysGroup>().eq("is_deleted", "0").orderByAsc("code"));
        model.addAttribute("groups", groups);
        List<SysEquipmentGroup> equipmentGroups = sysEquipmentGroupService.list(
                new QueryWrapper<SysEquipmentGroup>().eq("is_deleted", "0").orderByAsc("code"));
        model.addAttribute("equipmentGroups", equipmentGroups);
        return "admin/system/processunit/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysProcessUnit record) {
        sysProcessUnitService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysProcessUnit record) {
        sysProcessUnitService.removeById(record.getId());
        return Result.success();
    }
}