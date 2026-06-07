<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>字典编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="js-form-filter">
            <div class="layui-form-item">
                <label for="js-name" class="layui-form-label sp-required">标签名</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dict.name}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="js-value" class="layui-form-label sp-required">标签值</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-value" name="value" lay-verify="required" autocomplete="off" class="layui-input" value="${dict.value}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="js-type" class="layui-form-label sp-required">类别</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-type" name="type" lay-verify="required" autocomplete="off" class="layui-input" value="${dict.type}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="js-descr" class="layui-form-label sp-required">描述</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-descr" name="descr" lay-verify="required" autocomplete="off" class="layui-input" value="${dict.descr}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="js-sort-num" class="layui-form-label sp-required">排序</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-sort-num" name="sortNum" lay-verify="required|number" autocomplete="off" class="layui-input" value="${dict.sortNum}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="js-deleted" class="layui-form-label sp-required"><span class="sp-red">*</span>状态</label>
                <div class="layui-input-block" id="js-deleted">
                    <input type="radio" name="deleted" value="0" title="正常" checked>
                    <input type="radio" name="deleted" value="1" title="已删除">
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <input type="hidden" name="id" id="js-id" value=""/>
                <button id="js-add-btn" class="layui-btn" lay-filter="add" lay-submit="">确定</button>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        form.on('submit(add)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/dict/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
