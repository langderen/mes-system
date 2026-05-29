package com.wangziyang.mes.productdata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productdata.entity.SpPart;
import com.wangziyang.mes.productdata.request.SpPartPageReq;
import com.wangziyang.mes.productdata.service.ISpPartService;
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
@RequestMapping("/productdata/part")
public class SpPartController extends BaseController {

    @Autowired
    private ISpPartService partService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "productdata/part/list";
    }

    @GetMapping("/search-panel-ui")
    public String searchPanelUI(Model model) {
        return "common/spSearchPanel4Part";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotBlank(id)) {
            SpPart part = partService.getById(id);
            model.addAttribute("part", part);
        }
        return "productdata/part/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpPartPageReq req) {
        QueryWrapper<SpPart> wrapper = new QueryWrapper<SpPart>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(req.getPartCodeLike())) {
            wrapper.like("part_code", req.getPartCodeLike());
        }
        if (StringUtils.isNotBlank(req.getPartNameLike())) {
            wrapper.like("part_name", req.getPartNameLike());
        }
        if (StringUtils.isNotBlank(req.getPartType())) {
            wrapper.eq("part_type", req.getPartType());
        }
        wrapper.orderByDesc("update_time");
        IPage<SpPart> page = partService.page(req, wrapper);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpPart part) {
        partService.saveOrUpdate(part);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpPart part = partService.getById(id);
        if (part != null) {
            part.setDeleted("1");
            partService.updateById(part);
        }
        return Result.success();
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        List<SpPart> list = partService.list(
                new QueryWrapper<SpPart>().eq("is_deleted", "0").eq("status", "0"));
        return Result.success(list);
    }
}
