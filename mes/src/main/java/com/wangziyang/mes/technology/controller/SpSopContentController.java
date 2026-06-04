package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.*;
import com.wangziyang.mes.technology.request.SpSopContentReq;
import com.wangziyang.mes.technology.service.*;
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

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/technology/sop/content")
public class SpSopContentController extends BaseController {

    @Autowired
    private ISpSopContentService iSpSopContentService;

    @Autowired
    private ISpSopWorkStepService iSpSopWorkStepService;

    @Autowired
    private ISpSopProcessParamService iSpSopProcessParamService;

    @Autowired
    private ISpSopMaterialService iSpSopMaterialService;

    @Autowired
    private ISpSopResourceService iSpSopResourceService;

    @Autowired
    private ISpSopQualityControlService iSpSopQualityControlService;

    @Autowired
    private ISpSopSelfCheckService iSpSopSelfCheckService;

    @Autowired
    private ISpSopDocumentService iSpSopDocumentService;

    @Autowired
    private ISpSopAuditLogService iSpSopAuditLogService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/sopcontent/list";
    }

    @ApiOperation("SOP工艺内容分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpSopContentReq req) {
        QueryWrapper<SpSopContent> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.eq("is_latest", "1");
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getSopCodeLike())) {
            qw.like("sop_code", req.getSopCodeLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getSopNameLike())) {
            qw.like("sop_name", req.getSopNameLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getProductCodeLike())) {
            qw.like("product_code", req.getProductCodeLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getOperCodeLike())) {
            qw.like("oper_code", req.getOperCodeLike());
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(req.getState())) {
            qw.eq("state", req.getState());
        }
        qw.orderByDesc("update_time");
        IPage<SpSopContent> result = iSpSopContentService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpSopContent record) {
        if (record == null) {
            record = new SpSopContent();
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(record.getId())) {
            SpSopContent content = iSpSopContentService.getById(record.getId());
            model.addAttribute("result", content);
            model.addAttribute("workSteps", iSpSopWorkStepService.list(new QueryWrapper<SpSopWorkStep>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("processParams", iSpSopProcessParamService.list(new QueryWrapper<SpSopProcessParam>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("materials", iSpSopMaterialService.list(new QueryWrapper<SpSopMaterial>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("resources", iSpSopResourceService.list(new QueryWrapper<SpSopResource>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("qualityControls", iSpSopQualityControlService.list(new QueryWrapper<SpSopQualityControl>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("selfChecks", iSpSopSelfCheckService.list(new QueryWrapper<SpSopSelfCheck>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("sort_num")));
            model.addAttribute("documents", iSpSopDocumentService.list(new QueryWrapper<SpSopDocument>().eq("sop_content_id", record.getId()).eq("is_deleted", "0").orderByAsc("create_time")));
        } else {
            model.addAttribute("result", record);
        }
        return "technology/sopcontent/addOrUpdate";
    }

    @GetMapping("/detail-ui")
    public String detailUI(Model model, String id) {
        SpSopContent content = iSpSopContentService.getById(id);
        model.addAttribute("result", content);
        model.addAttribute("workSteps", iSpSopWorkStepService.list(new QueryWrapper<SpSopWorkStep>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("processParams", iSpSopProcessParamService.list(new QueryWrapper<SpSopProcessParam>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("materials", iSpSopMaterialService.list(new QueryWrapper<SpSopMaterial>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("resources", iSpSopResourceService.list(new QueryWrapper<SpSopResource>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("qualityControls", iSpSopQualityControlService.list(new QueryWrapper<SpSopQualityControl>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("selfChecks", iSpSopSelfCheckService.list(new QueryWrapper<SpSopSelfCheck>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        model.addAttribute("documents", iSpSopDocumentService.list(new QueryWrapper<SpSopDocument>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("create_time")));
        model.addAttribute("auditLogs", iSpSopAuditLogService.list(new QueryWrapper<SpSopAuditLog>().eq("sop_content_id", id).orderByDesc("audit_time")));
        return "technology/sopcontent/detail";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpSopContent record) throws Exception {
        if (org.apache.commons.lang3.StringUtils.isBlank(record.getId())) {
            record.setState("draft");
            record.setVersion("V1.0");
            record.setIsLatest("1");
            record.setCompileDate(LocalDateTime.now());
        }
        iSpSopContentService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @PostMapping("/save-detail")
    @ResponseBody
    public Result saveDetail(SpSopContent record, String workStepsJson, String processParamsJson, String materialsJson, String resourcesJson, String qualityControlsJson, String selfChecksJson, String documentsJson) throws Exception {
        if (org.apache.commons.lang3.StringUtils.isBlank(record.getId())) {
            record.setState("draft");
            record.setVersion("V1.0");
            record.setIsLatest("1");
            record.setCompileDate(LocalDateTime.now());
            iSpSopContentService.save(record);
        } else {
            iSpSopContentService.updateById(record);
        }

        String sopContentId = record.getId();

        if (org.apache.commons.lang3.StringUtils.isNotBlank(workStepsJson)) {
            List<SpSopWorkStep> workSteps = com.alibaba.fastjson.JSON.parseArray(workStepsJson, SpSopWorkStep.class);
            iSpSopWorkStepService.remove(new QueryWrapper<SpSopWorkStep>().eq("sop_content_id", sopContentId));
            for (SpSopWorkStep step : workSteps) {
                step.setSopContentId(sopContentId);
                step.setId(null);
                iSpSopWorkStepService.save(step);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(processParamsJson)) {
            List<SpSopProcessParam> processParams = com.alibaba.fastjson.JSON.parseArray(processParamsJson, SpSopProcessParam.class);
            iSpSopProcessParamService.remove(new QueryWrapper<SpSopProcessParam>().eq("sop_content_id", sopContentId));
            for (SpSopProcessParam param : processParams) {
                param.setSopContentId(sopContentId);
                param.setId(null);
                iSpSopProcessParamService.save(param);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(materialsJson)) {
            List<SpSopMaterial> materials = com.alibaba.fastjson.JSON.parseArray(materialsJson, SpSopMaterial.class);
            iSpSopMaterialService.remove(new QueryWrapper<SpSopMaterial>().eq("sop_content_id", sopContentId));
            for (SpSopMaterial material : materials) {
                material.setSopContentId(sopContentId);
                material.setId(null);
                iSpSopMaterialService.save(material);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(resourcesJson)) {
            List<SpSopResource> resources = com.alibaba.fastjson.JSON.parseArray(resourcesJson, SpSopResource.class);
            iSpSopResourceService.remove(new QueryWrapper<SpSopResource>().eq("sop_content_id", sopContentId));
            for (SpSopResource resource : resources) {
                resource.setSopContentId(sopContentId);
                resource.setId(null);
                iSpSopResourceService.save(resource);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(qualityControlsJson)) {
            List<SpSopQualityControl> qualityControls = com.alibaba.fastjson.JSON.parseArray(qualityControlsJson, SpSopQualityControl.class);
            iSpSopQualityControlService.remove(new QueryWrapper<SpSopQualityControl>().eq("sop_content_id", sopContentId));
            for (SpSopQualityControl qc : qualityControls) {
                qc.setSopContentId(sopContentId);
                qc.setId(null);
                iSpSopQualityControlService.save(qc);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(selfChecksJson)) {
            List<SpSopSelfCheck> selfChecks = com.alibaba.fastjson.JSON.parseArray(selfChecksJson, SpSopSelfCheck.class);
            iSpSopSelfCheckService.remove(new QueryWrapper<SpSopSelfCheck>().eq("sop_content_id", sopContentId));
            for (SpSopSelfCheck sc : selfChecks) {
                sc.setSopContentId(sopContentId);
                sc.setId(null);
                iSpSopSelfCheckService.save(sc);
            }
        }

        if (org.apache.commons.lang3.StringUtils.isNotBlank(documentsJson)) {
            List<SpSopDocument> documents = com.alibaba.fastjson.JSON.parseArray(documentsJson, SpSopDocument.class);
            iSpSopDocumentService.remove(new QueryWrapper<SpSopDocument>().eq("sop_content_id", sopContentId));
            for (SpSopDocument doc : documents) {
                doc.setSopContentId(sopContentId);
                doc.setId(null);
                iSpSopDocumentService.save(doc);
            }
        }

        return Result.success(sopContentId);
    }

    @PostMapping("/submit-audit")
    @ResponseBody
    public Result submitAudit(String id) throws Exception {
        SpSopContent content = iSpSopContentService.getById(id);
        if (content == null) {
            return Result.error("SOP工艺内容不存在");
        }
        if (!"draft".equals(content.getState()) && !"rejected".equals(content.getState())) {
            return Result.error("当前状态不允许提交审核");
        }
        content.setState("pending");
        content.setSubmitAuditTime(LocalDateTime.now());
        iSpSopContentService.updateById(content);

        SpSopAuditLog auditLog = new SpSopAuditLog();
        auditLog.setSopContentId(id);
        auditLog.setAuditType("submit");
        auditLog.setAuditUsername(content.getUpdateUsername());
        auditLog.setAuditTime(LocalDateTime.now());
        iSpSopAuditLogService.save(auditLog);

        return Result.success();
    }

    @PostMapping("/audit")
    @ResponseBody
    public Result audit(String id, String auditResult, String auditComment) throws Exception {
        SpSopContent content = iSpSopContentService.getById(id);
        if (content == null) {
            return Result.error("SOP工艺内容不存在");
        }
        if (!"pending".equals(content.getState())) {
            return Result.error("当前状态不允许审核");
        }

        content.setAuditTime(LocalDateTime.now());
        content.setAuditUsername(content.getUpdateUsername());
        content.setAuditComment(auditComment);

        if ("pass".equals(auditResult)) {
            content.setState("approved");
        } else {
            content.setState("rejected");
        }
        iSpSopContentService.updateById(content);

        SpSopAuditLog auditLog = new SpSopAuditLog();
        auditLog.setSopContentId(id);
        auditLog.setAuditType("approve");
        auditLog.setAuditResult(auditResult);
        auditLog.setAuditComment(auditComment);
        auditLog.setAuditUsername(content.getUpdateUsername());
        auditLog.setAuditTime(LocalDateTime.now());
        iSpSopAuditLogService.save(auditLog);

        return Result.success();
    }

    @PostMapping("/publish")
    @ResponseBody
    public Result publish(String id) throws Exception {
        SpSopContent content = iSpSopContentService.getById(id);
        if (content == null) {
            return Result.error("SOP工艺内容不存在");
        }
        if (!"approved".equals(content.getState())) {
            return Result.error("只有已审核通过的SOP才能发布");
        }

        iSpSopContentService.update(new QueryWrapper<SpSopContent>().eq("sop_code", content.getSopCode()).eq("is_latest", "1").set("is_latest", "0"));

        content.setState("approved");
        content.setIsLatest("1");
        content.setPublishTime(LocalDateTime.now());
        iSpSopContentService.updateById(content);

        SpSopAuditLog auditLog = new SpSopAuditLog();
        auditLog.setSopContentId(id);
        auditLog.setAuditType("publish");
        auditLog.setAuditUsername(content.getUpdateUsername());
        auditLog.setAuditTime(LocalDateTime.now());
        iSpSopAuditLogService.save(auditLog);

        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpSopContent record) throws Exception {
        SpSopContent content = iSpSopContentService.getById(record.getId());
        if (content != null && ("approved".equals(content.getState()) || "pending".equals(content.getState()))) {
            return Result.error("已审核或审核中的SOP不允许删除");
        }
        iSpSopContentService.removeById(record.getId());
        iSpSopWorkStepService.remove(new QueryWrapper<SpSopWorkStep>().eq("sop_content_id", record.getId()));
        iSpSopProcessParamService.remove(new QueryWrapper<SpSopProcessParam>().eq("sop_content_id", record.getId()));
        iSpSopMaterialService.remove(new QueryWrapper<SpSopMaterial>().eq("sop_content_id", record.getId()));
        iSpSopResourceService.remove(new QueryWrapper<SpSopResource>().eq("sop_content_id", record.getId()));
        iSpSopQualityControlService.remove(new QueryWrapper<SpSopQualityControl>().eq("sop_content_id", record.getId()));
        iSpSopSelfCheckService.remove(new QueryWrapper<SpSopSelfCheck>().eq("sop_content_id", record.getId()));
        iSpSopDocumentService.remove(new QueryWrapper<SpSopDocument>().eq("sop_content_id", record.getId()));
        return Result.success();
    }

    @PostMapping("/get-detail")
    @ResponseBody
    public Result getDetail(String id) {
        SpSopContent content = iSpSopContentService.getById(id);
        if (content == null) {
            return Result.error("SOP工艺内容不存在");
        }
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("content", content);
        result.put("workSteps", iSpSopWorkStepService.list(new QueryWrapper<SpSopWorkStep>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("processParams", iSpSopProcessParamService.list(new QueryWrapper<SpSopProcessParam>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("materials", iSpSopMaterialService.list(new QueryWrapper<SpSopMaterial>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("resources", iSpSopResourceService.list(new QueryWrapper<SpSopResource>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("qualityControls", iSpSopQualityControlService.list(new QueryWrapper<SpSopQualityControl>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("selfChecks", iSpSopSelfCheckService.list(new QueryWrapper<SpSopSelfCheck>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("sort_num")));
        result.put("documents", iSpSopDocumentService.list(new QueryWrapper<SpSopDocument>().eq("sop_content_id", id).eq("is_deleted", "0").orderByAsc("create_time")));
        return Result.success(result);
    }
}
