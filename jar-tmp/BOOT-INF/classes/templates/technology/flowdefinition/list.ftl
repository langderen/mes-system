<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程定义管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .flow-layout { padding: 12px; }
        .flow-card { background: #fff; border: 1px solid #e6e6e6; border-radius: 6px; overflow: hidden; margin-bottom: 12px; }
        .flow-card-header { padding: 12px 16px; border-bottom: 1px solid #eee; font-weight: 600; display: flex; align-items: center; justify-content: space-between; background: #fafafa; }
        .flow-card-body { padding: 12px; }
        .flow-tip { color: #999; font-size: 12px; }
    </style>
</head>
<body>
<div class="splayui-container flow-layout">
    <div class="flow-card">
        <div class="flow-card-header">
            <span>流程定义管理</span>
            <span class="flow-tip">管理流程定义的基本信息</span>
        </div>
        <div class="flow-card-body">
            <form id="js-search-form" class="layui-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">流程编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="flowLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">流程名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="flowDescLike" autocomplete="off" class="layui-input">
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
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">新增流程</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
</script>

<script>
layui.use(['form', 'table', 'spLayer', 'spTable', 'layer'], function () {
    var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable, layer = layui.layer;
    var tableIns = spTable.render({
        url: '${request.contextPath}/technology/flow/definition/page',
        toolbar: '#js-record-table-toolbar-top',
        cols: [[
            {type: 'checkbox'},
            {field: 'flowCode', title: '流程编码', width: 140},
            {field: 'flowName', title: '流程名称', width: 160},
            {field: 'flowCategoryName', title: '分类', width: 120},
            {field: 'flowType', title: '类型', width: 100},
            {field: 'version', title: '版本', width: 80},
            {field: 'bindType', title: '绑定类型', width: 100},
            {field: 'buttonCode', title: '按钮编码', width: 120},
            {field: 'state', title: '状态', width: 80},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 180}
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
                content: '${request.contextPath}/technology/flow/definition/add-or-update-ui'
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
                content: '${request.contextPath}/technology/flow/definition/add-or-update-ui'
            });
        }
        if (obj.event === 'delete') {
            layer.confirm('确认删除该流程定义吗？', function (index) {
                layer.close(index);
                $.post('${request.contextPath}/technology/flow/definition/delete', {id: data.id}, function (result) {
                    if (result.code === 0) {
                        layer.msg('删除成功', {icon: 1});
                        tableIns.reload();
                    } else {
                        layer.msg(result.msg || '删除失败', {icon: 2});
                    }
                });
            });
        }
    });
});
</script>
</body>
</html>
