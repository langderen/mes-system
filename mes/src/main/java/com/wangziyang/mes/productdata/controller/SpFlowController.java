package com.wangziyang.mes.productdata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productdata.entity.SpProductBom;
import com.wangziyang.mes.productdata.entity.SpProductBomItem;
import com.wangziyang.mes.productdata.service.ISpProductBomItemService;
import com.wangziyang.mes.productdata.service.ISpProductBomService;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("spProductDataFlowController")
@RequestMapping("/productdata/flow")
public class SpFlowController extends BaseController {

    @Autowired
    private ISpProductBomService productBomService;

    @Autowired
    private ISpProductBomItemService bomItemService;

    @Autowired
    private ISpOperService operService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "productdata/flow/list";
    }

    @GetMapping("/oper-select-ui")
    public String operSelectUI(Model model, String bomItemId, String bomId) {
        model.addAttribute("bomItemId", bomItemId);
        model.addAttribute("bomId", bomId);
        return "productdata/flow/operSelect";
    }

    @GetMapping("/bom-list")
    @ResponseBody
    public Result bomList() {
        List<SpProductBom> list = productBomService.list(
                new QueryWrapper<SpProductBom>()
                        .eq("is_deleted", "0")
                        .orderByDesc("update_time"));
        return Result.success(list);
    }

    @GetMapping("/bom-items")
    @ResponseBody
    public Result bomItems(String bomId) {
        if (StringUtils.isBlank(bomId)) {
            return Result.success(new ArrayList<>());
        }
        List<SpProductBomItem> items = bomItemService.list(
                new QueryWrapper<SpProductBomItem>()
                        .eq("bom_id", bomId)
                        .eq("is_deleted", "0")
                        .orderByAsc("level_no", "line_no"));

        List<Map<String, Object>> result = new ArrayList<>();
        for (SpProductBomItem item : items) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", item.getId());
            map.put("bomId", item.getBomId());
            map.put("parentItemId", item.getParentItemId());
            map.put("partId", item.getPartId());
            map.put("partCode", item.getPartCode());
            map.put("partName", item.getPartName());
            map.put("lineNo", item.getLineNo());
            map.put("levelNo", item.getLevelNo());
            map.put("qty", item.getQty());
            map.put("unit", item.getUnit());
            map.put("scrapRate", item.getScrapRate());

            List<Map<String, Object>> opers = new ArrayList<>();
            StringBuilder processText = new StringBuilder();
            if (StringUtils.isNotBlank(item.getOperId())) {
                String[] operIds = item.getOperId().split(",");
                String[] operCodes = StringUtils.isNotBlank(item.getOperCode())
                        ? item.getOperCode().split(",") : new String[0];
                for (int idx = 0; idx < operIds.length; idx++) {
                    String oid = operIds[idx].trim();
                    if (StringUtils.isNotBlank(oid)) {
                        String ocode = idx < operCodes.length ? operCodes[idx].trim() : "";
                        String oname = ocode;
                        SpOper oper = operService.getById(oid);
                        if (oper != null) {
                            oname = oper.getOperDesc();
                        }
                        Map<String, Object> operMap = new HashMap<>();
                        operMap.put("operId", oid);
                        operMap.put("operCode", ocode);
                        operMap.put("operName", oname);
                        opers.add(operMap);
                        if (processText.length() > 0) {
                            processText.append(" → ");
                        }
                        processText.append(oname);
                    }
                }
            }
            map.put("opers", opers);
            map.put("processText", processText.toString());

            result.add(map);
        }
        return Result.success(result);
    }

    @GetMapping("/all-opers")
    @ResponseBody
    public Result allOpers() {
        List<SpOper> operList = operService.list(
                new QueryWrapper<SpOper>().eq("is_deleted", "0"));
        return Result.success(operList);
    }

    @PostMapping("/save-bindings")
    @ResponseBody
    public Result saveBindings(String bomId, String bomItemId, String operIds) {
        if (StringUtils.isBlank(bomItemId)) {
            return Result.failure("参数不能为空");
        }

        SpProductBomItem bomItem = bomItemService.getOne(
                new QueryWrapper<SpProductBomItem>()
                        .eq("id", bomItemId)
                        .eq("is_deleted", "0"));
        if (bomItem == null) {
            return Result.failure("BOM子项不存在[id=" + bomItemId + "]");
        }

        if (StringUtils.isNotBlank(operIds)) {
            String[] ids = operIds.split(",");
            List<String> validOperIds = new ArrayList<>();
            List<String> validOperCodes = new ArrayList<>();
            for (String operId : ids) {
                String trimmed = operId.trim();
                if (StringUtils.isNotBlank(trimmed)) {
                    SpOper oper = operService.getById(trimmed);
                    if (oper != null) {
                        validOperIds.add(trimmed);
                        validOperCodes.add(oper.getOper());
                    }
                }
            }
            if (!validOperIds.isEmpty()) {
                bomItem.setOperId(String.join(",", validOperIds));
                bomItem.setOperCode(String.join(",", validOperCodes));
            } else {
                bomItem.setOperId(null);
                bomItem.setOperCode(null);
            }
        } else {
            bomItem.setOperId(null);
            bomItem.setOperCode(null);
        }

        bomItemService.updateById(bomItem);
        return Result.success();
    }

    @PostMapping("/lock-bom")
    @ResponseBody
    public Result lockBom(String bomId) {
        if (StringUtils.isBlank(bomId)) {
            return Result.failure("参数不能为空");
        }
        SpProductBom bom = productBomService.getById(bomId);
        if (bom == null) {
            return Result.failure("BOM不存在");
        }

        if ("locked".equals(bom.getState())) {
            return Result.failure("该BOM已锁定");
        }

        List<SpProductBomItem> items = bomItemService.list(
                new QueryWrapper<SpProductBomItem>()
                        .eq("bom_id", bomId)
                        .eq("is_deleted", "0"));
        if (items.isEmpty()) {
            return Result.failure("BOM下没有子项，无法锁定");
        }

        boolean hasUnbound = false;
        for (SpProductBomItem item : items) {
            if (StringUtils.isBlank(item.getOperId())) {
                hasUnbound = true;
                break;
            }
        }
        if (hasUnbound) {
            return Result.failure("存在未规划工艺的BOM子项，请先完成所有子项的工艺规划");
        }

        bom.setState("locked");
        productBomService.updateById(bom);

        Map<String, Object> result = new HashMap<>();
        result.put("bomId", bomId);
        result.put("bomCode", bom.getBomCode());
        result.put("bomName", bom.getBomName());
        result.put("productPartCode", bom.getProductPartCode());
        result.put("productPartName", bom.getProductPartName());
        result.put("state", "locked");
        return Result.success(result);
    }

    @PostMapping("/unlock-bom")
    @ResponseBody
    public Result unlockBom(String bomId) {
        if (StringUtils.isBlank(bomId)) {
            return Result.failure("参数不能为空");
        }
        SpProductBom bom = productBomService.getById(bomId);
        if (bom == null) {
            return Result.failure("BOM不存在");
        }
        if (!"locked".equals(bom.getState())) {
            return Result.failure("该BOM未锁定");
        }
        bom.setState("create");
        productBomService.updateById(bom);
        return Result.success();
    }
}