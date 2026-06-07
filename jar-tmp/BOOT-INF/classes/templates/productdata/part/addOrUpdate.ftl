<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="js-part-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">零部件编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="partCode" lay-verify="required" autocomplete="off" class="layui-input" value="${part.partCode!}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">零部件名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="partName" lay-verify="required" autocomplete="off" class="layui-input" value="${part.partName!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">零部件类型</label>
                    <div class="layui-input-inline">
                        <select name="partType" lay-verify="required">
                            <option value="">请选择</option>
                            <option value="原料" <#if part.partType?? && part.partType == '原料'>selected</#if>>原料</option>
                            <option value="半成品" <#if part.partType?? && part.partType == '半成品'>selected</#if>>半成品</option>
                            <option value="成品" <#if part.partType?? && part.partType == '成品'>selected</#if>>成品</option>
                            <option value="辅料" <#if part.partType?? && part.partType == '辅料'>selected</#if>>辅料</option>
                            <option value="包装" <#if part.partType?? && part.partType == '包装'>selected</#if>>包装</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">规格型号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="spec" autocomplete="off" class="layui-input" value="${part.spec!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">基本单位</label>
                    <div class="layui-input-inline">
                        <input type="text" name="unit" autocomplete="off" class="layui-input" value="${part.unit!}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">材质</label>
                    <div class="layui-input-inline">
                        <input type="text" name="material" autocomplete="off" class="layui-input" value="${part.material!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">重量(kg)</label>
                    <div class="layui-input-inline">
                        <input type="text" name="weight" autocomplete="off" class="layui-input" value="${part.weight!}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">图号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="drawingNo" autocomplete="off" class="layui-input" value="${part.drawingNo!}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">版本号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="version" autocomplete="off" class="layui-input" value="${part.version!'1'}">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label sp-required">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="0" <#if !part.status?? || part.status == '0'>selected</#if>>正常</option>
                            <option value="1" <#if part.status?? && part.status == '1'>selected</#if>>停用</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-block">
                    <textarea name="descr" placeholder="请输入描述" class="layui-textarea">${part.descr!}</textarea>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input name="id" value="${part.id!}"/>
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
                url: "${request.contextPath}/productdata/part/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
