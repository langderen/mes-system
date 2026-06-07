<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序信息定义</title>
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
                    <label class="layui-form-label">工序编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">工序描述</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operDescLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">工序类型</label>
                    <div class="layui-input-inline">
                        <select name="operType">
                            <option value="">全部</option>
                            <option value="加工">加工</option>
                            <option value="装配">装配</option>
                            <option value="检验">检验</option>
                            <option value="包装">包装</option>
                            <option value="搬运">搬运</option>
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

        var tableIns = spTable.render({
            url: '${request.contextPath}/productdata/oper/page',
            cols: [[
                {type: 'radio'},
                {field: 'oper', title: '工序编码', width: 110},
                {field: 'operDesc', title: '工序描述', width: 130},
                {field: 'operType', title: '工序类型', width: 90},
                {field: 'standardTime', title: '标准工时(分)', width: 110},
                {field: 'equipmentType', title: '所需设备类型', width: 130},
                {field: 'isKeyOper', title: '关键工序', width: 90, templet: function (d) {
                    return d.isKeyOper === '1' ? '<span style="color:#dc3545">是</span>' : '否';
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
                    title: '添加工序',
                    area: ['60%', '75%'],
                    content: '${request.contextPath}/productdata/oper/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑工序',
                    area: ['60%', '75%'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/productdata/oper/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/oper/delete',
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
