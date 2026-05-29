<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程定义管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">流程编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="flowLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">流程分类</label>
                    <div class="layui-input-inline">
                        <input type="text" name="flowType" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="js-search-filter">搜索</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="category">流程分类管理</button>
        <button class="layui-btn layui-btn-sm" lay-event="add">新增流程</button>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
</script>

<script>
layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
    var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
    var tableIns = spTable.render({
        url: '${request.contextPath}/basedata/flow/page',
        toolbar: '#js-record-table-toolbar-top',
        cols: [[
            {type: 'checkbox'},
            {field: 'flow', title: '流程编码'},
            {field: 'flowDesc', title: '流程名称'},
            {field: 'flowCategoryName', title: '分类'},
            {field: 'process', title: '流程节点'},
            {field: 'buttonCode', title: '按钮编码'},
            {field: 'bindType', title: '绑定类型'},
            {field: 'scriptContent', title: '脚本内容'},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 260}
        ]]
    });

    form.on('submit(js-search-filter)', function (data) {
        tableIns.reload({ where: data.field, page: { curr: 1 } });
        return false;
    });

    table.on('toolbar(js-record-table-filter)', function (obj) {
        if (obj.event === 'add') {
            spLayer.open({
                title: '新增流程',
                area: ['960px', '720px'],
                content: '${request.contextPath}/basedata/flow/add-or-update-ui'
            });
        }
        if (obj.event === 'category') {
            spLayer.open({
                title: '流程分类管理',
                area: ['900px', '640px'],
                content: '${request.contextPath}/technology/flow/category/list-ui'
            });
        }
    });

    table.on('tool(js-record-table-filter)', function (obj) {
        var data = obj.data;
        if (obj.event === 'edit') {
            spLayer.open({
                title: '编辑流程',
                area: ['960px', '720px'],
                spWhere: {id: data.id},
                content: '${request.contextPath}/basedata/flow/add-or-update-ui'
            });
        }
        if (obj.event === 'delete') {
            layer.confirm('确认删除该流程吗？', function (index) {
                layer.close(index);
                $.post('${request.contextPath}/basedata/flow/delete', {id: data.id}, function (result) {
                    if (result.code === 0) {
                        tableIns.reload();
                    } else {
                        layer.msg(result.msg || '删除失败');
                    }
                });
            });
        }
    });
});
</script>
</body>
</html>
