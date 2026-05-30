package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpFlowCategory;
import com.wangziyang.mes.technology.entity.SpFlowDefinition;
import com.wangziyang.mes.technology.request.SpFlowReq;
import com.wangziyang.mes.technology.service.ISpFlowCategoryService;
import com.wangziyang.mes.technology.service.ISpFlowDefinitionService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/technology/flow/definition")
public class SpFlowDefinitionController extends BaseController {

    @Autowired
    private ISpFlowDefinitionService iSpFlowDefinitionService;

    @Autowired
    private ISpFlowCategoryService flowCategoryService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/flowdefinition/list";
    }

    @ApiOperation("流程定义分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpFlowReq req) {
        QueryWrapper<SpFlowDefinition> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowLike())) {
            qw.like("flow_code", req.getFlowLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowDescLike())) {
            qw.like("flow_name", req.getFlowDescLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowCategoryId())) {
            qw.eq("flow_category_id", req.getFlowCategoryId());
        }
        qw.orderByDesc("update_time");
        IPage<SpFlowDefinition> result = iSpFlowDefinitionService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpFlowDefinition record) {
        if (record == null) {
            record = new SpFlowDefinition();
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(record.getId())) {
            model.addAttribute("result", iSpFlowDefinitionService.getById(record.getId()));
        } else {
            model.addAttribute("result", record);
        }
        model.addAttribute("categories", flowCategoryService.list(new QueryWrapper<SpFlowCategory>().eq("is_deleted", "0").orderByAsc("sort_num")));
        return "technology/flowdefinition/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpFlowDefinition record) throws Exception {
        if (org.apache.commons.lang3.StringUtils.isNotBlank(record.getFlowCategoryId())) {
            SpFlowCategory category = flowCategoryService.getById(record.getFlowCategoryId());
            if (category != null) {
                record.setFlowCategoryName(category.getCategoryName());
            }
        }
        iSpFlowDefinitionService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpFlowDefinition record) throws Exception {
        iSpFlowDefinitionService.removeById(record.getId());
        return Result.success();
    }
}
