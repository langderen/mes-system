package com.wangziyang.mes.productdata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productdata.entity.SpProcessContent;
import com.wangziyang.mes.productdata.entity.SpProcessMaterial;
import com.wangziyang.mes.productdata.entity.SpProductBomItem;
import com.wangziyang.mes.productdata.service.ISpProcessContentService;
import com.wangziyang.mes.productdata.service.ISpProcessMaterialService;
import com.wangziyang.mes.productdata.service.ISpProductBomItemService;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 工艺内容编制控制器
 */
@Controller
@RequestMapping("/productdata/content")
public class SpProcessContentController extends BaseController {

    @Autowired
    private ISpProcessContentService processContentService;

    @Autowired
    private ISpProcessMaterialService processMaterialService;

    @Autowired
    private ISpProductBomItemService bomItemService;

    @Autowired
    private ISpOperService operService;

    private ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 工艺内容编制列表页面
     */
    @GetMapping("/list-ui")
    public String listUI(Model model, String bomId, String bomItemId, String bomName, String partName) {
        model.addAttribute("bomId", bomId);
        model.addAttribute("bomItemId", bomItemId);
        model.addAttribute("bomName", bomName);
        model.addAttribute("partName", partName);
        return "productdata/content/list";
    }

    /**
     * 获取BOM子项关联的工序列表
     */
    @GetMapping("/oper-list")
    @ResponseBody
    public Result operList(String bomItemId) {
        if (StringUtils.isBlank(bomItemId)) {
            return Result.success(new ArrayList<>());
        }

        SpProductBomItem bomItem = bomItemService.getById(bomItemId);
        if (bomItem == null) {
            return Result.success(new ArrayList<>());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        if (StringUtils.isNotBlank(bomItem.getOperId())) {
            String[] operIds = bomItem.getOperId().split(",");
            for (String operId : operIds) {
                String trimmedId = operId.trim();
                if (StringUtils.isNotBlank(trimmedId)) {
                    SpOper oper = operService.getOne(
                            new QueryWrapper<SpOper>()
                                    .eq("id", trimmedId)
                                    .eq("is_deleted", "0"));
                    if (oper != null) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("id", trimmedId);
                        map.put("operCode", oper.getOper());
                        map.put("operName", oper.getOperDesc());

                        // 查询工艺内容状态
                        SpProcessContent content = processContentService.getOne(
                                new QueryWrapper<SpProcessContent>()
                                        .eq("oper_id", trimmedId)
                                        .eq("bom_item_id", bomItemId)
                                        .eq("is_deleted", "0"));
                        if (content != null && "lock".equals(content.getStatus())) {
                            map.put("status", "lock");
                        } else {
                            map.put("status", "edit");
                        }
                        result.add(map);
                    }
                }
            }
        }
        return Result.success(result);
    }

    /**
     * 获取BOM下所有子项及其编制状态（根据parentItemId构建树形结构）
     */
    @GetMapping("/bom-item-list")
    @ResponseBody
    public Result bomItemList(String bomId) {
        if (StringUtils.isBlank(bomId)) {
            return Result.success(new ArrayList<>());
        }

        List<SpProductBomItem> items = bomItemService.list(
                new QueryWrapper<SpProductBomItem>()
                        .eq("bom_id", bomId)
                        .eq("is_deleted", "0")
                        .orderByAsc("level_no", "line_no"));

        // 构建ID到项的映射
        Map<String, SpProductBomItem> itemMap = new HashMap<>();
        for (SpProductBomItem item : items) {
            itemMap.put(item.getId(), item);
        }

        // 找出根节点（parent_item_id为空或指向不存在的项）
        List<SpProductBomItem> rootItems = new ArrayList<>();
        for (SpProductBomItem item : items) {
            String parentId = item.getParentItemId();
            if (StringUtils.isBlank(parentId) || !itemMap.containsKey(parentId)) {
                rootItems.add(item);
            }
        }

        // 构建树形结构
        List<Map<String, Object>> result = new ArrayList<>();
        for (SpProductBomItem rootItem : rootItems) {
            buildTreeItems(rootItem, itemMap, result, 0);
        }

        return Result.success(result);
    }

    /**
     * 递归构建树形列表
     */
    private void buildTreeItems(SpProductBomItem item, Map<String, SpProductBomItem> itemMap,
                                List<Map<String, Object>> result, int indentLevel) {
        // 跳过没有零部件信息的项
        if (StringUtils.isBlank(item.getPartCode()) && StringUtils.isBlank(item.getPartName())) {
            // 但继续处理子节点
            addChildren(item.getId(), itemMap, result, indentLevel);
            return;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("id", item.getId());
        map.put("parentItemId", item.getParentItemId());
        map.put("partCode", StringUtils.isBlank(item.getPartCode()) ? "-" : item.getPartCode());
        map.put("partName", StringUtils.isBlank(item.getPartName()) ? "(未命名)" : item.getPartName());
        map.put("levelNo", indentLevel);
        map.put("lineNo", item.getLineNo());
        map.put("qty", item.getQty());
        map.put("unit", item.getUnit());

        // 检查是否有关联工序
        boolean hasOper = StringUtils.isNotBlank(item.getOperId());
        map.put("hasOper", hasOper);

        // 检查编制状态
        boolean allSaved = true;
        boolean allCompleted = true;
        if (hasOper) {
            String[] operIds = item.getOperId().split(",");
            for (String operId : operIds) {
                String trimmedId = operId.trim();
                if (StringUtils.isNotBlank(trimmedId)) {
                    SpProcessContent content = processContentService.getOne(
                            new QueryWrapper<SpProcessContent>()
                                    .eq("oper_id", trimmedId)
                                    .eq("bom_item_id", item.getId())
                                    .eq("is_deleted", "0"));
                    if (content == null) {
                        allSaved = false;
                        allCompleted = false;
                        break;
                    } else if (!"lock".equals(content.getStatus())) {
                        allCompleted = false;
                    }
                }
            }
        } else {
            allSaved = false;
            allCompleted = false;
        }

        map.put("saved", hasOper && allSaved);
        map.put("completed", hasOper && allCompleted);

        // 生成显示文本
        StringBuilder displayText = new StringBuilder();
        for (int i = 0; i < indentLevel; i++) {
            displayText.append("　　");
        }
        if (indentLevel > 0) {
            displayText.append("└ ");
        }
        displayText.append(item.getPartCode()).append(" / ").append(item.getPartName());

        if (!hasOper) {
            displayText.append(" [未规划工序]");
        } else if (allCompleted) {
            displayText.append(" [已完成]");
        } else if (allSaved) {
            displayText.append(" [已保存]");
        } else {
            displayText.append(" [未完成]");
        }

        map.put("displayText", displayText.toString());
        result.add(map);

        // 递归添加子节点
        addChildren(item.getId(), itemMap, result, indentLevel);
    }

    /**
     * 添加所有子节点
     */
    private void addChildren(String parentId, Map<String, SpProductBomItem> itemMap,
                            List<Map<String, Object>> result, int indentLevel) {
        for (SpProductBomItem item : itemMap.values()) {
            if (parentId.equals(item.getParentItemId())) {
                buildTreeItems(item, itemMap, result, indentLevel + 1);
            }
        }
    }

    /**
     * 获取工序工艺编制详情
     */
    @GetMapping("/process-detail")
    @ResponseBody
    public Result processDetail(String operId) {
        if (StringUtils.isBlank(operId)) {
            return Result.failure("参数不能为空");
        }

        SpProcessContent content = processContentService.getOne(
                new QueryWrapper<SpProcessContent>()
                        .eq("oper_id", operId)
                        .eq("is_deleted", "0"));

        Map<String, Object> result = new HashMap<>();
        if (content != null) {
            result.put("operCode", content.getOperCode());
            result.put("operName", content.getOperName());
            result.put("workHour", content.getWorkHour());
            result.put("operType", content.getOperType());
            result.put("operStep", content.getOperStep());
            result.put("techRequire", content.getTechRequire());
            result.put("notice", content.getNotice());
            result.put("equipment", content.getEquipment());
            result.put("tooling", content.getTooling());
            result.put("cutter", content.getCutter());
            result.put("status", content.getStatus());

            // 解析图片列表
            if (StringUtils.isNotBlank(content.getImgList())) {
                try {
                    List<Map<String, Object>> imgList = objectMapper.readValue(
                            content.getImgList(),
                            new TypeReference<List<Map<String, Object>>>() {});
                    result.put("imgList", imgList);
                } catch (IOException e) {
                    result.put("imgList", new ArrayList<>());
                }
            } else {
                result.put("imgList", new ArrayList<>());
            }
        } else {
            // 从工序主表获取基本信息
            SpOper oper = operService.getOne(
                    new QueryWrapper<SpOper>()
                            .eq("id", operId)
                            .eq("is_deleted", "0"));
            if (oper != null) {
                result.put("operCode", oper.getOper());
                result.put("operName", oper.getOperDesc());
                result.put("operType", oper.getOperType());
                if (oper.getStandardTime() != null) {
                    result.put("workHour", oper.getStandardTime());
                }
            }
            result.put("imgList", new ArrayList<>());
            result.put("status", "edit");
        }

        // 获取备料清单
        List<SpProcessMaterial> materials = processMaterialService.list(
                new QueryWrapper<SpProcessMaterial>()
                        .eq("oper_id", operId)
                        .eq("is_deleted", "0"));
        result.put("materialList", materials);

        return Result.success(result);
    }

    /**
     * 保存工艺编制内容
     */
    @PostMapping("/save-process")
    @ResponseBody
    public Result saveProcess(@RequestBody Map<String, Object> params) {
        String operId = (String) params.get("operId");
        if (StringUtils.isBlank(operId)) {
            return Result.failure("工序ID不能为空");
        }

        String bomId = (String) params.get("bomId");
        String bomItemId = (String) params.get("bomItemId");

        // 查询或创建工艺内容
        SpProcessContent content = processContentService.getOne(
                new QueryWrapper<SpProcessContent>()
                        .eq("oper_id", operId)
                        .eq("is_deleted", "0"));

        if (content == null) {
            content = new SpProcessContent();
            content.setOperId(operId);
            content.setBomId(bomId);
            content.setBomItemId(bomItemId);
            content.setStatus("edit");
            content.setDeleted("0");
        }

        // 检查是否已锁定
        if ("lock".equals(content.getStatus())) {
            return Result.failure("该工序已完成编制，不可修改");
        }

        // 设置字段值
        content.setOperCode((String) params.get("operCode"));
        content.setOperName((String) params.get("operName"));

        if (params.get("workHour") != null) {
            try {
                java.math.BigDecimal workHour = new java.math.BigDecimal(params.get("workHour").toString());
                content.setWorkHour(workHour);
            } catch (NumberFormatException e) {
                // 忽略转换错误
            }
        }

        content.setOperType((String) params.get("operType"));
        content.setOperStep((String) params.get("operStep"));
        content.setTechRequire((String) params.get("techRequire"));
        content.setNotice((String) params.get("notice"));
        content.setEquipment((String) params.get("equipment"));
        content.setTooling((String) params.get("tooling"));
        content.setCutter((String) params.get("cutter"));

        // 处理图片列表
        Object imgListObj = params.get("imgList");
        if (imgListObj != null) {
            try {
                String imgListJson = objectMapper.writeValueAsString(imgListObj);
                content.setImgList(imgListJson);
            } catch (IOException e) {
                // 忽略转换错误
            }
        }

        processContentService.saveOrUpdate(content);

        // 处理备料清单
        Object materialListObj = params.get("materialList");
        if (materialListObj != null) {
            try {
                List<Map<String, Object>> materialList = objectMapper.convertValue(
                        materialListObj,
                        new TypeReference<List<Map<String, Object>>>() {});

                // 删除旧的备料清单
                processMaterialService.remove(
                        new QueryWrapper<SpProcessMaterial>().eq("oper_id", operId));

                // 保存新的备料清单
                for (Map<String, Object> materialMap : materialList) {
                    SpProcessMaterial material = new SpProcessMaterial();
                    material.setOperId(operId);
                    material.setMaterialCode((String) materialMap.get("materialCode"));
                    material.setMaterialName((String) materialMap.get("materialName"));
                    material.setDeleted("0");

                    if (materialMap.get("qty") != null) {
                        try {
                            java.math.BigDecimal qty = new java.math.BigDecimal(materialMap.get("qty").toString());
                            material.setQty(qty);
                        } catch (NumberFormatException e) {
                            // 忽略转换错误
                        }
                    }

                    material.setUnit((String) materialMap.get("unit"));
                    processMaterialService.save(material);
                }
            } catch (Exception e) {
                // 忽略转换错误
            }
        }

        return Result.success();
    }

    /**
     * 完成编制（锁定）
     */
    @PostMapping("/complete-process")
    @ResponseBody
    public Result completeProcess(String operId) {
        if (StringUtils.isBlank(operId)) {
            return Result.failure("参数不能为空");
        }

        SpProcessContent content = processContentService.getOne(
                new QueryWrapper<SpProcessContent>()
                        .eq("oper_id", operId)
                        .eq("is_deleted", "0"));

        if (content == null) {
            return Result.failure("未找到工艺内容，请先保存");
        }

        if ("lock".equals(content.getStatus())) {
            return Result.failure("该工序已完成编制");
        }

        content.setStatus("lock");
        processContentService.updateById(content);

        return Result.success();
    }
}
