<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>库房管理</title>
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
                    <label class="layui-form-label">库房编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="codeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">库房名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">库房类型</label>
                    <div class="layui-input-inline">
                        <select name="typeLike">
                            <option value="">全部</option>
                            <option value="原料仓">原料仓</option>
                            <option value="半成品仓">半成品仓</option>
                            <option value="成品仓">成品仓</option>
                            <option value="线边仓">线边仓</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search layuiadmin-button-btn"></i></a>
                </div>
            </div>
        </form>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增库房</button>
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
            url: '${request.contextPath}/warehouse/warehouse/page',
            cols: [
                [{
                    type: 'checkbox'
                }, {
                    field: 'code', title: '库房编码', width: 130
                }, {
                    field: 'name', title: '库房名称', width: 150
                }, {
                    field: 'type', title: '库房类型', width: 120
                }, {
                    field: 'address', title: '库房地址', width: 180
                }, {
                    field: 'status', title: '库房状态', width: 100, templet: function (d) {
                        var dict = { '0': '正常', '1': '停用' };
                        return dict[d.status] || d.status;
                    }
                }, {
                    field: 'descr', title: '描述', width: 180
                }, {
                    field: 'createUsername', title: '创建人', width: 100
                }, {
                    field: 'createTime', title: '创建时间', width: 170
                }, {
                    fixed: 'right', field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 220
                }]
            ],
            done: function (res, curr, count) {
            }
        });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: { curr: 1 }
            });
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增库房',
                    area: ['900px', '650px'],
                    content: '${request.contextPath}/warehouse/warehouse/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑库房',
                    area: ['900px', '650px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/warehouse/warehouse/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除该库房吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/warehouse/warehouse/delete',
                        type: 'POST',
                        data: { id: data.id },
                        success: function (result) {
                            if (result.code === 0) {
                                tableIns.reload();
                                layer.msg('删除成功');
                            }
                        }
                    });
                    layer.close(index);
                });
            }
        });
    });
</script>
</body>
</html>