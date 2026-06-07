<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程模型设计</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .flow-model-layout { padding: 12px; }
        .flow-model-card { background: #fff; border: 1px solid #e6e6e6; border-radius: 4px; overflow: hidden; }
        .flow-model-header { padding: 12px 16px; border-bottom: 1px solid #eee; font-weight: 600; display: flex; align-items: center; justify-content: space-between; }
        .flow-model-body { padding: 12px; }
        .flow-model-tip { color: #999; font-size: 12px; }
    </style>
</head>
<body>
<div class="splayui-container flow-model-layout">
    <div class="flow-model-card">
        <div class="flow-model-header">
            <span>流程模型设计</span>
            <span class="flow-model-tip">选择流程后进入节点设计</span>
        </div>
        <div class="flow-model-body">
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
    <a class="layui-btn layui-btn-xs" lay-event="design">设计节点</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>

</script>

<script>
layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
    var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
    var tableIns = spTable.render({
        url: '${request.contextPath}/basedata/flow/page',
        cols: [[
            {field: 'flow', title: '流程编码'},
            {field: 'flowDesc', title: '流程名称'},
            {field: 'flowCategoryName', title: '流程分类'},
            {field: 'process', title: '当前节点'},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 200}
        ]]
    });

    form.on('submit(js-search-filter)', function (data) {
        tableIns.reload({
            where: data.field,
            page: {curr: 1}
        });
        return false;
    });
    table.on('toolbar(js-record-table-filter)', function (obj) {
        if (obj.event === 'add') {
            spLayer.open({
                title: '新增流程',
                area: ['960px', '720px'],
                content: '${request.contextPath}/basedata/flow/flowprocess/add-or-update-ui'
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
                content: '${request.contextPath}/basedata/flow/flowprocess/add-or-update-ui'
            });
        }
        if (obj.event === 'design') {
            spLayer.open({
                title: '流程节点设计',
                area: ['90%', '90%'],
                spWhere: {id: obj.data.id},
                content: '${request.contextPath}/basedata/flow/process/design-ui'
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
