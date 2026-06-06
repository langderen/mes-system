<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检资源管理</title>
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
                    <label class="layui-form-label">资源编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="resourceCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">资源名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="resourceName" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">资源类型</label>
                    <div class="layui-input-inline">
                        <select name="resourceType">
                            <option value="">全部</option>
                            <option value="equipment">设备</option>
                            <option value="tool">工具</option>
                            <option value="gauge">量具</option>
                            <option value="fixture">夹具</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="active">正常</option>
                            <option value="inactive">停用</option>
                            <option value="scrapped">报废</option>
                            <option value="maintenance">维修中</option>
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
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增质检资源</button>
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
            url: '${request.contextPath}/quality/resource/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'resourceCode', title: '资源编码', width: 130},
                {field: 'resourceName', title: '资源名称', width: 150},
                {field: 'resourceType', title: '资源类型', width: 100, templet: function(d){
                    var m = {equipment:'设备', tool:'工具', gauge:'量具', fixture:'夹具'};
                    return m[d.resourceType] || d.resourceType;
                }},
                {field: 'resourceSpec', title: '规格型号', width: 140},
                {field: 'manufacturer', title: '生产厂家', width: 140},
                {field: 'location', title: '存放位置', width: 120},
                {field: 'lastCalibrationDate', title: '上次校准日期', width: 120},
                {field: 'nextCalibrationDate', title: '下次校准日期', width: 120},
                {field: 'status', title: '状态', width: 100, templet: function(d){
                    var m = {active:'正常', inactive:'停用', scrapped:'报废', maintenance:'维修中'};
                    return m[d.status] || d.status;
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
                    title: '新增质检资源', area: ['800px', '550px'],
                    content: '${request.contextPath}/quality/resource/add-or-update-ui',
                    end: function(){ tableIns.reload(); }
                });
            }
        });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑质检资源', area: ['800px', '550px'],
                    content: '${request.contextPath}/quality/resource/add-or-update-ui',
                    spWhere: { id: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/resource/delete?id=' + data.id,
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
