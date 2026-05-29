<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料信息编辑</title>
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
                        <label for="js-code" class="layui-form-label sp-required">物料编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.code!generatedCode!}" <#if !(result??)>readonly style="background-color:#f5f5f5;"</#if>>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">物料名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.name!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-matType" class="layui-form-label sp-required">物料类型</label>
                        <div class="layui-input-inline">
                            <select id="js-matType" name="matType" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-matSource" class="layui-form-label sp-required">物料来源</label>
                        <div class="layui-input-inline">
                            <select id="js-matSource" name="matSource" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-unit" class="layui-form-label sp-required">单位</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-unit" name="unit" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.unit!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-texture" class="layui-form-label sp-required">材质</label>
                        <div class="layui-input-inline">
                            <select id="js-texture" name="texture" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-model" class="layui-form-label">规格型号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-model" name="model" autocomplete="off"
                                   class="layui-input" value="${result.model!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-size" class="layui-form-label">尺寸</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-size" name="size" autocomplete="off"
                                   class="layui-input" value="${result.size!}">
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-leadTime" class="layui-form-label">提前期(天)</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-leadTime" name="leadTime" autocomplete="off"
                                   class="layui-input" value="${result.leadTime!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-safetyStock" class="layui-form-label">安全库存</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-safetyStock" name="safetyStock" autocomplete="off"
                                   class="layui-input" value="${result.safetyStock!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" autocomplete="off"
                                   class="layui-input" value="${result.descr!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if !result?? || result.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除"
                                   <#if result?? && result.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用"
                                   <#if result?? && result.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${result.id!}"/>
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
        var savedMatType = '${result.matType!}';
        var savedMatSource = '${result.matSource!}';
        var savedTexture = '${result.texture!}';

        function loadDictDropdown(type, elementId, savedValue) {
            spUtil.ajax({
                url: '${request.contextPath}/basedata/dict/list/' + type,
                async: false,
                type: 'GET',
                serializable: false,
                data: {},
                success: function (data) {
                    var $sel = $('#' + elementId);
                    // 先清空原有选项（只保留"请选择"）
                    $sel.find('option:gt(0)').remove();
                    $.each(data.data, function (index, item) {
                        var selected = (savedValue && savedValue === item.value) ? ' selected' : '';
                        $sel.append('<option value="' + item.value + '"' + selected + '>' + item.name + '</option>');
                    });
                }
            });
        }

        loadDictDropdown('material_type', 'js-matType', savedMatType);
        loadDictDropdown('material_source', 'js-matSource', savedMatSource);
        loadDictDropdown('material_texture', 'js-texture', savedTexture);

        form.render();

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/materialinfo/add-or-update",
                data: data.field,
                success: function (result) {
                    if (result.code === 0) {
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.layui.table.reload('js-record-table');
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>