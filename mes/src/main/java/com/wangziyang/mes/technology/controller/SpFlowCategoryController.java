package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpFlowCategory;
import com.wangziyang.mes.technology.request.SpFlowCategoryPageReq;
import com.wangziyang.mes.technology.service.ISpFlowCategoryService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/technology/flow/category")
public class SpFlowCategoryController extends BaseController {

    @Autowired
    private ISpFlowCategoryService flowCategoryService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/flowcategory/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpFlowCategory record) {
        if (StringUtils.isNotBlank(record.getId())) {
            model.addAttribute("result", flowCategoryService.getById(record.getId()));
        }
        return "technology/flowcategory/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpFlowCategoryPageReq req) {
        QueryWrapper<SpFlowCategory> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotBlank(req.getCategoryCodeLike())) {
            qw.like("category_code", req.getCategoryCodeLike());
        }
        if (StringUtils.isNotBlank(req.getCategoryNameLike())) {
            qw.like("category_name", req.getCategoryNameLike());
        }
        qw.orderByDesc("sort_num", "create_time");
        IPage<SpFlowCategory> result = flowCategoryService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpFlowCategory record) {
        flowCategoryService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpFlowCategory record) {
        flowCategoryService.removeById(record.getId());
        return Result.success();
    }
}
