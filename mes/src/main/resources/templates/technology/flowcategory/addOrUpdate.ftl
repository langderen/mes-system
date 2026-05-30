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
                <input type="text" name="categoryCode" lay-verify="required" lay-reqtext="请输入分类编码" class="layui-input" value="${result.categoryCode!}" placeholder="请输入分类编码">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">分类名称</label>
            <div class="layui-input-inline">
                <input type="text" name="categoryName" lay-verify="required" lay-reqtext="请输入分类名称" class="layui-input" value="${result.categoryName!}" placeholder="请输入分类名称">
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
        <div class="layui-form-item" style="display:none;">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </div>
    </form>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var form = layui.form, layer = layui.layer;
    form.render();

    //监听提交
    form.on('submit(js-submit-filter)', function (data) {
        spUtil.submitForm({
            url: "${request.contextPath}/technology/flow/category/add-or-update",
            data: data.field
        });

        return false;
    });
});
</script>
</body>
</html>
