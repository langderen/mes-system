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
        .flow-tabs { display: flex; border-bottom: 2px solid #e6e6e6; margin-bottom: 16px; }
        .flow-tab { padding: 10px 24px; cursor: pointer; font-size: 14px; color: #666; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.2s; }
        .flow-tab:hover { color: #2f54eb; }
        .flow-tab.active { color: #2f54eb; border-bottom-color: #2f54eb; font-weight: 600; }
        .flow-panel { display: none; }
        .flow-panel.active { display: block; }
        .form-row { display: flex; flex-wrap: wrap; gap: 12px; }
        .form-row .layui-form-item { flex: 1; min-width: 240px; }
        .script-area { font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.6; }
        .option-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
        .option-grid .layui-form-item { margin-bottom: 0; }
        .step-badge { display: inline-block; width: 22px; height: 22px; line-height: 22px; text-align: center; border-radius: 50%; background: #2f54eb; color: #fff; font-size: 12px; margin-right: 6px; }
        .step-title { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 12px; }
        .step-section { margin-bottom: 20px; padding: 16px; background: #f8f9fc; border-radius: 6px; border: 1px solid #eef0f5; }
    </style>
</head>
<body>
<div class="splayui-container flow-layout">
    <div class="flow-card">
        <div class="flow-card-header">
            <span>流程定义管理</span>
            <span class="flow-tip">完成流程模型定义后，为流程建立流程表单</span>
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
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">新增流程</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="form">流程表单</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
</script>

<script>
layui.use(['form', 'table', 'spLayer', 'spTable', 'layer'], function () {
    var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable, layer = layui.layer;
    var tableIns = spTable.render({
        url: '${request.contextPath}/basedata/flow/page',
        toolbar: '#js-record-table-toolbar-top',
        cols: [[
            {type: 'checkbox'},
            {field: 'flow', title: '流程编码', width: 120},
            {field: 'flowDesc', title: '流程名称', width: 140},
            {field: 'flowCategoryName', title: '分类', width: 100},
            {field: 'process', title: '流程节点'},
            {field: 'buttonCode', title: '按钮编码', width: 120},
            {field: 'bindType', title: '绑定类型', width: 90},
            {field: 'scriptContent', title: '脚本内容', width: 160},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 300}
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
        if (obj.event === 'form') {
            spLayer.open({
                title: '流程表单 - ' + (data.flowDesc || data.flow),
                area: ['960px', '90%'],
                content: '${request.contextPath}/basedata/flow/form/add-or-update-ui?flowId=' + data.id
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
