<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程分类</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container" style="padding: 16px;">
    <form class="layui-form">
        <input type="hidden" name="id" value="${result.id!}">
        <div class="layui-form-item">
            <label class="layui-form-label">分类编码</label>
            <div class="layui-input-inline">
                <input type="text" name="categoryCode" class="layui-input" value="${result.categoryCode!}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">分类名称</label>
            <div class="layui-input-inline">
                <input type="text" name="categoryName" class="layui-input" value="${result.categoryName!}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">分类描述</label>
            <div class="layui-input-inline">
                <input type="text" name="categoryDesc" class="layui-input" value="${result.categoryDesc!}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">排序</label>
            <div class="layui-input-inline">
                <input type="text" name="sortNum" class="layui-input" value="${result.sortNum!1}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-inline">
                <input type="text" name="state" class="layui-input" value="${result.state!'0'}">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </div>
    </form>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var form = layui.form, layer = layui.layer;
    form.on('submit(js-submit-filter)', function (data) {
        $.post('${request.contextPath}/technology/flow/category/add-or-update', data.field, function (result) {
            if (result.code === 0) {
                var index = parent.layer.getFrameIndex(window.name);
                parent.location.reload();
                parent.layer.close(index);
            } else {
                layer.msg(result.msg || '保存失败');
            }
        });
        return false;
    });
});
</script>
</body>
</html>
