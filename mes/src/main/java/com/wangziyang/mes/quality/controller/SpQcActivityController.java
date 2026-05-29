package com.wangziyang.mes.quality.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.quality.entity.SpQcActivity;
import com.wangziyang.mes.quality.service.ISpQcActivityService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/quality/activity")
public class SpQcActivityController extends BaseController {

    @Autowired
    private ISpQcActivityService qcActivityService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "quality/activity/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, String id) {
        if (StringUtils.isNotEmpty(id)) {
            SpQcActivity activity = qcActivityService.getById(id);
            model.addAttribute("result", activity);
        }
        return "quality/activity/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(Integer current, Integer size, String activityCode, String activityName, String activityType, String status) {
        QueryWrapper<SpQcActivity> wrapper = new QueryWrapper<SpQcActivity>()
                .eq("is_deleted", "0")
                .like(StringUtils.isNotBlank(activityCode), "activity_code", activityCode)
                .like(StringUtils.isNotBlank(activityName), "activity_name", activityName)
                .eq(StringUtils.isNotBlank(activityType), "activity_type", activityType)
                .eq(StringUtils.isNotBlank(status), "status", status)
                .orderByDesc("create_time");
        IPage<SpQcActivity> result = qcActivityService.page(new Page<>(current, size), wrapper);
        return Result.success(result);
    }

    @PostMapping("/save")
    @ResponseBody
    public Result save(@RequestBody SpQcActivity record) {
        if (StringUtils.isBlank(record.getActivityCode())) {
            return Result.failure("活动编码不能为空");
        }
        if (StringUtils.isBlank(record.getActivityName())) {
            return Result.failure("活动名称不能为空");
        }
        QueryWrapper<SpQcActivity> wrapper = new QueryWrapper<SpQcActivity>()
                .eq("activity_code", record.getActivityCode())
                .eq("is_deleted", "0");
        if (StringUtils.isNotBlank(record.getId())) {
            wrapper.ne("id", record.getId());
        }
        if (qcActivityService.count(wrapper) > 0) {
            return Result.failure("活动编码已存在");
        }
        qcActivityService.saveOrUpdate(record);
        return Result.success();
    }

    @GetMapping("/get")
    @ResponseBody
    public Result get(String id) {
        SpQcActivity activity = qcActivityService.getById(id);
        return activity != null ? Result.success(activity) : Result.failure("数据不存在");
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(String id) {
        SpQcActivity record = qcActivityService.getById(id);
        if (record != null) {
            record.setDeleted("1");
            qcActivityService.updateById(record);
        }
        return Result.success();
    }
}