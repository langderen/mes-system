<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件定义</title>
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
                    <label class="layui-form-label">零部件编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="partCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">零部件名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="partNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">类型</label>
                    <div class="layui-input-inline">
                        <select name="partType">
                            <option value="">全部</option>
                            <option value="原料">原料</option>
                            <option value="半成品">半成品</option>
                            <option value="成品">成品</option>
                            <option value="辅料">辅料</option>
                            <option value="包装">包装</option>
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

        var partTypeDict = {'原料': '原料', '半成品': '半成品', '成品': '成品', '辅料': '辅料', '包装': '包装'};

        var tableIns = spTable.render({
            url: '${request.contextPath}/productdata/part/page',
            cols: [[
                {type: 'radio'},
                {field: 'partCode', title: '零部件编码', width: 120},
                {field: 'partName', title: '零部件名称', width: 140},
                {field: 'partType', title: '类型', width: 90},
                {field: 'spec', title: '规格型号', width: 120},
                {field: 'unit', title: '单位', width: 70},
                {field: 'material', title: '材质', width: 90},
                {field: 'weight', title: '重量(kg)', width: 90},
                {field: 'drawingNo', title: '图号', width: 100},
                {field: 'version', title: '版本', width: 70},
                {field: 'status', title: '状态', width: 80, templet: function (d) {
                    return d.status === '0' ? '<span style="color:#28a745">正常</span>' : '<span style="color:#dc3545">停用</span>';
                }},
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
                    title: '添加零部件',
                    area: ['70%', '85%'],
                    content: '${request.contextPath}/productdata/part/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑零部件',
                    area: ['70%', '85%'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/productdata/part/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/part/delete',
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
