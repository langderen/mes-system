package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.technology.entity.SpFlowForm;
import com.wangziyang.mes.technology.service.ISpFlowFormService;
import com.wangziyang.mes.technology.service.ISpFlowScriptEngine;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.SimpleBindings;
import java.util.HashMap;
import java.util.Map;

@Service
public class SpFlowScriptEngineImpl implements ISpFlowScriptEngine {

    private static final Logger log = LoggerFactory.getLogger(SpFlowScriptEngineImpl.class);

    @Autowired
    private ISpFlowFormService iSpFlowFormService;

    @Override
    public Object executeScript(String script, Map<String, Object> context) {
        if (StringUtils.isBlank(script)) {
            return null;
        }
        try {
            ScriptEngineManager manager = new ScriptEngineManager();
            ScriptEngine engine = manager.getEngineByName("JavaScript");
            SimpleBindings bindings = new SimpleBindings();
            if (context != null) {
                bindings.putAll(context);
            }
            return engine.eval(script, bindings);
        } catch (Exception e) {
            log.error("流程脚本执行失败: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public void onFlowInit(String flowId, Map<String, Object> bizData) {
        SpFlowForm form = getFlowFormByFlowId(flowId);
        if (form == null || StringUtils.isBlank(form.getInitScript())) {
            return;
        }
        Map<String, Object> context = buildContext(flowId, "init", null, null);
        context.put("bizData", bizData);
        executeScript(form.getInitScript(), context);
    }

    @Override
    public void onFlowApprove(String flowId, Map<String, Object> bizData) {
        SpFlowForm form = getFlowFormByFlowId(flowId);
        if (form == null || StringUtils.isBlank(form.getApproveScript())) {
            return;
        }
        Map<String, Object> context = buildContext(flowId, "approve", null, null);
        context.put("bizData", bizData);
        executeScript(form.getApproveScript(), context);
    }

    @Override
    public void onFlowReject(String flowId, Map<String, Object> bizData) {
        SpFlowForm form = getFlowFormByFlowId(flowId);
        if (form == null || StringUtils.isBlank(form.getRejectScript())) {
            return;
        }
        Map<String, Object> context = buildContext(flowId, "reject", null, null);
        context.put("bizData", bizData);
        executeScript(form.getRejectScript(), context);
    }

    @Override
    public void onFlowEnd(String flowId, Map<String, Object> bizData) {
        SpFlowForm form = getFlowFormByFlowId(flowId);
        if (form == null || StringUtils.isBlank(form.getEndScript())) {
            return;
        }
        Map<String, Object> context = buildContext(flowId, "end", null, null);
        context.put("bizData", bizData);
        executeScript(form.getEndScript(), context);
    }

    @Override
    public SpFlowForm getFlowFormByFlowId(String flowId) {
        if (StringUtils.isBlank(flowId)) {
            return null;
        }
        QueryWrapper<SpFlowForm> qw = new QueryWrapper<>();
        qw.eq("flow_id", flowId);
        qw.eq("is_deleted", "0");
        qw.last("LIMIT 1");
        return iSpFlowFormService.getOne(qw);
    }

    private Map<String, Object> buildContext(String flowId, String event, String approver, String comment) {
        Map<String, Object> ctx = new HashMap<>();
        ctx.put("flowId", flowId);
        ctx.put("event", event);
        ctx.put("approver", approver);
        ctx.put("comment", comment);
        return ctx;
    }
}
