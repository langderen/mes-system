<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检资源编辑</title>
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
                        <label class="layui-form-label sp-required">资源编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="resourceCode" lay-verify="required" autocomplete="off" class="layui-input" value="${result.resourceCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">资源名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="resourceName" lay-verify="required" autocomplete="off" class="layui-input" value="${result.resourceName!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">资源类型</label>
                        <div class="layui-input-inline">
                            <select name="resourceType" lay-verify="required">
                                <option value="">请选择</option>
                                <option value="equipment" ${((result.resourceType!'') == 'equipment')?string('selected','')}>设备</option>
                                <option value="tool" ${((result.resourceType!'') == 'tool')?string('selected','')}>工具</option>
                                <option value="gauge" ${((result.resourceType!'') == 'gauge')?string('selected','')}>量具</option>
                                <option value="fixture" ${((result.resourceType!'') == 'fixture')?string('selected','')}>夹具</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">规格型号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="resourceSpec" autocomplete="off" class="layui-input" value="${result.resourceSpec!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">生产厂家</label>
                        <div class="layui-input-inline">
                            <input type="text" name="manufacturer" autocomplete="off" class="layui-input" value="${result.manufacturer!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">存放位置</label>
                        <div class="layui-input-inline">
                            <input type="text" name="location" autocomplete="off" class="layui-input" value="${result.location!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">校准周期(天)</label>
                        <div class="layui-input-inline">
                            <input type="number" name="calibrationCycle" autocomplete="off" class="layui-input" value="${result.calibrationCycle!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">上次校准</label>
                        <div class="layui-input-inline">
                            <input type="text" name="lastCalibrationDate" id="js-last-cal" autocomplete="off" class="layui-input" value="${result.lastCalibrationDate!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">下次校准</label>
                        <div class="layui-input-inline">
                            <input type="text" name="nextCalibrationDate" id="js-next-cal" autocomplete="off" class="layui-input" value="${result.nextCalibrationDate!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="active" ${((result.status!'active') == 'active')?string('selected','')}>正常</option>
                                <option value="inactive" ${((result.status!'') == 'inactive')?string('selected','')}>停用</option>
                                <option value="scrapped" ${((result.status!'') == 'scrapped')?string('selected','')}>报废</option>
                                <option value="maintenance" ${((result.status!'') == 'maintenance')?string('selected','')}>维修中</option>
                            </select>
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
        laydate.render({elem: '#js-last-cal'});
        laydate.render({elem: '#js-next-cal'});
        form.on('submit(js-submit-filter)', function(data){
            spUtil.submitForm({
                url: '${request.contextPath}/quality/resource/save',
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
