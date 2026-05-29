<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程节点设计</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container" style="padding: 16px;">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md6">
            <div class="layui-card">
                <div class="layui-card-header">当前流程</div>
                <div class="layui-card-body">
                    <div>流程编码: ${flow.flow!}</div>
                    <div>流程名称: ${flow.flowDesc!}</div>
                    <div>分类: ${flow.flowCategoryName!}</div>
                    <div>节点: ${flow.process!}</div>
                </div>
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="layui-card">
                <div class="layui-card-header">节点说明</div>
                <div class="layui-card-body">
                    <p>这里沿用现有流程与工序关系管理能力，后续可在此扩展节点脚本和按钮绑定。</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
layui.use(['layer', 'spLayer'], function () {
    var layer = layui.layer, spLayer = layui.spLayer;
});
</script>
</body>
</html>
