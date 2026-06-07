<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检跟踪追溯</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .trace-node {background:#fafafa;border:1px solid #e8e8e8;border-radius:4px;padding:15px;margin-bottom:12px;}
        .trace-node .node-title {font-size:15px;font-weight:bold;color:#1890ff;margin-bottom:10px;}
        .trace-node .node-info {line-height:2;}
        .trace-node .node-info span {display:inline-block;margin-right:30px;}
        .trace-node .data-table {margin-top:12px;}
        .result-pass {color:#52c41a;font-weight:bold;}
        .result-fail {color:#ff4d4f;font-weight:bold;}
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">记录编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="js-record-id" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">任务编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="js-task-id" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">产品编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="js-product-code" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i> 追溯查询</a>
                </div>
            </div>
        </form>
        <div id="js-trace-result"></div>
    </div>
</div>
<script>
    layui.use(['form'], function(){
        var form = layui.form;

        form.on('submit(js-search-filter)', function(){
            spUtil.ajax({
                url: '${request.contextPath}/quality/trace/trace',
                data: {
                    recordId: $('#js-record-id').val(),
                    taskId: $('#js-task-id').val(),
                    productCode: $('#js-product-code').val()
                },
                success: function(res){
                    var traces = res.data;
                    var html = '';
                    if (!traces || traces.length === 0) {
                        html = '<div class="layui-none">未找到相关追溯记录</div>';
                    } else {
                        $.each(traces, function(i, t) {
                            var resultClass = t.result === 'pass' ? 'result-pass' : 'result-fail';
                            var resultMap = {pass:'合格',fail:'不合格',rework:'返工',scrap:'报废'};

                            html += '<div class="trace-node">';
                            html += '<div class="node-title">' + (t.defName||'') + ' - ' + (t.inspectionItem||'') + '</div>';
                            html += '<div class="node-info">';
                            html += '<span>记录编码: <b>'+t.recordCode+'</b></span>';
                            html += '<span>检验时间: '+ (t.inspectionTime||'') +'</span>';
                            html += '<span>检验结果: <b class="'+resultClass+'">'+ (resultMap[t.result]||t.result) +'</b></span>';
                            html += '<span>检验员: '+ (t.inspectorName||'') +'</span>';
                            html += '</div>';

                            if (t.productCode || t.productName) {
                                html += '<div class="node-info">';
                                html += '<span>产品编码: '+ (t.productCode||'') +'</span>';
                                html += '<span>产品名称: '+ (t.productName||'') +'</span>';
                                html += '<span>检验类型: '+ (t.inspectionType||'') +'</span>';
                                html += '</div>';
                            }

                            if (t.taskCode) {
                                html += '<div class="node-info">';
                                html += '<span>任务编码: '+t.taskCode+'</span>';
                                html += '<span>分配数量: '+t.assignedQty+'</span>';
                                html += '<span>分配时间: '+ (t.assignTime||'') +'</span>';
                                html += '</div>';
                            }

                            if (t.planCode) {
                                html += '<div class="node-info">';
                                html += '<span>计划编码: '+t.planCode+'</span>';
                                html += '<span>计划名称: '+ (t.planName||'') +'</span>';
                                html += '<span>关联工单: '+ (t.orderId||'') +'</span>';
                                html += '</div>';
                            }

                            if (t.activityName) {
                                html += '<div class="node-info">';
                                html += '<span>质量活动: '+t.activityName+'</span>';
                                html += '<span>活动类型: '+t.activityType+'</span>';
                                html += '</div>';
                            }

                            if (t.defectType || t.defectDesc) {
                                var defectMap = {appearance:'外观',dimension:'尺寸',function:'功能',material:'材质'};
                                var sevMap = {critical:'致命',major:'严重',minor:'轻微'};
                                var handleMap = {rework:'返工',scrap:'报废',concession:'让步接收',return:'退货'};
                                html += '<div class="node-info" style="background:#fff2f0;padding:8px;border-radius:4px;">';
                                html += '<span>缺陷类型: <b>'+ (defectMap[t.defectType]||t.defectType||'') +'</b></span>';
                                html += '<span>缺陷等级: <b>'+ (sevMap[t.defectSeverity]||t.defectSeverity||'') +'</b></span>';
                                html += '<span>实测值: '+ (t.measuredValue||'') +'</span>';
                                html += '<span>处理方式: '+ (handleMap[t.handleMethod]||t.handleMethod||'') +'</span>';
                                html += '</div>';
                                html += '<div style="margin-top:5px;"><span>缺陷描述: '+ (t.defectDesc||'') +'</span></div>';
                            }

                            if (t.dataItems && t.dataItems.length > 0) {
                                html += '<div class="data-table"><table class="layui-table"><thead><tr>' +
                                    '<th>参数名称</th><th>实测值</th><th>标准值</th><th>下限</th><th>上限</th><th>单位</th><th>合格</th></tr></thead><tbody>';
                                $.each(t.dataItems, function(j, d) {
                                    html += '<tr><td>'+d.parameterName+'</td><td>'+d.measuredValue+'</td><td>'+d.standardValue+'</td>' +
                                        '<td>'+d.minValue+'</td><td>'+d.maxValue+'</td><td>'+d.unit+'</td>' +
                                        '<td>'+(d.isPass=='1'?'<span class="result-pass">是</span>':'<span class="result-fail">否</span>')+'</td></tr>';
                                });
                                html += '</tbody></table></div>';
                            }

                            html += '</div>';
                        });
                    }
                    $('#js-trace-result').html(html);
                }
            });
            return false;
        });
    });
</script>
</body>
</html>