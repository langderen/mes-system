package com.wangziyang.mes.technology.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.dto.SpFlowDto;
import com.wangziyang.mes.technology.entity.SpFlowCategory;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.request.SpFlowReq;
import com.wangziyang.mes.technology.service.ISpFlowCategoryService;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.technology.service.ISpFlowOperRelationService;
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

import java.util.List;

/**
 * <p>
 * 流程控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-14
 */
@Controller
@RequestMapping("/basedata/flow")
public class SpFlowController extends BaseController {

    @Autowired
    public ISpFlowService iSpFlowService;

    @Autowired
    private ISpFlowCategoryService flowCategoryService;

    @Autowired
    private ISpFlowOperRelationService flowOperRelationService;

    /**
     * 流程信息分页查询
     *
     * @param req 请求参数
     * @return Result 执行结果
     */
    @ApiOperation("流程信息分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpFlowReq req) {
        QueryWrapper<SpFlow> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowLike())) {
            qw.like("flow", req.getFlowLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowDescLike())) {
            qw.like("flow_desc", req.getFlowDescLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getFlowCategoryId())) {
            qw.eq("flow_category_id", req.getFlowCategoryId());
        }
        qw.orderByDesc("update_time");
        IPage<SpFlow> result = iSpFlowService.page(req, qw);
        return Result.success(result);
    }


    /**
     * 流程全部信息查询
     *
     * @return Result 执行结果
     */
    @ApiOperation("流程全部信息查询")
    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        QueryWrapper queryWrapper = new QueryWrapper();
        //queryWrapper.eq("is_deleted", "0");
        List<SpFlow> list = iSpFlowService.list(queryWrapper);
        return Result.success(list);
    }

    @GetMapping("/flowprocess/add-or-update-ui")
    public String flowprocessAddOrUpdateUI(Model model, SpFlow record) {
        if (record == null) {
            record = new SpFlow();
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(record.getId())) {
            model.addAttribute("result", iSpFlowService.getById(record.getId()));
        } else {
            model.addAttribute("result", record);
        }
        model.addAttribute("categories", flowCategoryService.list(new QueryWrapper<SpFlowCategory>().eq("is_deleted", "0").orderByAsc("sort_num")));
        return "technology/flowprocess/add";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpFlowDto record) throws Exception {
        SpFlow flow = new SpFlow();
        org.springframework.beans.BeanUtils.copyProperties(record, flow);
        if (org.apache.commons.lang3.StringUtils.isNotBlank(record.getFlowCategoryId())) {
            SpFlowCategory category = flowCategoryService.getById(record.getFlowCategoryId());
            if (category != null) {
                flow.setFlowCategoryName(category.getCategoryName());
            }
        }
        iSpFlowService.saveOrUpdate(flow);
        return Result.success(flow.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpFlow record) throws Exception {
        iSpFlowService.removeById(record.getId());
        return Result.success();
    }

}
