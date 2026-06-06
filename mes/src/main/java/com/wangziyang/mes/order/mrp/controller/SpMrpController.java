package com.wangziyang.mes.order.mrp.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.mrp.entity.SpMrpRecord;
import com.wangziyang.mes.order.mrp.service.ISpMrpRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/order/mrp")
public class SpMrpController extends BaseController {

    @Autowired
    private ISpMrpRecordService mrpRecordService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "order/mrp/list";
    }

    @GetMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String mrpNo, String orderCode, String partCode, String partName) {
        Page<SpMrpRecord> page = new Page<>(current == null ? 1 : current, size == null ? 20 : size);
        QueryWrapper<SpMrpRecord> wrapper = new QueryWrapper<SpMrpRecord>().orderByDesc("create_time");
        if (StringUtils.isNotBlank(mrpNo)) {
            wrapper.like("mrp_no", mrpNo);
        }
        if (StringUtils.isNotBlank(orderCode)) {
            wrapper.like("order_code", orderCode);
        }
        if (StringUtils.isNotBlank(partCode)) {
            wrapper.like("part_code", partCode);
        }
        if (StringUtils.isNotBlank(partName)) {
            wrapper.like("part_name", partName);
        }
        IPage<SpMrpRecord> result = mrpRecordService.page(page, wrapper);
        return Result.success(result);
    }

    @GetMapping("/detail-ui")
    public String detailUI(Model model, String id) {
        if (StringUtils.isBlank(id)) {
            model.addAttribute("errorMsg", "参数错误：MRP记录ID不能为空");
            model.addAttribute("result", null);
        } else {
            // 清理ID中可能混入的特殊字符
            String cleanId = id.replaceAll("[^0-9a-zA-Z]", "");
            if (!cleanId.equals(id)) {
                // 记录原始ID和清理后的ID，方便排查
                System.out.println("MRP详情 - 原始ID: " + id + ", 清理后ID: " + cleanId);
            }
            SpMrpRecord record = mrpRecordService.getById(cleanId);
            if (record == null) {
                model.addAttribute("errorMsg", "未找到ID为 " + cleanId + " 的MRP记录");
            }
            model.addAttribute("result", record);
        }
        return "order/mrp/detail";
    }
}
