<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检任务管理</title>
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
                    <label class="layui-form-label">任务编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="taskCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="assigned">已分配</option>
                            <option value="started">已开始</option>
                            <option value="completed">已完成</option>
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
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="execute">执行检验</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/task/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'taskCode', title: '任务编码', width: 160},
                {field: 'planId', title: '调度计划ID', width: 180},
                {field: 'assignedQty', title: '分配数量', width: 100},
                {field: 'completedQty', title: '已完成', width: 90},
                {field: 'passQty', title: '合格数', width: 90},
                {field: 'failQty', title: '不合格数', width: 90},
                {field: 'status', title: '状态', width: 100, templet: function(d){
                    var m = {assigned:'已分配',started:'已开始',completed:'已完成'};
                    return m[d.status]||d.status;
                }},
                {field: 'assignTime', title: '分配时间', width: 160},
                {field: 'endTime', title: '完成时间', width: 160},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 180, fixed: 'right'}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'execute') {
                if (data.status === 'completed') {
                    spLayer.msg('该任务已完成');
                    return;
                }
                spLayer.open({
                    title: '执行检验 - ' + data.taskCode,
                    area: ['900px', '600px'],
                    content: '${request.contextPath}/quality/execution/execute-ui',
                    spWhere: { taskId: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/task/delete?id=' + data.id,
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
