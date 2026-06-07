<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检定义管理</title>
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
                    <label class="layui-form-label">定义编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="defCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">定义名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="defName" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">检验类型</label>
                    <div class="layui-input-inline">
                        <select name="inspectionType">
                            <option value="">全部</option>
                            <option value="iqc">来料检验</option>
                            <option value="ipqc">过程检验</option>
                            <option value="oqc">出货检验</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="active">启用</option>
                            <option value="inactive">停用</option>
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
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增质检定义</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/def/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'defCode', title: '定义编码', width: 130},
                {field: 'defName', title: '定义名称', width: 160},
                {field: 'inspectionType', title: '检验类型', width: 100, templet: function(d){
                    return {iqc:'来料检验',ipqc:'过程检验',oqc:'出货检验'}[d.inspectionType]||d.inspectionType;
                }},
                {field: 'productCode', title: '产品编码', width: 120},
                {field: 'inspectionItem', title: '检验项目', width: 130},
                {field: 'inspectionMethod', title: '检验方法', width: 100, templet: function(d){
                    return {visual:'目视',measure:'测量',test:'试验',sample:'抽样'}[d.inspectionMethod]||d.inspectionMethod;
                }},
                {field: 'standardValue', title: '标准值', width: 100},
                {field: 'unit', title: '单位', width: 70},
                {field: 'isCritical', title: '关键项', width: 80, templet: function(d){
                    return d.isCritical == '1' ? '<span class="layui-badge layui-bg-red">是</span>' : '否';
                }},
                {field: 'status', title: '状态', width: 80, templet: function(d){
                    return d.status === 'active' ? '<span class="layui-badge layui-bg-green">启用</span>' : '停用';
                }},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 150, fixed: 'right'}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('toolbar(js-record-table-filter)', function(obj){
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增质检定义', area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/def/add-or-update-ui',
                    end: function(){ tableIns.reload(); }
                });
            }
        });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑质检定义', area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/def/add-or-update-ui',
                    spWhere: { id: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/def/delete?id=' + data.id,
                        type: 'POST',
                        success: function(){ tableIns.reload(); }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
