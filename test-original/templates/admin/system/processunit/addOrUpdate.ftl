<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>加工单元编辑</title>
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
                        <label for="js-code" class="layui-form-label sp-required">单元编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${processUnit.code!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">单元名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${processUnit.name!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-group-id" class="layui-form-label">关联班组</label>
                        <div class="layui-input-inline">
                            <select id="js-group-id" name="groupId" lay-verify="">
                                <option value="">请选择班组</option>
                                <#if groups??>
                                    <#list groups as g>
                                        <option value="${g.id}" <#if processUnit?? && processUnit.groupId == g.id>selected</#if>>${g.code} - ${g.name}</option>
                                    </#list>
                                </#if>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-equipment-group-id" class="layui-form-label">关联设备编组</label>
                        <div class="layui-input-inline">
                            <select id="js-equipment-group-id" name="equipmentGroupId" lay-verify="">
                                <option value="">请选择设备编组</option>
                                <#if equipmentGroups??>
                                    <#list equipmentGroups as eg>
                                        <option value="${eg.id}" <#if processUnit?? && processUnit.equipmentGroupId == eg.id>selected</#if>>${eg.code} - ${eg.name}</option>
                                    </#list>
                                </#if>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-daily-standard-capacity" class="layui-form-label">日标准产能</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-daily-standard-capacity" name="dailyStandardCapacity" autocomplete="off" class="layui-input" value="${processUnit.dailyStandardCapacity!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-has-limited-side-storage" class="layui-form-label sp-required">是否有有限边库</label>
                        <div class="layui-input-block" id="js-has-limited-side-storage">
                            <input type="radio" name="hasLimitedSideStorage" value="0" title="否" <#if !processUnit?? || processUnit.hasLimitedSideStorage == "0">checked</#if>>
                            <input type="radio" name="hasLimitedSideStorage" value="1" title="是" <#if processUnit?? && processUnit.hasLimitedSideStorage == "1">checked</#if>>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-side-storage-capacity" class="layui-form-label">边库容量</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-side-storage-capacity" name="sideStorageCapacity" autocomplete="off" class="layui-input" value="${processUnit.sideStorageCapacity!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-status" class="layui-form-label sp-required">运行状态</label>
                        <div class="layui-input-block" id="js-status">
                            <input type="radio" name="status" value="0" title="正常" <#if !processUnit?? || processUnit.status == "0">checked</#if>>
                            <input type="radio" name="status" value="1" title="停用" <#if processUnit?? && processUnit.status == "1">checked</#if>>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" autocomplete="off" class="layui-input" value="${processUnit.descr!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="deleted" value="0" title="正常" <#if !processUnit?? || processUnit.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if processUnit?? && processUnit.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if processUnit?? && processUnit.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${processUnit.id!}"/>
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
                url: "${request.contextPath}/admin/sys/processunit/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>