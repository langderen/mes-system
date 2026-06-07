<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检调度编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="js-form-filter">
            <input type="hidden" name="id" value="${result.id!}">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">计划编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planCode" lay-verify="required" autocomplete="off" class="layui-input" value="${result.planCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计划名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planName" autocomplete="off" class="layui-input" value="${result.planName!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">质检定义</label>
                        <div class="layui-input-inline">
                            <select name="inspectionDefId" id="js-def-select" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">质量活动</label>
                        <div class="layui-input-inline">
                            <select name="activityId" id="js-activity-select">
                                <option value="">请选择(可选)</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">产品编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productCode" autocomplete="off" class="layui-input" value="${result.productCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">工单ID</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderId" autocomplete="off" class="layui-input" value="${result.orderId!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">计划数量</label>
                        <div class="layui-input-inline">
                            <input type="number" name="planQty" lay-verify="required" autocomplete="off" class="layui-input" value="${result.planQty!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="pending" ${((result.status!'pending') == 'pending')?string('selected','')}>待执行</option>
                                <option value="executing" ${((result.status!'') == 'executing')?string('selected','')}>执行中</option>
                                <option value="completed" ${((result.status!'') == 'completed')?string('selected','')}>已完成</option>
                                <option value="closed" ${((result.status!'') == 'closed')?string('selected','')}>已关闭</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">优先级</label>
                        <div class="layui-input-inline">
                            <select name="priority">
                                <option value="1" ${((result.priority!2) == 1)?string('selected','')}>高</option>
                                <option value="2" ${((result.priority!2) == 2)?string('selected','')}>中</option>
                                <option value="3" ${((result.priority!2) == 3)?string('selected','')}>低</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计划开始</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planStartTime" id="js-plan-start" autocomplete="off" class="layui-input" value="${result.planStartTime!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计划结束</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planEndTime" id="js-plan-end" autocomplete="off" class="layui-input" value="${result.planEndTime!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs12">
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block">
                            <textarea name="remark" class="layui-textarea">${result.remark!}</textarea>
                        </div>
                    </div>
                </div>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter" style="display:none;">保存</button>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'laydate'], function(){
        var form = layui.form, laydate = layui.laydate;
        laydate.render({elem: '#js-plan-start', type: 'datetime'});
        laydate.render({elem: '#js-plan-end', type: 'datetime'});

        spUtil.ajax({
            url: '${request.contextPath}/quality/plan/def-list',
            success: function(res){
                var sel = $('#js-def-select');
                $.each(res.data, function(i, item){
                    var selected = '${result.inspectionDefId!}' === item.id ? 'selected' : '';
                    sel.append('<option value="'+item.id+'" '+selected+'>'+item.defCode+' - '+item.defName+'</option>');
                });
                form.render('select');
            }
        });
        spUtil.ajax({
            url: '${request.contextPath}/quality/plan/activity-list',
            success: function(res){
                var sel = $('#js-activity-select');
                $.each(res.data, function(i, item){
                    var selected = '${result.activityId!}' === item.id ? 'selected' : '';
                    sel.append('<option value="'+item.id+'" '+selected+'>'+item.activityCode+' - '+item.activityName+'</option>');
                });
                form.render('select');
            }
        });

        form.on('submit(js-submit-filter)', function(data){
            spUtil.submitForm({
                url: '${request.contextPath}/quality/plan/save',
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
