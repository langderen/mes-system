package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpFlowForm;
import com.wangziyang.mes.technology.service.ISpFlowFormService;
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
@RequestMapping("/basedata/flow/form")
public class SpFlowFormController extends BaseController {

    @Autowired
    private ISpFlowFormService iSpFlowFormService;

    @GetMapping("/list-ui")
    public String listUI(Model model, String flowId) {
        model.addAttribute("flowId", flowId);
        return "technology/flow/formList";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpFlowForm record) {
        if (record == null) {
            record = new SpFlowForm();
        }
        if (StringUtils.isNotBlank(record.getId())) {
            model.addAttribute("result", iSpFlowFormService.getById(record.getId()));
        } else {
            model.addAttribute("result", record);
        }
        return "technology/flow/formConfig";
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list(String flowId) {
        QueryWrapper<SpFlowForm> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotBlank(flowId)) {
            qw.eq("flow_id", flowId);
        }
        qw.orderByDesc("update_time");
        List<SpFlowForm> list = iSpFlowFormService.list(qw);
        return Result.success(list);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpFlowForm record) {
        if (record.getSkipFirst() == null) {
            record.setSkipFirst(0);
        }
        if (record.getSkipSameHandler() == null) {
            record.setSkipSameHandler(0);
        }
        if (record.getAllowReturn() == null) {
            record.setAllowReturn(1);
        }
        if (record.getAllowTransfer() == null) {
            record.setAllowTransfer(1);
        }
        if (record.getAllowDelegate() == null) {
            record.setAllowDelegate(1);
        }
        if (record.getAllowWithdraw() == null) {
            record.setAllowWithdraw(1);
        }
        iSpFlowFormService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpFlowForm record) {
        iSpFlowFormService.removeById(record.getId());
        return Result.success();
    }
}
