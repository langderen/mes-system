<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>统计分析</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .stat-card {display:inline-block;background:#fff;border-radius:6px;padding:20px 30px;margin:10px 15px;text-align:center;
                    box-shadow:0 1px 4px rgba(0,0,0,.1);min-width:140px;}
        .stat-card .num {font-size:32px;font-weight:bold;color:#1890ff;}
        .stat-card .label {color:#999;margin-top:8px;}
        .stat-card.pass .num {color:#52c41a;}
        .stat-card.fail .num {color:#ff4d4f;}
        #js-chart-container {margin-top:30px;}
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">开始日期</label>
                    <div class="layui-input-inline">
                        <input type="text" id="js-start-date" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">结束日期</label>
                    <div class="layui-input-inline">
                        <input type="text" id="js-end-date" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i> 查询统计</a>
                </div>
            </div>
        </form>

        <div id="js-summary-cards"></div>

        <fieldset class="layui-elem-field" style="margin-top:20px;">
            <legend>缺陷分布分析</legend>
            <div id="js-defect-analysis"></div>
        </fieldset>

        <fieldset class="layui-elem-field" style="margin-top:20px;">
            <legend>合格率趋势</legend>
            <div id="js-trend-container"></div>
        </fieldset>
    </div>
</div>
<script>
    layui.use(['form', 'laydate'], function(){
        var form = layui.form, laydate = layui.laydate;
        laydate.render({elem: '#js-start-date'});
        laydate.render({elem: '#js-end-date'});

        form.on('submit(js-search-filter)', function(data){
            loadStatistics();
            return false;
        });

        function loadStatistics() {
            var params = {
                startDate: $('#js-start-date').val(),
                endDate: $('#js-end-date').val()
            };

            spUtil.ajax({
                url: '${request.contextPath}/quality/statistics/summary',
                data: params,
                success: function(res) {
                    var d = res.data;
                    var html = '<div class="stat-card"><div class="num">'+d.totalPlans+'</div><div class="label">调度计划总数</div></div>';
                    html += '<div class="stat-card"><div class="num">'+d.completedPlans+'</div><div class="label">已完成</div></div>';
                    html += '<div class="stat-card"><div class="num">'+d.executingPlans+'</div><div class="label">执行中</div></div>';
                    html += '<div class="stat-card"><div class="num">'+d.pendingPlans+'</div><div class="label">待执行</div></div>';
                    html += '<div class="stat-card"><div class="num">'+d.totalRecords+'</div><div class="label">检验记录总数</div></div>';
                    html += '<div class="stat-card pass"><div class="num">'+d.passCount+'</div><div class="label">合格数</div></div>';
                    html += '<div class="stat-card fail"><div class="num">'+d.failCount+'</div><div class="label">不合格数</div></div>';
                    html += '<div class="stat-card"><div class="num">'+d.passRate+'%</div><div class="label">合格率</div></div>';
                    $('#js-summary-cards').html(html);
                }
            });

            spUtil.ajax({
                url: '${request.contextPath}/quality/statistics/defect-analysis',
                data: params,
                success: function(res) {
                    var d = res.data;
                    var html = '<table class="layui-table"><thead><tr><th>缺陷类型</th><th>数量</th><th>缺陷等级</th><th>数量</th></tr></thead><tbody>';
                    var types = d.defectByType || {};
                    var severities = d.defectBySeverity || {};
                    var typeMap = {appearance:'外观',dimension:'尺寸',function:'功能',material:'材质'};
                    var sevMap = {critical:'致命',major:'严重',minor:'轻微'};
                    var typeKeys = Object.keys(types), sevKeys = Object.keys(severities);
                    var maxRows = Math.max(typeKeys.length, sevKeys.length);
                    for (var i = 0; i < maxRows; i++) {
                        var typeLabel = typeKeys[i] ? (typeMap[typeKeys[i]]||typeKeys[i]) : '';
                        var typeVal = typeKeys[i] ? types[typeKeys[i]] : '';
                        var sevLabel = sevKeys[i] ? (sevMap[sevKeys[i]]||sevKeys[i]) : '';
                        var sevVal = sevKeys[i] ? severities[sevKeys[i]] : '';
                        html += '<tr><td>'+typeLabel+'</td><td>'+typeVal+'</td><td>'+sevLabel+'</td><td>'+sevVal+'</td></tr>';
                    }
                    html += '</tbody></table>';
                    $('#js-defect-analysis').html(html);
                }
            });

            spUtil.ajax({
                url: '${request.contextPath}/quality/statistics/pass-rate-trend',
                data: params,
                success: function(res) {
                    var trend = res.data;
                    var html = '<table class="layui-table"><thead><tr><th>日期</th><th>检验总数</th><th>合格数</th><th>合格率</th></tr></thead><tbody>';
                    $.each(trend, function(i, point) {
                        html += '<tr><td>'+point.date+'</td><td>'+point.total+'</td><td>'+point.pass+'</td><td>'+point.rate+'%</td></tr>';
                    });
                    html += '</tbody></table>';
                    $('#js-trend-container').html(html);
                }
            });
        }

        loadStatistics();
    });
</script>
</body>
</html>