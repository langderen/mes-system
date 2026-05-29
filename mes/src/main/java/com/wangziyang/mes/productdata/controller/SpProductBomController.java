package com.wangziyang.mes.productdata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productdata.entity.SpProductBom;
import com.wangziyang.mes.productdata.entity.SpProductBomItem;
import com.wangziyang.mes.productdata.request.SpProductBomPageReq;
import com.wangziyang.mes.productdata.service.ISpProductBomItemService;
import com.wangziyang.mes.productdata.service.ISpProductBomService;
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

@Controller
@RequestMapping("/productdata/productbom")
public class SpProductBomController extends BaseController {

    @Autowired
    private ISpProductBomService productBomService;

    @Autowired
    private ISpProductBomItemService bomItemService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "productdata/productbom/list";
    }

    @GetMapping("/search-panel-ui")
    public String searchPanelUI(Model model) {
        return "common/spSearchPanel4ProductBom";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotBlank(id)) {
            SpProductBom bom = productBomService.getById(id);
            model.addAttribute("bom", bom);

            List<SpProductBomItem> items = bomItemService.list(
                    new QueryWrapper<SpProductBomItem>()
                            .eq("bom_id", id)
                            .eq("is_deleted", "0")
                            .orderByAsc("level_no", "line_no"));
            model.addAttribute("items", items);
        }
        return "productdata/productbom/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpProductBomPageReq req) {
        QueryWrapper<SpProductBom> wrapper = new QueryWrapper<SpProductBom>()
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(req.getBomCodeLike())) {
            wrapper.like("bom_code", req.getBomCodeLike());
        }
        if (StringUtils.isNotBlank(req.getBomNameLike())) {
            wrapper.like("bom_name", req.getBomNameLike());
        }
        if (StringUtils.isNotBlank(req.getBomType())) {
            wrapper.eq("bom_type", req.getBomType());
        }
        if (StringUtils.isNotBlank(req.getState())) {
            wrapper.eq("state", req.getState());
        }
        wrapper.orderByDesc("update_time");
        IPage<SpProductBom> page = productBomService.page(req, wrapper);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpProductBom bom) {
        productBomService.saveOrUpdate(bom);
        return Result.success(bom);
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpProductBom bom = productBomService.getById(id);
        if (bom != null) {
            bom.setDeleted("1");
            productBomService.updateById(bom);
        }
        return Result.success();
    }

    @PostMapping("/item/add-or-update")
    @ResponseBody
    public Result itemAddOrUpdate(SpProductBomItem item) {
        bomItemService.saveOrUpdate(item);
        return Result.success(item);
    }

    @PostMapping("/item/delete")
    @ResponseBody
    public Result itemDelete(String id) {
        SpProductBomItem item = bomItemService.getById(id);
        if (item != null) {
            item.setDeleted("1");
            bomItemService.updateById(item);
        }
        return Result.success();
    }

    @GetMapping("/item/list")
    @ResponseBody
    public Result itemList(String bomId) {
        List<SpProductBomItem> items = bomItemService.list(
                new QueryWrapper<SpProductBomItem>()
                        .eq("bom_id", bomId)
                        .eq("is_deleted", "0")
                        .orderByAsc("level_no", "line_no"));
        return Result.success(items);
    }

    @GetMapping("/item/tree")
    @ResponseBody
    public Result itemTree(String bomId) {
        List<SpProductBomItem> allItems = bomItemService.list(
                new QueryWrapper<SpProductBomItem>()
                        .eq("bom_id", bomId)
                        .eq("is_deleted", "0")
                        .orderByAsc("level_no", "line_no"));
        List<SpProductBomItem> rootItems = new ArrayList<>();
        for (SpProductBomItem item : allItems) {
            if (StringUtils.isBlank(item.getParentItemId())) {
                rootItems.add(item);
            }
        }
        return Result.success(rootItems);
    }
}
