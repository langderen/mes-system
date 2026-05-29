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
        <div class="layui-col-md5">
            <div class="layui-card">
                <div class="layui-card-header">当前流程</div>
                <div class="layui-card-body">
                    <div class="layui-form">
                        <div class="layui-form-item">
                            <label class="layui-form-label">流程编码</label>
                            <div class="layui-input-block" style="padding-top:8px;">${flow.flow!}</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">流程名称</label>
                            <div class="layui-input-block" style="padding-top:8px;">${flow.flowDesc!}</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">分类</label>
                            <div class="layui-input-block" style="padding-top:8px;">${flow.flowCategoryName!}</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">节点</label>
                            <div class="layui-input-block" style="padding-top:8px;">${flow.process!}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-col-md7">
            <div class="layui-card">
                <div class="layui-card-header">节点说明</div>
                <div class="layui-card-body">
                    <p>这里沿用现有流程与工序关系管理能力，后续可在此扩展节点脚本和按钮绑定。</p>
                    <div class="layui-btn-container">
                        <button class="layui-btn layui-btn-normal" id="js-open-list">返回模型列表</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
layui.use(['layer', 'spLayer'], function () {
    var layer = layui.layer, spLayer = layui.spLayer;
    $('#js-open-list').on('click', function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    });
});
</script>
</body>
</html>
