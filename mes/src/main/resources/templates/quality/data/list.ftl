<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检数据收集</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>
<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>录入检测数据</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['table', 'spLayer', 'spTable'], function () {
        var table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;

        var recordId = '${recordId!}';
        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/data/page',
            where: {recordId: recordId},
            cols: [[
                {type: 'checkbox'},
                {field: 'parameterCode', title: '参数编码', width: 120},
                {field: 'parameterName', title: '参数名称', width: 130},
                {field: 'measuredValue', title: '实测值', width: 100},
                {field: 'standardValue', title: '标准值', width: 100},
                {field: 'minValue', title: '下限', width: 80},
                {field: 'maxValue', title: '上限', width: 80},
                {field: 'unit', title: '单位', width: 70},
                {field: 'isPass', title: '合格', width: 70, templet: function(d){
                    return d.isPass == '1' ? '<span class="layui-badge layui-bg-green">是</span>' :
                           d.isPass == '0' ? '<span class="layui-badge layui-bg-red">否</span>' : '-';
                }},
                {field: 'collectTime', title: '采集时间', width: 160},
                {field: 'collectMethod', title: '采集方式', width: 90},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 80, fixed: 'right'}
            ]]
        });

        table.on('toolbar(js-record-table-filter)', function(obj){
            if (obj.event === 'add') {
                spLayer.open({
                    title: '录入检测数据',
                    area: ['700px', '450px'],
                    content: ['<div style="padding:20px;">' +
                        '<div class="layui-form-item"><label class="layui-form-label">参数名称</label><div class="layui-input-inline"><input type="text" id="js-param-name" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">参数编码</label><div class="layui-input-inline"><input type="text" id="js-param-code" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">实测值</label><div class="layui-input-inline"><input type="text" id="js-measured" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">标准值</label><div class="layui-input-inline"><input type="text" id="js-standard" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">下限</label><div class="layui-input-inline"><input type="text" id="js-min" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">上限</label><div class="layui-input-inline"><input type="text" id="js-max" class="layui-input"></div></div>' +
                        '<div class="layui-form-item"><label class="layui-form-label">单位</label><div class="layui-input-inline"><input type="text" id="js-unit" class="layui-input"></div></div>' +
                        '<div style="text-align:center;margin-top:20px;"><button class="layui-btn" onclick="submitData()">保存</button></div>' +
                        '</div>'].join('')
                });
            }
        });

        window.submitData = function() {
            spUtil.ajax({
                url: '${request.contextPath}/quality/data/collect',
                type: 'POST', contentType: 'application/json',
                data: JSON.stringify({
                    recordId: recordId,
                    dataList: [{
                        parameterCode: $('#js-param-code').val(),
                        parameterName: $('#js-param-name').val(),
                        measuredValue: $('#js-measured').val(),
                        standardValue: $('#js-standard').val(),
                        minValue: $('#js-min').val(),
                        maxValue: $('#js-max').val(),
                        unit: $('#js-unit').val()
                    }]
                }),
                success: function(){ spLayer.closeAll(); tableIns.reload(); }
            });
        };

        table.on('tool(js-record-table-filter)', function(obj){
            if (obj.event === 'delete') {
                spLayer.confirm('确认删除?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/data/delete?id=' + obj.data.id,
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