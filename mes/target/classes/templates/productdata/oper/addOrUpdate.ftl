<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="js-oper-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">工序编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="oper" lay-verify="required" autocomplete="off" class="layui-input" value="${oper.oper!}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">工序描述</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operDesc" lay-verify="required" autocomplete="off" class="layui-input" value="${oper.operDesc!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工序类型</label>
                    <div class="layui-input-inline">
                        <select name="operType">
                            <option value="">请选择</option>
                            <option value="加工" <#if oper.operType?? && oper.operType == '加工'>selected</#if>>加工</option>
                            <option value="装配" <#if oper.operType?? && oper.operType == '装配'>selected</#if>>装配</option>
                            <option value="检验" <#if oper.operType?? && oper.operType == '检验'>selected</#if>>检验</option>
                            <option value="包装" <#if oper.operType?? && oper.operType == '包装'>selected</#if>>包装</option>
                            <option value="搬运" <#if oper.operType?? && oper.operType == '搬运'>selected</#if>>搬运</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">标准工时(分)</label>
                    <div class="layui-input-inline">
                        <input type="text" name="standardTime" autocomplete="off" class="layui-input" value="${oper.standardTime!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">所需设备类型</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentType" autocomplete="off" class="layui-input" value="${oper.equipmentType!}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">关键工序</label>
                    <div class="layui-input-inline">
                        <input type="radio" name="isKeyOper" value="0" title="否" <#if !oper.isKeyOper?? || oper.isKeyOper == '0'>checked</#if>>
                        <input type="radio" name="isKeyOper" value="1" title="是" <#if oper.isKeyOper?? && oper.isKeyOper == '1'>checked</#if>>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input name="id" value="${oper.id!}"/>
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        form.render();
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/productdata/oper/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
