<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .form-layout { padding: 16px; }
        .step-bar { display: flex; align-items: center; margin-bottom: 24px; padding: 0 20px; }
        .step-item { display: flex; align-items: center; flex: 1; }
        .step-num { width: 32px; height: 32px; line-height: 32px; text-align: center; border-radius: 50%; font-size: 14px; font-weight: 600; color: #999; background: #f0f0f0; transition: all 0.3s; }
        .step-item.active .step-num { color: #fff; background: #2f54eb; }
        .step-item.done .step-num { color: #fff; background: #52c41a; }
        .step-label { margin-left: 8px; font-size: 13px; color: #999; transition: all 0.3s; }
        .step-item.active .step-label { color: #2f54eb; font-weight: 600; }
        .step-item.done .step-label { color: #52c41a; }
        .step-line { flex: 1; height: 2px; background: #e6e6e6; margin: 0 12px; }
        .step-item.done + .step-line { background: #52c41a; }
        .step-panel { display: none; }
        .step-panel.active { display: block; }
        .section-card { background: #f8f9fc; border: 1px solid #eef0f5; border-radius: 6px; padding: 16px; margin-bottom: 16px; }
        .section-title { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #e6e6e6; }
        .script-area { font-family: 'Courier New', Consolas, monospace; font-size: 13px; line-height: 1.6; background: #fff; border: 1px solid #e6e6e6; border-radius: 4px; padding: 12px; }
        .btn-bar { text-align: center; margin-top: 20px; padding-top: 16px; border-top: 1px solid #eee; }
        .btn-bar .layui-btn { min-width: 100px; margin: 0 8px; }
    </style>
</head>
<body>
<div class="splayui-container form-layout">
    <form class="layui-form" id="js-flow-form">
        <input type="hidden" name="id" value="${result.id!}">

        <div class="step-bar">
            <div class="step-item active" data-step="1">
                <div class="step-num">1</div>
                <div class="step-label">基本信息</div>
            </div>
            <div class="step-line"></div>
            <div class="step-item" data-step="2">
                <div class="step-num">2</div>
                <div class="step-label">绑定配置</div>
            </div>
            <div class="step-line"></div>
            <div class="step-item" data-step="3">
                <div class="step-num">3</div>
                <div class="step-label">脚本配置</div>
            </div>
        </div>

        <div class="step-panel active" data-panel="1">
            <div class="section-card">
                <div class="section-title">基本信息</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程编码</label>
                    <div class="layui-input-block">
                        <input type="text" name="flowCode" lay-verify="required" lay-reqtext="请输入流程编码" class="layui-input" value="${result.flowCode!}" placeholder="请输入流程编码，如 order_release">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程名称</label>
                    <div class="layui-input-block">
                        <input type="text" name="flowName" lay-verify="required" lay-reqtext="请输入流程名称" class="layui-input" value="${result.flowName!}" placeholder="请输入流程名称，如 订单发布流程">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程分类</label>
                    <div class="layui-input-block">
                        <select name="flowCategoryId" lay-verify="required">
                            <option value="">请选择流程分类</option>
                            <#list categories as item>
                                <option value="${item.id}" <#if (result.flowCategoryId!'') == item.id>selected</#if>>${item.categoryName!}</option>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程类型</label>
                    <div class="layui-input-block">
                        <input type="text" name="flowType" class="layui-input" value="${result.flowType!}" placeholder="请输入流程类型">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">版本</label>
                    <div class="layui-input-block">
                        <input type="text" name="version" class="layui-input" value="${result.version!'1.0'}" placeholder="请输入版本号">
                    </div>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="2">
            <div class="section-card">
                <div class="section-title">绑定配置</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">绑定类型</label>
                    <div class="layui-input-block">
                        <select name="bindType">
                            <option value="process" <#if (result.bindType!'process') == 'process'>selected</#if>>流程</option>
                            <option value="button" <#if (result.bindType!'process') == 'button'>selected</#if>>按钮</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">按钮编码</label>
                    <div class="layui-input-block">
                        <input type="text" name="buttonCode" class="layui-input" value="${result.buttonCode!}" placeholder="当绑定类型为按钮时填写">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <select name="state">
                            <option value="0" <#if (result.state!'0') == '0'>selected</#if>>正常</option>
                            <option value="1" <#if (result.state!'0') == '1'>selected</#if>>禁用</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="3">
            <div class="section-card">
                <div class="section-title">脚本配置</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">脚本内容</label>
                    <div class="layui-input-block">
                        <textarea name="scriptContent" class="layui-textarea script-area" rows="8" placeholder="流程执行脚本">${result.scriptContent!}</textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">描述</label>
                    <div class="layui-input-block">
                        <textarea name="description" class="layui-textarea" rows="4" placeholder="请输入流程描述">${result.description!}</textarea>
                    </div>
                </div>
            </div>
        </div>

        <div class="btn-bar">
            <button type="button" class="layui-btn layui-btn-primary" id="js-prev" style="display:none;">上一步</button>
            <button type="button" class="layui-btn" id="js-next">下一步</button>
            <button type="button" class="layui-btn layui-btn-normal" id="js-submit" style="display:none;">确定</button>
        </div>
    </form>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var form = layui.form, layer = layui.layer;
    var currentStep = 1;
    var totalSteps = 3;

    form.render();

    function updateStepUI() {
        $('.step-item').each(function () {
            var step = parseInt($(this).data('step'));
            $(this).removeClass('active done');
            if (step === currentStep) {
                $(this).addClass('active');
            } else if (step < currentStep) {
                $(this).addClass('done');
            }
        });
        $('.step-panel').removeClass('active');
        $('.step-panel[data-panel="' + currentStep + '"]').addClass('active');
        $('#js-prev').toggle(currentStep > 1);
        $('#js-next').toggle(currentStep < totalSteps);
        $('#js-submit').toggle(currentStep === totalSteps);
    }

    $('#js-next').on('click', function () {
        if (currentStep === 1) {
            var flowCode = $('input[name="flowCode"]').val();
            var flowName = $('input[name="flowName"]').val();
            var flowCategoryId = $('select[name="flowCategoryId"]').val();
            if (!flowCode || !flowName || !flowCategoryId) {
                layer.msg('请填写流程编码、流程名称并选择流程分类');
                return;
            }
        }
        if (currentStep < totalSteps) {
            currentStep++;
            updateStepUI();
        }
    });

    $('#js-prev').on('click', function () {
        if (currentStep > 1) {
            currentStep--;
            updateStepUI();
        }
    });

    $('#js-submit').on('click', function () {
        doSave();
    });

    function doSave() {
        var data = {};
        $('#js-flow-form').find('input,select,textarea').each(function () {
            var name = $(this).attr('name');
            if (!name) return;
            data[name] = $(this).val();
        });
        if (!data.flowCode) {
            layer.msg('请输入流程编码');
            return;
        }
        if (!data.flowName) {
            layer.msg('请输入流程名称');
            return;
        }
        if (!data.flowCategoryId) {
            layer.msg('请选择流程分类');
            return;
        }
        $.ajax({
            url: '${request.contextPath}/technology/flow/definition/add-or-update',
            type: 'POST',
            data: data,
            success: function (result) {
                if (result.code === 0) {
                    window.spChildFrameResult = result;
                    layer.msg('保存成功');
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.location.reload();
                    parent.layer.close(index);
                } else {
                    layer.msg(result.msg || '保存失败');
                }
            },
            error: function () {
                layer.msg('保存失败，请检查后端接口');
            }
        });
    }
});
</script>
</body>
</html>
