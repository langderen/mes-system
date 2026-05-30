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
        .section-card { background: #f8f9fc; border: 1px solid #eef0f5; border-radius: 6px; padding: 16px; margin-bottom: 16px; }
        .section-title { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #e6e6e6; }
        .btn-bar { text-align: center; margin-top: 20px; padding-top: 16px; border-top: 1px solid #eee; }
        .btn-bar .layui-btn { min-width: 100px; margin: 0 8px; }
    </style>
</head>
<body>
<div class="splayui-container form-layout">
    <form class="layui-form" id="js-flow-form">
        <input type="hidden" name="id" value="${result.id!}">
        
        <div class="section-card">
            <div class="section-title">基本信息</div>
            <div class="layui-form-item">
                <label class="layui-form-label">流程编码</label>
                <div class="layui-input-block">
                    <input type="text" name="flow" lay-verify="required" lay-reqtext="请输入流程编码" class="layui-input" value="${result.flow!}" placeholder="请输入流程编码，如 order_release">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">流程名称</label>
                <div class="layui-input-block">
                    <input type="text" name="flowDesc" lay-verify="required" lay-reqtext="请输入流程名称" class="layui-input" value="${result.flowDesc!}" placeholder="请输入流程名称，如 订单发布流程">
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
        </div>

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
        </div>

        <div class="section-card">
            <div class="section-title">脚本配置</div>
            <div class="layui-form-item">
                <label class="layui-form-label">脚本内容</label>
                <div class="layui-input-block">
                    <textarea name="scriptContent" class="layui-textarea" rows="6" placeholder="流程执行脚本">${result.scriptContent!}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">说明</label>
                <div class="layui-input-block">
                    <input type="text" name="state" class="layui-input" value="${result.state!'0'}" placeholder="流程说明">
                </div>
            </div>
        </div>

        <div class="layui-form-item" style="display:none;">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </div>
    </form>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var form = layui.form, layer = layui.layer;
    form.render();

    //监听提交
    form.on('submit(js-submit-filter)', function (data) {
        spUtil.submitForm({
            url: "${request.contextPath}/basedata/flow/add-or-update",
            data: data.field
        });

        return false;
    });
});
</script>
</body>
</html>
