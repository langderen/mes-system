<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>执行检验</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <fieldset class="layui-elem-field">
            <legend>任务信息</legend>
            <div class="layui-field-box">
                <table class="layui-table">
                    <tr><td width="100">任务编码:</td><td>${task.taskCode!}</td><td width="100">质检定义:</td><td>${inspectionDef.defName!}</td></tr>
                    <tr><td>检验项目:</td><td>${inspectionDef.inspectionItem!}</td><td>标准值:</td><td>${inspectionDef.standardValue!} <#if inspectionDef.unit??>${inspectionDef.unit}</#if></td></tr>
                    <tr><td>公差范围:</td><td>${inspectionDef.toleranceLower!} ~ ${inspectionDef.toleranceUpper!} <#if inspectionDef.unit??>${inspectionDef.unit}</#if></td><td>分配数量:</td><td>${task.assignedQty!}</td></tr>
                </table>
            </div>
        </fieldset>

        <form class="layui-form splayui-form" lay-filter="js-form-filter" style="margin-top:20px;">
            <input type="hidden" name="taskId" value="${task.id!}">
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">检验结果</label>
                <div class="layui-input-inline">
                    <select name="result" lay-verify="required" id="js-result-select">
                        <option value="">请选择</option>
                        <option value="pass">合格</option>
                        <option value="fail">不合格</option>
                        <option value="rework">返工</option>
                        <option value="scrap">报废</option>
                    </select>
                </div>
            </div>
            <div id="js-fail-fields" style="display:none;">
                <div class="layui-form-item">
                    <label class="layui-form-label">实测值</label>
                    <div class="layui-input-inline">
                        <input type="text" name="measuredValue" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">缺陷类型</label>
                    <div class="layui-input-inline">
                        <select name="defectType">
                            <option value="">请选择</option>
                            <option value="appearance">外观</option>
                            <option value="dimension">尺寸</option>
                            <option value="function">功能</option>
                            <option value="material">材质</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">缺陷等级</label>
                    <div class="layui-input-inline">
                        <select name="defectSeverity">
                            <option value="">请选择</option>
                            <option value="critical">致命</option>
                            <option value="major">严重</option>
                            <option value="minor">轻微</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">缺陷数量</label>
                    <div class="layui-input-inline">
                        <input type="number" name="defectQty" autocomplete="off" class="layui-input" value="1">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">缺陷描述</label>
                    <div class="layui-input-block">
                        <textarea name="defectDesc" class="layui-textarea"></textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">处理方式</label>
                    <div class="layui-input-inline">
                        <select name="handleMethod">
                            <option value="">请选择</option>
                            <option value="rework">返工</option>
                            <option value="scrap">报废</option>
                            <option value="concession">让步接收</option>
                            <option value="return">退货</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item" style="text-align:center;margin-top:20px;">
                <button class="layui-btn" lay-submit lay-filter="js-submit-filter">提交检验结果</button>
                <button type="button" class="layui-btn layui-btn-primary" onclick="spLayer.closeAll();">取消</button>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function(){
        var form = layui.form;

        form.on('select(js-result-select)', function(data){
            if (data.value === 'fail' || data.value === 'rework' || data.value === 'scrap') {
                $('#js-fail-fields').show();
            } else {
                $('#js-fail-fields').hide();
            }
        });

        form.on('submit(js-submit-filter)', function(data){
            spUtil.ajax({
                url: '${request.contextPath}/quality/execution/execute',
                type: 'POST', contentType: 'application/json',
                data: JSON.stringify(data.field),
                success: function(){ spLayer.closeAll(); }
            });
            return false;
        });
    });
</script>
</body>
</html>