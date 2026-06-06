<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质量活动编辑</title>
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
                        <label class="layui-form-label sp-required">活动编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="activityCode" lay-verify="required" autocomplete="off" class="layui-input" value="${result.activityCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">活动名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="activityName" lay-verify="required" autocomplete="off" class="layui-input" value="${result.activityName!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">活动类型</label>
                        <div class="layui-input-inline">
                            <select name="activityType" lay-verify="required">
                                <option value="">请选择</option>
                                <option value="iqc" ${((result.activityType!'') == 'iqc')?string('selected','')}>来料检验(IQC)</option>
                                <option value="ipqc" ${((result.activityType!'') == 'ipqc')?string('selected','')}>过程检验(IPQC)</option>
                                <option value="oqc" ${((result.activityType!'') == 'oqc')?string('selected','')}>出货检验(OQC)</option>
                                <option value="spc" ${((result.activityType!'') == 'spc')?string('selected','')}>统计过程控制(SPC)</option>
                                <option value="msa" ${((result.activityType!'') == 'msa')?string('selected','')}>测量系统分析(MSA)</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">触发方式</label>
                        <div class="layui-input-inline">
                            <select name="triggerType">
                                <option value="manual" ${((result.triggerType!'manual') == 'manual')?string('selected','')}>手动</option>
                                <option value="schedule" ${((result.triggerType!'') == 'schedule')?string('selected','')}>定时</option>
                                <option value="event" ${((result.triggerType!'') == 'event')?string('selected','')}>事件</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">产品编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productCode" autocomplete="off" class="layui-input" value="${result.productCode!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">BOM ID</label>
                        <div class="layui-input-inline">
                            <input type="text" name="bomId" autocomplete="off" class="layui-input" value="${result.bomId!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">工单ID</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderId" autocomplete="off" class="layui-input" value="${result.orderId!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="draft" ${((result.status!'draft') == 'draft')?string('selected','')}>草稿</option>
                                <option value="active" ${((result.status!'') == 'active')?string('selected','')}>进行中</option>
                                <option value="paused" ${((result.status!'') == 'paused')?string('selected','')}>暂停</option>
                                <option value="completed" ${((result.status!'') == 'completed')?string('selected','')}>完成</option>
                                <option value="cancelled" ${((result.status!'') == 'cancelled')?string('selected','')}>取消</option>
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
                        <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline">
                            <input type="text" name="startTime" id="js-start-time" autocomplete="off" class="layui-input" value="${result.startTime!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline">
                            <input type="text" name="endTime" id="js-end-time" autocomplete="off" class="layui-input" value="${result.endTime!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs12">
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block">
                            <textarea name="remark" class="layui-textarea" placeholder="请输入备注">${result.remark!}</textarea>
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
        laydate.render({elem: '#js-start-time', type: 'datetime'});
        laydate.render({elem: '#js-end-time', type: 'datetime'});

        form.on('submit(js-submit-filter)', function(data){
            spUtil.ajax({
                url: '${request.contextPath}/quality/activity/save',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data.field),
                showLoading: true,
                success: function(){
                    var frameIndex = parent.layer.getFrameIndex(window.name);
                    parent.layer.msg('保存成功', {icon: 1, time: 800}, function(){
                        parent.layer.close(frameIndex);
                    });
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
