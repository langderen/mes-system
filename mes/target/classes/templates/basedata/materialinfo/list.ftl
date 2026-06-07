<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料信息定义</title>
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
                    <label class="layui-form-label">物料编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="codeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料类型</label>
                    <div class="layui-input-inline">
                        <select name="matTypeLike" lay-verify="">
                            <option value="">全部</option>
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
        <button class="layui-btn layui-btn-danger layui-btn-sm" lay-event="deleteBatch"><i class="layui-icon">&#xe640;</i>批量删除</button>
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增物料</button>
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

        function loadMatTypeDropdown() {
            spUtil.ajax({
                url: '${request.contextPath}/basedata/dict/list/material_type',
                async: false,
                type: 'GET',
                serializable: false,
                data: {},
                success: function (data) {
                    var $sel = $('select[name="matTypeLike"]');
                    $.each(data.data, function (index, item) {
                        $sel.append(new Option(item.name, item.value));
                    });
                }
            });
        }

        var tableIns = spTable.render({
            url: '${request.contextPath}/basedata/materialinfo/page',
            cols: [
                [{
                    type: 'checkbox'
                }, {
                    field: 'code', title: '物料编码', width: 140
                }, {
                    field: 'name', title: '物料名称', width: 150
                }, {
                    field: 'matType', title: '物料类型', width: 100
                }, {
                    field: 'matSource', title: '物料来源', width: 100
                }, {
                    field: 'unit', title: '单位', width: 80
                }, {
                    field: 'texture', title: '材质', width: 100
                }, {
                    field: 'model', title: '规格型号', width: 120
                }, {
                    field: 'size', title: '尺寸', width: 80
                }, {
                    field: 'leadTime', title: '提前期(天)', width: 100
                }, {
                    field: 'safetyStock', title: '安全库存', width: 100
                }, {
                    field: 'imageUrl', title: '图片', width: 80, templet: function (d) {
                        if (d.imageUrl) {
                            return '<img src="${request.contextPath}' + d.imageUrl + '" style="width:50px;height:50px;object-fit:cover;border-radius:4px;cursor:pointer;" onclick="layer.open({type:1,title:\'物料图片\',area:[\'400px\',\'400px\'],shadeClose:true,content:\'<img src=\\\'${request.contextPath}' + d.imageUrl + '\\\' style=\\\'width:100%;height:100%;object-fit:contain;\\\'/>\'});">';
                        }
                        return '<span style="color:#999;">无</span>';
                    }
                }, {
                    field: 'createUsername', title: '创建人', width: 100
                }, {
                    field: 'createTime', title: '创建时间', width: 170
                }, {
                    field: 'deleted', title: '状态', width: 90, templet: function (d) {
                        return spConfig.isDeletedDict[d.deleted];
                    }
                }, {
                    fixed: 'right', field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150
                }]
            ],
            done: function (res, curr, count) {
            }
        });

        $(function () {
            loadMatTypeDropdown();
            form.render();
        });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: { curr: 1 }
            });
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);

            if (obj.event === 'deleteBatch') {
                var data = checkStatus.data;
                if (data.length > 0) {
                    layer.confirm('确认要删除吗？', function (index) {
                        var ids = [];
                        $.each(data, function (i, item) { ids.push(item.id); });
                        spUtil.ajax({
                            url: '${request.contextPath}/basedata/materialinfo/delete',
                            type: 'POST',
                            showLoading: true,
                            serializable: false,
                            data: { id: ids.join(',') },
                            success: function () { tableIns.reload(); layer.close(index); }
                        });
                    });
                } else {
                    layer.msg("请先选择需要删除的数据！");
                }
            }

            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增物料',
                    area: ['750px', '600px'],
                    content: '${request.contextPath}/basedata/materialinfo/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;

            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑物料',
                    area: ['750px', '600px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/basedata/materialinfo/add-or-update-ui'
                });
            }

            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/basedata/materialinfo/delete',
                        async: false,
                        type: 'POST',
                        showLoading: true,
                        serializable: false,
                        data: { id: data.id },
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