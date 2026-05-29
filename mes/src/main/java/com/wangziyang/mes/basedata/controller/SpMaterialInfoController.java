package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpMaterialInfo;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.request.SpMaterialInfoPageReq;
import com.wangziyang.mes.basedata.service.ISpMaterialInfoService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/basedata/materialinfo")
public class SpMaterialInfoController extends BaseController {

    @Autowired
    private ISpMaterialInfoService iSpMaterialInfoService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/materialinfo/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpMaterialInfo materialInfo = iSpMaterialInfoService.getById(record.getId());
            model.addAttribute("result", materialInfo);
        } else {
            model.addAttribute("generatedCode", iSpMaterialInfoService.generateMaterialCode());
        }
        return "basedata/materialinfo/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpMaterialInfoPageReq req) {
        QueryWrapper<SpMaterialInfo> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.likeRight("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        if (StringUtils.isNotEmpty(req.getMatTypeLike())) {
            qw.likeRight("mat_type", req.getMatTypeLike());
        }
        qw.orderByDesc(req.getOrderBy());
        IPage<SpMaterialInfo> result = iSpMaterialInfoService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/generate-code")
    @ResponseBody
    public Result generateCode() {
        return Result.success(iSpMaterialInfoService.generateMaterialCode());
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpMaterialInfo record) {
        iSpMaterialInfoService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpMaterialInfo record) {
        iSpMaterialInfoService.removeById(record.getId());
        return Result.success();
    }
}