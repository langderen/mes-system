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
<div class="splayui-container">
    <div class="splayui-main">
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script>
layui.use(['table', 'spLayer', 'spTable'], function () {
    var table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
    var tableIns = spTable.render({
        url: '${request.contextPath}/basedata/flow/page',
        cols: [[
            {field: 'flow', title: '流程编码'},
            {field: 'flowDesc', title: '流程名称'},
            {field: 'flowCategoryName', title: '分类'},
            {field: 'process', title: '节点'},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 120}
        ]]
    });

    table.on('tool(js-record-table-filter)', function (obj) {
        if (obj.event === 'edit') {
            spLayer.open({
                title: '流程节点设计',
                area: ['900px', '640px'],
                spWhere: {id: obj.data.id},
                content: '${request.contextPath}/basedata/flow/process/design-ui'
            });
        }
    });
});
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit">设计</a>
</script>
</body>
</html>
