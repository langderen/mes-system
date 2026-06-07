<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>产品BOM管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">BOM编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bomCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">BOM名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="bomNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">BOM类型</label>
                    <div class="layui-input-inline">
                        <select name="bomType">
                            <option value="">全部</option>
                            <option value="EBOM">EBOM</option>
                            <option value="MBOM">MBOM</option>
                            <option value="SBOM">SBOM</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <@shiro.hasPermission name="user:add">
            <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>添加</button>
        </@shiro.hasPermission>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        var stateDict = {'create': '创建', 'pass': '审核通过', 'reject': '驳回'};

        var tableIns = spTable.render({
            url: '${request.contextPath}/productdata/productbom/page',
            cols: [[
                {type: 'radio'},
                {field: 'bomCode', title: 'BOM编码', width: 120},
                {field: 'bomName', title: 'BOM名称', width: 140},
                {field: 'productPartCode', title: '产品编码', width: 110},
                {field: 'productPartName', title: '产品名称', width: 120},
                {field: 'version', title: '版本', width: 70},
                {field: 'bomType', title: 'BOM类型', width: 90},
                {field: 'state', title: '状态', width: 100, templet: function (d) {
                    var label = stateDict[d.state] || d.state;
                    var color = d.state === 'pass' ? '#28a745' : (d.state === 'reject' ? '#dc3545' : '#f0ad4e');
                    return '<span style="color:' + color + '">' + label + '</span>';
                }},
                {field: 'descr', title: '描述', width: 150},
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150}
            ]]
        });

        form.render();

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '添加产品BOM',
                    area: ['85%', '90%'],
                    content: '${request.contextPath}/productdata/productbom/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑产品BOM',
                    area: ['85%', '90%'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/productdata/productbom/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/productbom/delete',
                        type: 'POST',
                        serializable: false,
                        data: {id: data.id},
                        success: function () {
                            tableIns.reload();
                            layer.close(index);
                        }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
