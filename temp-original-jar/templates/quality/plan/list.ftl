<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检调度管理</title>
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
                    <label class="layui-form-label">计划编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="planCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="pending">待执行</option>
                            <option value="executing">执行中</option>
                            <option value="completed">已完成</option>
                            <option value="closed">已关闭</option>
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
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增调度计划</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="assign">分配</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/plan/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'planCode', title: '计划编码', width: 140},
                {field: 'planName', title: '计划名称', width: 160},
                {field: 'productCode', title: '产品编码', width: 120},
                {field: 'planQty', title: '计划数量', width: 100},
                {field: 'completedQty', title: '已完成', width: 90},
                {field: 'passQty', title: '合格数', width: 90},
                {field: 'failQty', title: '不合格数', width: 90},
                {field: 'priority', title: '优先级', width: 80, templet: function(d){
                    return d.priority == 1 ? '<span class="layui-badge layui-bg-red">高</span>' :
                           d.priority == 3 ? '<span class="layui-badge">低</span>' : '<span class="layui-badge layui-bg-orange">中</span>';
                }},
                {field: 'status', title: '状态', width: 100, templet: function(d){
                    var m = {pending:'待执行',executing:'执行中',completed:'已完成',closed:'已关闭'};
                    return m[d.status]||d.status;
                }},
                {field: 'planStartTime', title: '计划开始', width: 160},
                {field: 'planEndTime', title: '计划结束', width: 160},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 250, fixed: 'right'}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('toolbar(js-record-table-filter)', function(obj){
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增调度计划', area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/plan/add-or-update-ui',
                    end: function(){ tableIns.reload(); }
                });
            }
        });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑调度计划', area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/plan/add-or-update-ui',
                    spWhere: { id: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'execute') {
                spLayer.confirm('确认开始执行此调度计划?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/plan/execute?id=' + data.id,
                        type: 'POST',
                        success: function(){ tableIns.reload(); }
                    });
                });
            } else if (obj.event === 'assign') {
                spLayer.open({
                    title: '质检分配 - ' + data.planCode,
                    area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/task/assign-ui',
                    spWhere: { planId: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/plan/delete?id=' + data.id,
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
