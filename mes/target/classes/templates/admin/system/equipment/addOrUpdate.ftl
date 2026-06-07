<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-code" class="layui-form-label sp-required">设备编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${equipment.code!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">设备名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${equipment.name!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-model" class="layui-form-label">设备型号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-model" name="model" autocomplete="off" class="layui-input" value="${equipment.model!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-type" class="layui-form-label">设备类型</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-type" name="type" autocomplete="off" class="layui-input" value="${equipment.type!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-status" class="layui-form-label sp-required">运行状态</label>
                        <div class="layui-input-block" id="js-status">
                            <input type="radio" name="status" value="0" title="正常" <#if !equipment?? || equipment.status == "0">checked</#if>>
                            <input type="radio" name="status" value="1" title="故障" <#if equipment?? && equipment.status == "1">checked</#if>>
                            <input type="radio" name="status" value="2" title="维修中" <#if equipment?? && equipment.status == "2">checked</#if>>
                            <input type="radio" name="status" value="3" title="报废" <#if equipment?? && equipment.status == "3">checked</#if>>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" autocomplete="off" class="layui-input" value="${equipment.descr!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="deleted" value="0" title="正常" <#if !equipment?? || equipment.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if equipment?? && equipment.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if equipment?? && equipment.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${equipment.id!}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/equipment/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>