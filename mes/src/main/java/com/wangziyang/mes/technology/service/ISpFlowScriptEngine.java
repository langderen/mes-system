package com.wangziyang.mes.technology.service;

import com.wangziyang.mes.technology.entity.SpFlowForm;

import java.util.Map;

public interface ISpFlowScriptEngine {

    Object executeScript(String script, Map<String, Object> context);

    void onFlowInit(String flowId, Map<String, Object> bizData);

    void onFlowApprove(String flowId, Map<String, Object> bizData);

    void onFlowReject(String flowId, Map<String, Object> bizData);

    void onFlowEnd(String flowId, Map<String, Object> bizData);

    SpFlowForm getFlowFormByFlowId(String flowId);
}
