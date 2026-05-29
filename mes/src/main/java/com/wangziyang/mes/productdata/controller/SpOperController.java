package com.wangziyang.mes.productdata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productdata.request.SpOperPageReq;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.vo.SpOperVo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Controller("spProductDataOperController")
@RequestMapping("/productdata/oper")
public class SpOperController extends BaseController {

    @Autowired
    private ISpOperService operService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "productdata/oper/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotBlank(id)) {
            SpOper oper = operService.getById(id);
            model.addAttribute("oper", oper);
        }
        return "productdata/oper/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOperPageReq req) {
        QueryWrapper<SpOper> wrapper = new QueryWrapper<SpOper>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(req.getOperLike())) {
            wrapper.like("oper", req.getOperLike());
        }
        if (StringUtils.isNotBlank(req.getOperDescLike())) {
            wrapper.like("oper_desc", req.getOperDescLike());
        }
        if (StringUtils.isNotBlank(req.getOperType())) {
            wrapper.eq("oper_type", req.getOperType());
        }
        wrapper.orderByDesc("update_time");
        IPage<SpOper> page = operService.page(req, wrapper);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOper oper) {
        operService.saveOrUpdate(oper);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpOper oper = operService.getById(id);
        if (oper != null) {
            oper.setDeleted("1");
            operService.updateById(oper);
        }
        return Result.success();
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        List<SpOper> list = operService.list(
                new QueryWrapper<SpOper>().eq("is_deleted", "0"));
        return Result.success(list);
    }

    @GetMapping("/vo-list")
    @ResponseBody
    public Result voList() {
        List<SpOper> operList = operService.list(
                new QueryWrapper<SpOper>().eq("is_deleted", "0"));
        List<SpOperVo> voList = new ArrayList<>();
        for (SpOper spOper : operList) {
            SpOperVo vo = new SpOperVo();
            vo.setValue(spOper.getId());
            vo.setTitle(spOper.getOper());
            voList.add(vo);
        }
        return Result.success(voList);
    }
}
