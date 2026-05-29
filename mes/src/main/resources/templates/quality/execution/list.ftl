<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检执行管理</title>
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
                    <label class="layui-form-label">记录编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="recordCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">检验结果</label>
                    <div class="layui-input-inline">
                        <select name="result">
                            <option value="">全部</option>
                            <option value="pass">合格</option>
                            <option value="fail">不合格</option>
                            <option value="rework">返工</option>
                            <option value="scrap">报废</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">检验日期</label>
                    <div class="layui-input-inline">
                        <input type="text" name="inspectionTime" id="js-inspection-time" autocomplete="off" class="layui-input">
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
    <a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable', 'laydate'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable, laydate = layui.laydate;
        laydate.render({elem: '#js-inspection-time'});

        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/execution/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'recordCode', title: '记录编码', width: 160},
                {field: 'defName', title: '质检定义', width: 140},
                {field: 'inspectorName', title: '检验员', width: 100},
                {field: 'inspectionTime', title: '检验时间', width: 160},
                {field: 'result', title: '检验结果', width: 100, templet: function(d){
                    var m = {pass:'<span class="layui-badge layui-bg-green">合格</span>',
                             fail:'<span class="layui-badge layui-bg-red">不合格</span>',
                             rework:'<span class="layui-badge layui-bg-orange">返工</span>',
                             scrap:'<span class="layui-badge layui-bg-black">报废</span>'};
                    return m[d.result]||d.result;
                }},
                {field: 'defectType', title: '缺陷类型', width: 100},
                {field: 'defectSeverity', title: '缺陷等级', width: 100, templet: function(d){
                    var m = {critical:'致命',major:'严重',minor:'轻微'};
                    return m[d.defectSeverity]||d.defectSeverity||'-';
                }},
                {field: 'defectQty', title: '缺陷数量', width: 90},
                {field: 'handleMethod', title: '处理方式', width: 100, templet: function(d){
                    var m = {rework:'返工',scrap:'报废',concession:'让步接收',return:'退货'};
                    return m[d.handleMethod]||d.handleMethod||'-';
                }},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 150, fixed: 'right'}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'detail') {
                spLayer.open({
                    title: '质检数据 - ' + data.recordCode,
                    area: ['900px', '550px'],
                    content: '${request.contextPath}/quality/data/list-ui?recordId=' + data.id
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/execution/delete?id=' + data.id,
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