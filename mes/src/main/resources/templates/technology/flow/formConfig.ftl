<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程表单</title>
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
        .script-area { font-family: 'Courier New', Consolas, monospace; font-size: 13px; line-height: 1.6; background: #1e1e1e; color: #d4d4d4; border: none; border-radius: 4px; padding: 12px; }
        .script-area:focus { border-color: #2f54eb; }
        .option-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .option-card { display: flex; align-items: center; padding: 12px 16px; background: #fff; border: 1px solid #e6e6e6; border-radius: 6px; transition: all 0.2s; }
        .option-card:hover { border-color: #2f54eb; box-shadow: 0 2px 8px rgba(47,84,235,0.1); }
        .option-card .layui-form-checkbox { margin: 0 !important; }
        .option-label { margin-left: 8px; }
        .option-desc { font-size: 12px; color: #999; margin-top: 2px; }
        .gen-script-btn { margin-top: 8px; }
        .preview-box { background: #fffbe6; border: 1px solid #ffe58f; border-radius: 4px; padding: 10px 14px; margin-top: 10px; font-size: 12px; color: #8c6e00; display: none; }
        .btn-bar { text-align: center; margin-top: 20px; padding-top: 16px; border-top: 1px solid #eee; }
        .btn-bar .layui-btn { min-width: 100px; margin: 0 8px; }
    </style>
</head>
<body>
<div class="splayui-container form-layout">
    <form class="layui-form" id="js-flow-form">
        <input type="hidden" name="id" value="${result.id!}">
        <input type="hidden" name="flowId" value="${result.flowId!}">

        <div class="step-bar">
            <div class="step-item active" data-step="1">
                <div class="step-num">1</div>
                <div class="step-label">基本信息</div>
            </div>
            <div class="step-line"></div>
            <div class="step-item" data-step="2">
                <div class="step-num">2</div>
                <div class="step-label">表单地址与脚本</div>
            </div>
            <div class="step-line"></div>
            <div class="step-item" data-step="3">
                <div class="step-num">3</div>
                <div class="step-label">表单选项</div>
            </div>
        </div>

        <div class="step-panel active" data-panel="1">
            <div class="section-card">
                <div class="section-title">基本信息</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">表单名称</label>
                    <div class="layui-input-block">
                        <input type="text" name="formName" lay-verify="required" lay-reqtext="请输入表单名称" class="layui-input" value="${result.formName!}" placeholder="请输入表单名称">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">表单Key</label>
                    <div class="layui-input-block">
                        <input type="text" name="formKey" lay-verify="required" lay-reqtext="请输入表单Key" class="layui-input" value="${result.formKey!}" placeholder="请输入表单Key，如 order_release_form">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">表单类型</label>
                    <div class="layui-input-block">
                        <select name="formType" lay-verify="required">
                            <option value="">请选择表单类型</option>
                            <option value="default" <#if (result.formType!'default') == 'default'>selected</#if>>默认表单</option>
                            <option value="script" <#if (result.formType!'') == 'script'>selected</#if>>脚本表单</option>
                            <option value="url" <#if (result.formType!'') == 'url'>selected</#if>>URL表单</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程标题</label>
                    <div class="layui-input-block">
                        <input type="text" name="flowTitle" class="layui-input" value="${(result.flowTitle!)?html}" placeholder="请选择或输入流程标题，如 ${order.orderCode}">
                    </div>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="2">
            <div class="section-card">
                <div class="section-title">表单地址</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">PC表单地址</label>
                    <div class="layui-input-block">
                        <input type="text" name="pcFormUrl" class="layui-input" value="${(result.pcFormUrl!)?html}" placeholder="PC端表单URL，如 /order/release/add-or-update-ui">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">手机表单地址</label>
                    <div class="layui-input-block">
                        <input type="text" name="mobileFormUrl" class="layui-input" value="${(result.mobileFormUrl!)?html}" placeholder="移动端表单URL，如 /mobile/order/release/add-or-update-ui">
                    </div>
                </div>
            </div>

            <div class="section-card">
                <div class="section-title">流程事件脚本</div>
                <div class="layui-form-item">
                    <label class="layui-form-label">初始化脚本</label>
                    <div class="layui-input-block">
                        <textarea name="initScript" class="layui-textarea script-area" rows="5" placeholder="// 表单初始化时执行，可设置默认值&#10;// ctx: 上下文对象&#10;// bizData: 业务数据">${(result.initScript!)?html}</textarea>
                        <button type="button" class="layui-btn layui-btn-xs layui-btn-normal gen-script-btn" data-target="init">生成初始化脚本</button>
                        <div class="preview-box" id="js-preview-init"></div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">审批通过脚本</label>
                    <div class="layui-input-block">
                        <textarea name="approveScript" class="layui-textarea script-area" rows="5" placeholder="// 审批通过时执行，同步业务状态&#10;// ctx: 上下文对象&#10;// bizData: 业务数据">${(result.approveScript!)?html}</textarea>
                        <button type="button" class="layui-btn layui-btn-xs layui-btn-normal gen-script-btn" data-target="approve">生成审批脚本</button>
                        <div class="preview-box" id="js-preview-approve"></div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">审批退回脚本</label>
                    <div class="layui-input-block">
                        <textarea name="rejectScript" class="layui-textarea script-area" rows="5" placeholder="// 审批退回时执行&#10;// ctx: 上下文对象&#10;// bizData: 业务数据">${(result.rejectScript!)?html}</textarea>
                        <button type="button" class="layui-btn layui-btn-xs layui-btn-normal gen-script-btn" data-target="reject">生成退回脚本</button>
                        <div class="preview-box" id="js-preview-reject"></div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程结束脚本</label>
                    <div class="layui-input-block">
                        <textarea name="endScript" class="layui-textarea script-area" rows="5" placeholder="// 流程结束时执行，同步最终业务状态&#10;// ctx: 上下文对象&#10;// bizData: 业务数据">${(result.endScript!)?html}</textarea>
                        <button type="button" class="layui-btn layui-btn-xs layui-btn-normal gen-script-btn" data-target="end">生成结束脚本</button>
                        <div class="preview-box" id="js-preview-end"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="step-panel" data-panel="3">
            <div class="section-card">
                <div class="section-title">表单选项</div>
                <div class="option-grid">
                    <div class="option-card">
                        <input type="checkbox" name="skipFirst" value="1" lay-skin="primary" title="跳过第一个环节" <#if (result.skipFirst!0) == 1>checked</#if>>
                        <div class="option-label">
                            <div>跳过第一个环节</div>
                            <div class="option-desc">流程发起后自动跳过第一个审批环节</div>
                        </div>
                    </div>
                    <div class="option-card">
                        <input type="checkbox" name="skipSameHandler" value="1" lay-skin="primary" title="跳过相同处理人" <#if (result.skipSameHandler!0) == 1>checked</#if>>
                        <div class="option-label">
                            <div>跳过相同处理人</div>
                            <div class="option-desc">上一环节与当前环节处理人相同时自动跳过</div>
                        </div>
                    </div>
                    <div class="option-card">
                        <input type="checkbox" name="allowReturn" value="1" lay-skin="primary" title="允许退回" <#if (result.allowReturn!1) == 1>checked</#if>>
                        <div class="option-label">
                            <div>允许退回</div>
                            <div class="option-desc">审批人可将流程退回至上一环节</div>
                        </div>
                    </div>
                    <div class="option-card">
                        <input type="checkbox" name="allowTransfer" value="1" lay-skin="primary" title="允许转办" <#if (result.allowTransfer!1) == 1>checked</#if>>
                        <div class="option-label">
                            <div>允许转办</div>
                            <div class="option-desc">审批人可将任务转交给其他人处理</div>
                        </div>
                    </div>
                    <div class="option-card">
                        <input type="checkbox" name="allowDelegate" value="1" lay-skin="primary" title="允许委托" <#if (result.allowDelegate!1) == 1>checked</#if>>
                        <div class="option-label">
                            <div>允许委托</div>
                            <div class="option-desc">审批人可委托他人代为审批</div>
                        </div>
                    </div>
                    <div class="option-card">
                        <input type="checkbox" name="allowWithdraw" value="1" lay-skin="primary" title="允许撤回" <#if (result.allowWithdraw!1) == 1>checked</#if>>
                        <div class="option-label">
                            <div>允许撤回</div>
                            <div class="option-desc">流程发起人可在审批前撤回流程</div>
                        </div>
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

    var scriptTemplates = {
        init: '// 表单初始化脚本 - 设置默认值\n' +
              'function onInit(ctx, bizData) {\n' +
              '    // ctx.flowId: 流程ID\n' +
              '    // ctx.flowName: 流程名称\n' +
              '    // bizData: 业务数据对象\n' +
              '    bizData.status = "pending";\n' +
              '    bizData.submitTime = new Date().toISOString();\n' +
              '}',
        approve: '// 审批通过脚本 - 同步业务状态\n' +
                 'function onApprove(ctx, bizData) {\n' +
                 '    // ctx.currentNode: 当前审批节点\n' +
                 '    // ctx.approver: 审批人\n' +
                 '    // ctx.comment: 审批意见\n' +
                 '    bizData.status = "approved";\n' +
                 '    bizData.approveTime = new Date().toISOString();\n' +
                 '    bizData.approver = ctx.approver;\n' +
                 '}',
        reject: '// 审批退回脚本 - 恢复业务状态\n' +
                'function onReject(ctx, bizData) {\n' +
                '    // ctx.currentNode: 当前审批节点\n' +
                '    // ctx.approver: 审批人\n' +
                '    // ctx.comment: 退回原因\n' +
                '    bizData.status = "rejected";\n' +
                '    bizData.rejectTime = new Date().toISOString();\n' +
                '    bizData.rejectReason = ctx.comment;\n' +
                '}',
        end: '// 流程结束脚本 - 同步最终业务状态\n' +
             'function onEnd(ctx, bizData) {\n' +
             '    // ctx.flowId: 流程ID\n' +
             '    // ctx.result: 流程结果(approved/rejected)\n' +
             '    if (ctx.result === "approved") {\n' +
             '        bizData.status = "completed";\n' +
             '    } else {\n' +
             '        bizData.status = "cancelled";\n' +
             '    }\n' +
             '    bizData.endTime = new Date().toISOString();\n' +
             '}'
    };

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
            var formName = $('input[name="formName"]').val();
            var formKey = $('input[name="formKey"]').val();
            if (!formName || !formKey) {
                layer.msg('请填写表单名称和表单Key');
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

    $('.gen-script-btn').on('click', function () {
        var target = $(this).data('target');
        var $textarea = $('textarea[name="' + target + 'Script"]');
        var template = scriptTemplates[target];
        if (!template) return;
        if ($textarea.val().trim()) {
            layer.confirm('当前脚本内容不为空，是否覆盖？', function (idx) {
                layer.close(idx);
                $textarea.val(template);
                layer.msg('脚本已生成');
            });
        } else {
            $textarea.val(template);
            layer.msg('脚本已生成');
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
            if ($(this).is(':checkbox')) {
                data[name] = $(this).is(':checked') ? 1 : 0;
            } else {
                data[name] = $(this).val();
            }
        });
        if (!data.formName) {
            layer.msg('请填写表单名称');
            return;
        }
        if (!data.formKey) {
            layer.msg('请填写表单Key');
            return;
        }
        $.ajax({
            url: '${request.contextPath}/basedata/flow/form/add-or-update',
            type: 'POST',
            data: data,
            success: function (result) {
                if (result.code === 0) {
                    window.spChildFrameResult = result;
                    layer.msg('保存成功');
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
