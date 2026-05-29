package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysEquipment;
import com.wangziyang.mes.system.request.SysEquipmentPageReq;
import com.wangziyang.mes.system.service.ISysEquipmentService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin/sys/equipment")
public class SysEquipmentController extends BaseController {

    @Autowired
    private ISysEquipmentService sysEquipmentService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/equipment/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysEquipmentPageReq req) {
        QueryWrapper<SysEquipment> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.likeRight("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getTypeLike())) {
            qw.likeRight("type", req.getTypeLike());
        }
        qw.orderByDesc(req.getOrderBy());
        IPage<SysEquipment> result = sysEquipmentService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysEquipment record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysEquipment sysEquipment = sysEquipmentService.getById(record.getId());
            model.addAttribute("equipment", sysEquipment);
        }
        return "admin/system/equipment/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysEquipment record) {
        sysEquipmentService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysEquipment record) {
        sysEquipmentService.removeById(record.getId());
        return Result.success();
    }
}