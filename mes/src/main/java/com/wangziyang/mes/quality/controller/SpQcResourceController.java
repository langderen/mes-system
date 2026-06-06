package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.SpQcResource;
import com.wangziyang.mes.quality.service.ISpQcResourceService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/quality/resource")
public class SpQcResourceController extends BaseController {

    @Autowired
    private ISpQcResourceService qcResourceService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/resource/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        model.addAttribute("id", id);
        SpQcResource resource = new SpQcResource();
        if (StringUtils.isNotEmpty(id)) {
            resource = qcResourceService.getById(id);
            if (resource == null) {
                resource = new SpQcResource();
                resource.setId(id);
            }
        }
        model.addAttribute("result", resource);
        return "quality/resource/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String resourceCode, String resourceName, String resourceType, String status) {
        QueryWrapper<SpQcResource> wrapper = new QueryWrapper<SpQcResource>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(resourceCode), "resource_code", resourceCode)
                .like(StringUtils.isNotBlank(resourceName), "resource_name", resourceName)
                .eq(StringUtils.isNotBlank(resourceType), "resource_type", resourceType)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .orderByDesc("create_time");
        IPage<SpQcResource> result = qcResourceService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @PostMapping("/save")
    @ResponseBody
    public Result save(@RequestBody SpQcResource record) {
        if (StringUtils.isBlank(record.getResourceCode())) {
            return Result.failure("资源编码不能为空");
        }
        if (StringUtils.isBlank(record.getResourceName())) {
            return Result.failure("资源名称不能为空");
        }
        QueryWrapper<SpQcResource> wrapper = new QueryWrapper<SpQcResource>()
                .eq("resource_code", record.getResourceCode())
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(record.getId())) {
            wrapper.ne("id", record.getId());
        }
        if (qcResourceService.count(wrapper) > 0) {
            return Result.failure("资源编码已存在");
        }
        qcResourceService.saveOrUpdate(record);
        return Result.success();
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        SpQcResource resource = qcResourceService.getById(id);
        return resource != null ? Result.success(resource) : Result.failure("数据不存在");
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcResource record = qcResourceService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcResourceService.updateById(record);
        }
        return Result.success();
    }
}
