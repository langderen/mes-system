<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加部门</title>
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
                        <label for="js-name" class="layui-form-label sp-required">部门名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${department.name!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-parent-id" class="layui-form-label">上级部门</label>
                        <div class="layui-input-inline">
                            <select id="js-parent-id" name="parentId" lay-verify="">
                                <option value="0">顶级部门</option>
                                <#if departments??>
                                    <#list departments as dept>
                                        <option value="${dept.id}" <#if department?? && department.parentId == dept.id>selected</#if>>${dept.name}</option>
                                    </#list>
                                </#if>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-sort-num" class="layui-form-label">排序</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-sort-num" name="sortNum" autocomplete="off" class="layui-input" value="${department.sortNum!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-id" class="layui-form-label sp-required">部门ID</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-id" name="id" lay-verify="required" autocomplete="off" class="layui-input" value="${department.id!}" <#if department?? && department.id??>readonly</#if>>
                            <#if !department?? || !department.id??>
                                <span id="js-id-tip" style="color:#999;font-size:12px;">自动生成：上级部门ID + 排序号</span>
                            </#if>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="isDeleted" value="0" title="正常" <#if !department?? || department.isDeleted == "0">checked</#if>>
                            <input type="radio" name="isDeleted" value="1" title="已删除" <#if department?? && department.isDeleted == "1">checked</#if>>
                            <input type="radio" name="isDeleted" value="2" title="已禁用" <#if department?? && department.isDeleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
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

        var $idInput = $('#js-id');
        var isNew = !$idInput.val();

        function autoGenerateId() {
            if (!isNew) return;
            var parentId = $('#js-parent-id').val() || '0';
            var sortNum = $('#js-sort-num').val();
            if (sortNum) {
                $idInput.val(parentId + sortNum);
            }
        }

        if (isNew) {
            $('#js-parent-id, #js-sort-num').on('change input', autoGenerateId);
        }

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/department/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>