<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SOP工艺内容编制</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .step-bar { display: flex; align-items: center; justify-content: center; padding: 20px 0; margin-bottom: 20px; }
        .step-item { text-align: center; cursor: pointer; }
        .step-num { width: 32px; height: 32px; line-height: 32px; border-radius: 50%; background: #e6e6e6; color: #999; margin: 0 auto 8px; font-weight: 600; }
        .step-item.active .step-num { background: #1E9FFF; color: #fff; }
        .step-item.completed .step-num { background: #5FB878; color: #fff; }
        .step-label { font-size: 13px; color: #666; }
        .step-item.active .step-label { color: #1E9FFF; font-weight: 600; }
        .step-line { width: 80px; height: 2px; background: #e6e6e6; margin: 0 10px; margin-bottom: 28px; }
        .step-line.completed { background: #5FB878; }
        .step-panel { display: none; }
        .step-panel.active { display: block; }
        .btn-bar { text-align: center; padding: 20px 0; border-top: 1px solid #eee; margin-top: 20px; }
        .btn-bar .layui-btn { margin: 0 10px; min-width: 100px; }
        .sub-table-wrap { margin-top: 15px; }
        .sub-table-wrap .layui-table { margin: 0; }
    </style>
</head>
<body>
<div class="splayui-container" style="padding: 20px;">
    <div class="step-bar">
        <div class="step-item active" data-step="1">
            <div class="step-num">1</div>
            <div class="step-label">基本信息</div>
        </div>
        <div class="step-line"></div>
        <div class="step-item" data-step="2">
            <div class="step-num">2</div>
            <div class="step-label">作业步骤</div>
        </div>
        <div class="step-line"></div>
        <div class="step-item" data-step="3">
            <div class="step-num">3</div>
            <div class="step-label">工艺参数</div>
        </div>
        <div class="step-line"></div>
        <div class="step-item" data-step="4">
            <div class="step-num">4</div>
            <div class="step-label">物料资源</div>
        </div>
        <div class="step-line"></div>
        <div class="step-item" data-step="5">
            <div class="step-num">5</div>
            <div class="step-label">质量控制</div>
        </div>
    </div>

    <form id="js-form" class="layui-form" lay-filter="js-form">
        <input type="hidden" name="id" value="${(result.id)!''}">

        <div class="step-panel active" data-panel="1">
            <div class="layui-form-item">
                <label class="layui-form-label"><span style="color:red;">*</span>SOP编号</label>
                <div class="layui-input-block">
                    <input type="text" name="sopCode" value="${(result.sopCode)!''}" lay-verify="required" placeholder="请输入SOP编号" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"><span style="color:red;">*</span>SOP名称</label>
                <div class="layui-input-block">
                    <input type="text" name="sopName" value="${(result.sopName)!''}" lay-verify="required" placeholder="请输入SOP名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">产品编码</label>
                <div class="layui-input-block">
                    <input type="text" name="productCode" value="${(result.productCode)!''}" placeholder="请输入产品编码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">产品名称</label>
                <div class="layui-input-block">
                    <input type="text" name="productName" value="${(result.productName)!''}" placeholder="请输入产品名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">工序编码</label>
                <div class="layui-input-block">
                    <input type="text" name="operCode" value="${(result.operCode)!''}" placeholder="请输入工序编码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">工序名称</label>
                <div class="layui-input-block">
                    <input type="text" name="operName" value="${(result.operName)!''}" placeholder="请输入工序名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">内容概述</label>
                <div class="layui-input-block">
                    <textarea name="contentOverview" placeholder="请输入工序内容概述" class="layui-textarea">${(result.contentOverview)!''}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">标准产能</label>
                <div class="layui-input-inline">
                    <input type="number" name="standardCapacity" value="${(result.standardCapacity)!''}" placeholder="件/小时" class="layui-input">
                </div>
                <label class="layui-form-label">人员配置</label>
                <div class="layui-input-inline">
                    <input type="number" name="personnelRequirement" value="${(result.personnelRequirement)!''}" placeholder="人" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">劳保用品</label>
                <div class="layui-input-block">
                    <input type="text" name="laborProtection" value="${(result.laborProtection)!''}" placeholder="请输入劳保用品要求" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea name="remark" placeholder="请输入备注信息" class="layui-textarea">${(result.remark)!''}</textarea>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="2">
            <div class="sub-table-wrap">
                <table class="layui-table" id="js-work-step-table">
                    <thead>
                        <tr>
                            <th>步骤序号</th>
                            <th>操作说明</th>
                            <th>技术要求</th>
                            <th>排序号</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="js-work-step-tbody">
                        <#if workSteps??>
                            <#list workSteps as step>
                                <tr data-index="${step_index}">
                                    <td><input type="number" name="workStep_stepNo_${step_index}" value="${(step.stepNo)!''}" class="layui-input"></td>
                                    <td><textarea name="workStep_operationDesc_${step_index}" class="layui-textarea">${(step.operationDesc)!''}</textarea></td>
                                    <td><textarea name="workStep_technicalRequirement_${step_index}" class="layui-textarea">${(step.technicalRequirement)!''}</textarea></td>
                                    <td><input type="number" name="workStep_sortNum_${step_index}" value="${(step.sortNum)!''}" class="layui-input"></td>
                                    <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="workStep">删除</button></td>
                                </tr>
                            </#list>
                        </#if>
                    </tbody>
                </table>
                <button type="button" class="layui-btn layui-btn-sm" id="js-add-work-step">新增步骤</button>
            </div>
        </div>

        <div class="step-panel" data-panel="3">
            <div class="sub-table-wrap">
                <table class="layui-table" id="js-process-param-table">
                    <thead>
                        <tr>
                            <th>参数名称</th>
                            <th>参数值</th>
                            <th>单位</th>
                            <th>排序号</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="js-process-param-tbody">
                        <#if processParams??>
                            <#list processParams as param>
                                <tr data-index="${param_index}">
                                    <td><input type="text" name="processParam_paramName_${param_index}" value="${(param.paramName)!''}" class="layui-input"></td>
                                    <td><input type="text" name="processParam_paramValue_${param_index}" value="${(param.paramValue)!''}" class="layui-input"></td>
                                    <td><input type="text" name="processParam_paramUnit_${param_index}" value="${(param.paramUnit)!''}" class="layui-input"></td>
                                    <td><input type="number" name="processParam_sortNum_${param_index}" value="${(param.sortNum)!''}" class="layui-input"></td>
                                    <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="processParam">删除</button></td>
                                </tr>
                            </#list>
                        </#if>
                    </tbody>
                </table>
                <button type="button" class="layui-btn layui-btn-sm" id="js-add-process-param">新增参数</button>
            </div>
        </div>

        <div class="step-panel" data-panel="4">
            <div class="layui-tab">
                <ul class="layui-tab-title">
                    <li class="layui-this">物料清单</li>
                    <li>设备工装</li>
                </ul>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <table class="layui-table" id="js-material-table">
                            <thead>
                                <tr>
                                    <th>物料编码</th>
                                    <th>物料名称</th>
                                    <th>规格型号</th>
                                    <th>数量</th>
                                    <th>单位</th>
                                    <th>排序号</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="js-material-tbody">
                                <#if materials??>
                                    <#list materials as mat>
                                        <tr data-index="${mat_index}">
                                            <td><input type="text" name="material_materialCode_${mat_index}" value="${(mat.materialCode)!''}" class="layui-input"></td>
                                            <td><input type="text" name="material_materialName_${mat_index}" value="${(mat.materialName)!''}" class="layui-input"></td>
                                            <td><input type="text" name="material_specification_${mat_index}" value="${(mat.specification)!''}" class="layui-input"></td>
                                            <td><input type="number" name="material_quantity_${mat_index}" value="${(mat.quantity)!''}" class="layui-input"></td>
                                            <td><input type="text" name="material_unit_${mat_index}" value="${(mat.unit)!''}" class="layui-input"></td>
                                            <td><input type="number" name="material_sortNum_${mat_index}" value="${(mat.sortNum)!''}" class="layui-input"></td>
                                            <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="material">删除</button></td>
                                        </tr>
                                    </#list>
                                </#if>
                            </tbody>
                        </table>
                        <button type="button" class="layui-btn layui-btn-sm" id="js-add-material">新增物料</button>
                    </div>
                    <div class="layui-tab-item">
                        <table class="layui-table" id="js-resource-table">
                            <thead>
                                <tr>
                                    <th>资源类型</th>
                                    <th>资源编码</th>
                                    <th>资源名称</th>
                                    <th>型号</th>
                                    <th>设定条件</th>
                                    <th>排序号</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="js-resource-tbody">
                                <#if resources??>
                                    <#list resources as res>
                                        <tr data-index="${res_index}">
                                            <td>
                                                <select name="resource_resourceType_${res_index}">
                                                    <option value="equipment" <#if res.resourceType=='equipment'>selected</#if>>设备</option>
                                                    <option value="tool" <#if res.resourceType=='tool'>selected</#if>>工装工具</option>
                                                    <option value="fixture" <#if res.resourceType=='fixture'>selected</#if>>夹具</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="resource_resourceCode_${res_index}" value="${(res.resourceCode)!''}" class="layui-input"></td>
                                            <td><input type="text" name="resource_resourceName_${res_index}" value="${(res.resourceName)!''}" class="layui-input"></td>
                                            <td><input type="text" name="resource_model_${res_index}" value="${(res.model)!''}" class="layui-input"></td>
                                            <td><input type="text" name="resource_settingCondition_${res_index}" value="${(res.settingCondition)!''}" class="layui-input"></td>
                                            <td><input type="number" name="resource_sortNum_${res_index}" value="${(res.sortNum)!''}" class="layui-input"></td>
                                            <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="resource">删除</button></td>
                                        </tr>
                                    </#list>
                                </#if>
                            </tbody>
                        </table>
                        <button type="button" class="layui-btn layui-btn-sm" id="js-add-resource">新增资源</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="5">
            <div class="layui-tab">
                <ul class="layui-tab-title">
                    <li class="layui-this">质量控制点</li>
                    <li>自检项目</li>
                </ul>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <table class="layui-table" id="js-quality-control-table">
                            <thead>
                                <tr>
                                    <th>检查内容</th>
                                    <th>判定标准</th>
                                    <th>不良品处理</th>
                                    <th>排序号</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="js-quality-control-tbody">
                                <#if qualityControls??>
                                    <#list qualityControls as qc>
                                        <tr data-index="${qc_index}">
                                            <td><textarea name="qualityControl_checkContent_${qc_index}" class="layui-textarea">${(qc.checkContent)!''}</textarea></td>
                                            <td><textarea name="qualityControl_checkStandard_${qc_index}" class="layui-textarea">${(qc.checkStandard)!''}</textarea></td>
                                            <td>
                                                <select name="qualityControl_defectHandling_${qc_index}">
                                                    <option value="">请选择</option>
                                                    <option value="cut" <#if qc.defectHandling=='cut'>selected</#if>>截出</option>
                                                    <option value="rework" <#if qc.defectHandling=='rework'>selected</#if>>返工</option>
                                                    <option value="scrap" <#if qc.defectHandling=='scrap'>selected</#if>>报废</option>
                                                </select>
                                            </td>
                                            <td><input type="number" name="qualityControl_sortNum_${qc_index}" value="${(qc.sortNum)!''}" class="layui-input"></td>
                                            <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="qualityControl">删除</button></td>
                                        </tr>
                                    </#list>
                                </#if>
                            </tbody>
                        </table>
                        <button type="button" class="layui-btn layui-btn-sm" id="js-add-quality-control">新增质控点</button>
                    </div>
                    <div class="layui-tab-item">
                        <table class="layui-table" id="js-self-check-table">
                            <thead>
                                <tr>
                                    <th>检查内容</th>
                                    <th>判定标准</th>
                                    <th>排序号</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="js-self-check-tbody">
                                <#if selfChecks??>
                                    <#list selfChecks as sc>
                                        <tr data-index="${sc_index}">
                                            <td><textarea name="selfCheck_checkContent_${sc_index}" class="layui-textarea">${(sc.checkContent)!''}</textarea></td>
                                            <td><textarea name="selfCheck_checkStandard_${sc_index}" class="layui-textarea">${(sc.checkStandard)!''}</textarea></td>
                                            <td><input type="number" name="selfCheck_sortNum_${sc_index}" value="${(sc.sortNum)!''}" class="layui-input"></td>
                                            <td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="selfCheck">删除</button></td>
                                        </tr>
                                    </#list>
                                </#if>
                            </tbody>
                        </table>
                        <button type="button" class="layui-btn layui-btn-sm" id="js-add-self-check">新增自检项</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div class="btn-bar">
        <button type="button" class="layui-btn layui-btn-primary" id="js-prev" style="display:none;">上一步</button>
        <button type="button" class="layui-btn" id="js-next">下一步</button>
        <button type="button" class="layui-btn layui-btn-normal" id="js-submit" style="display:none;">确定</button>
    </div>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var form = layui.form, layer = layui.layer, $ = layui.$;
    var currentStep = 1;
    var totalSteps = 5;
    var workStepCount = <#if workSteps??>${workSteps?size}<#else>0</#if>;
    var processParamCount = <#if processParams??>${processParams?size}<#else>0</#if>;
    var materialCount = <#if materials??>${materials?size}<#else>0</#if>;
    var resourceCount = <#if resources??>${resources?size}<#else>0</#if>;
    var qualityControlCount = <#if qualityControls??>${qualityControls?size}<#else>0</#if>;
    var selfCheckCount = <#if selfChecks??>${selfChecks?size}<#else>0</#if>;

    function updateStepUI() {
        $('.step-item').each(function() {
            var step = $(this).data('step');
            $(this).removeClass('active completed');
            if (step === currentStep) {
                $(this).addClass('active');
            } else if (step < currentStep) {
                $(this).addClass('completed');
            }
        });
        $('.step-line').each(function(i) {
            $(this).toggleClass('completed', (i + 1) < currentStep);
        });
        $('.step-panel').removeClass('active');
        $('.step-panel[data-panel="' + currentStep + '"]').addClass('active');
        $('#js-prev').toggle(currentStep > 1);
        $('#js-next').toggle(currentStep < totalSteps);
        $('#js-submit').toggle(currentStep === totalSteps);
    }

    $('#js-next').click(function() {
        if (currentStep === 1) {
            var sopCode = $('input[name="sopCode"]').val();
            var sopName = $('input[name="sopName"]').val();
            if (!sopCode || !sopName) {
                layer.msg('请填写SOP编号和名称', {icon: 2});
                return;
            }
        }
        currentStep++;
        updateStepUI();
    });

    $('#js-prev').click(function() {
        if (currentStep > 1) {
            currentStep--;
            updateStepUI();
        }
    });

    function collectSubTableData(prefix, count) {
        var data = [];
        for (var i = 0; i < count; i++) {
            var row = {};
            $('#js-' + prefix.toLowerCase().replace(/([A-Z])/g, '-$1').toLowerCase() + '-tbody tr[data-index="' + i + '"] input, #js-' + prefix.toLowerCase().replace(/([A-Z])/g, '-$1').toLowerCase() + '-tbody tr[data-index="' + i + '"] textarea, #js-' + prefix.toLowerCase().replace(/([A-Z])/g, '-$1').toLowerCase() + '-tbody tr[data-index="' + i + '"] select').each(function() {
                var name = $(this).attr('name');
                var key = name.replace(prefix + '_', '').replace(/_\d+$/, '');
                row[key] = $(this).val();
            });
            if (Object.keys(row).length > 0) {
                data.push(row);
            }
        }
        return data;
    }

    $('#js-submit').click(function() {
        var formData = form.val('js-form');
        var workSteps = collectSubTableData('workStep', workStepCount);
        var processParams = collectSubTableData('processParam', processParamCount);
        var materials = collectSubTableData('material', materialCount);
        var resources = collectSubTableData('resource', resourceCount);
        var qualityControls = collectSubTableData('qualityControl', qualityControlCount);
        var selfChecks = collectSubTableData('selfCheck', selfCheckCount);

        var loadIndex = layer.load(2, {shade: [0.3, '#000']});
        $('#js-submit').prop('disabled', true);

        $.ajax({
            url: '${request.contextPath}/technology/sop/content/save-detail',
            type: 'POST',
            data: {
                ...formData,
                workStepsJson: JSON.stringify(workSteps),
                processParamsJson: JSON.stringify(processParams),
                materialsJson: JSON.stringify(materials),
                resourcesJson: JSON.stringify(resources),
                qualityControlsJson: JSON.stringify(qualityControls),
                selfChecksJson: JSON.stringify(selfChecks),
                documentsJson: JSON.stringify([])
            },
            success: function(result) {
                layer.close(loadIndex);
                $('#js-submit').prop('disabled', false);
                if (result.code === 0) {
                    layer.msg('保存成功', {icon: 1}, function() {
                        window.spChildFrameResult = result;
                    });
                } else {
                    layer.msg(result.msg || '保存失败', {icon: 2});
                }
            },
            error: function() {
                layer.close(loadIndex);
                $('#js-submit').prop('disabled', false);
                layer.msg('网络异常', {icon: 2});
            }
        });
    });

    $(document).on('click', '.js-delete-row', function() {
        var tableType = $(this).data('table');
        var $tr = $(this).closest('tr');
        var index = $tr.data('index');
        $tr.remove();
        if (tableType === 'workStep') workStepCount--;
        else if (tableType === 'processParam') processParamCount--;
        else if (tableType === 'material') materialCount--;
        else if (tableType === 'resource') resourceCount--;
        else if (tableType === 'qualityControl') qualityControlCount--;
        else if (tableType === 'selfCheck') selfCheckCount--;
    });

    function addTableRow(tbodyId, prefix, countVar) {
        var idx = eval(countVar);
        var html = '<tr data-index="' + idx + '">';
        if (prefix === 'workStep') {
            html += '<td><input type="number" name="workStep_stepNo_' + idx + '" class="layui-input"></td>';
            html += '<td><textarea name="workStep_operationDesc_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><textarea name="workStep_technicalRequirement_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><input type="number" name="workStep_sortNum_' + idx + '" class="layui-input"></td>';
        } else if (prefix === 'processParam') {
            html += '<td><input type="text" name="processParam_paramName_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="processParam_paramValue_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="processParam_paramUnit_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="number" name="processParam_sortNum_' + idx + '" class="layui-input"></td>';
        } else if (prefix === 'material') {
            html += '<td><input type="text" name="material_materialCode_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="material_materialName_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="material_specification_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="number" name="material_quantity_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="material_unit_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="number" name="material_sortNum_' + idx + '" class="layui-input"></td>';
        } else if (prefix === 'resource') {
            html += '<td><select name="resource_resourceType_' + idx + '"><option value="equipment">设备</option><option value="tool">工装工具</option><option value="fixture">夹具</option></select></td>';
            html += '<td><input type="text" name="resource_resourceCode_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="resource_resourceName_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="resource_model_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="text" name="resource_settingCondition_' + idx + '" class="layui-input"></td>';
            html += '<td><input type="number" name="resource_sortNum_' + idx + '" class="layui-input"></td>';
        } else if (prefix === 'qualityControl') {
            html += '<td><textarea name="qualityControl_checkContent_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><textarea name="qualityControl_checkStandard_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><select name="qualityControl_defectHandling_' + idx + '"><option value="">请选择</option><option value="cut">截出</option><option value="rework">返工</option><option value="scrap">报废</option></select></td>';
            html += '<td><input type="number" name="qualityControl_sortNum_' + idx + '" class="layui-input"></td>';
        } else if (prefix === 'selfCheck') {
            html += '<td><textarea name="selfCheck_checkContent_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><textarea name="selfCheck_checkStandard_' + idx + '" class="layui-textarea"></textarea></td>';
            html += '<td><input type="number" name="selfCheck_sortNum_' + idx + '" class="layui-input"></td>';
        }
        html += '<td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs js-delete-row" data-table="' + prefix + '">删除</button></td>';
        html += '</tr>';
        $('#' + tbodyId).append(html);
        eval(countVar + '++');
        form.render();
    }

    $('#js-add-work-step').click(function() { addTableRow('js-work-step-tbody', 'workStep', 'workStepCount'); });
    $('#js-add-process-param').click(function() { addTableRow('js-process-param-tbody', 'processParam', 'processParamCount'); });
    $('#js-add-material').click(function() { addTableRow('js-material-tbody', 'material', 'materialCount'); });
    $('#js-add-resource').click(function() { addTableRow('js-resource-tbody', 'resource', 'resourceCount'); });
    $('#js-add-quality-control').click(function() { addTableRow('js-quality-control-tbody', 'qualityControl', 'qualityControlCount'); });
    $('#js-add-self-check').click(function() { addTableRow('js-self-check-tbody', 'selfCheck', 'selfCheckCount'); });

    updateStepUI();
    form.render();
});
</script>
</body>
</html>
