<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备编组编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .menu-tree-container {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #e6e6e6;
            padding: 10px;
            background: #fafafa;
        }
        .menu-tree {
            list-style: none;
            padding-left: 0;
            margin: 0;
        }
        .menu-item {
            position: relative;
            line-height: 28px;
            cursor: pointer;
        }
        .menu-item:hover {
            background: #f2f2f2;
        }
        .menu-expand {
            display: inline-block;
            width: 16px;
            height: 16px;
            line-height: 14px;
            text-align: center;
            font-size: 12px;
            color: #999;
            cursor: pointer;
            margin-right: 4px;
        }
        .menu-icon {
            display: inline-block;
            width: 16px;
            height: 16px;
            line-height: 16px;
            text-align: center;
            font-size: 14px;
            margin-right: 6px;
        }
        .menu-checkbox {
            margin-right: 6px;
            vertical-align: middle;
        }
        .menu-name {
            display: inline-block;
            vertical-align: middle;
        }
        .menu-url {
            color: #999;
            font-size: 12px;
            margin-left: 8px;
        }
        .menu-tree-container .layui-form-checkbox { margin-right: 0; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form">
            <div class="layui-row">
                <div class="layui-col-xs12 layui-col-sm12 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-code" class="layui-form-label sp-required">编组代码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${group.code!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">编组名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${group.name!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" autocomplete="off" class="layui-input" value="${group.descr!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="deleted" value="0" title="正常" <#if !group?? || group.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if group?? && group.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if group?? && group.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs12 layui-col-sm12 layui-col-md6">
                    <div class="layui-form-item" pane="">
                        <label class="layui-form-label">关联设备</label>
                        <div class="layui-input-block">
                            <div style="margin-bottom: 8px;">
                                <input type="text" id="js-equipment-search" placeholder="搜索设备编码/名称..." autocomplete="off" class="layui-input" style="display:inline-block;width:200px;">
                                <button type="button" class="layui-btn layui-btn-sm" id="js-equipment-search-btn"><i class="layui-icon layui-icon-search"></i> 搜索</button>
                                <a href="javascript:;" id="js-select-all-eq" class="layui-btn layui-btn-xs">全选</a>
                                <a href="javascript:;" id="js-deselect-all-eq" class="layui-btn layui-btn-xs layui-btn-primary">取消全选</a>
                            </div>
                            <div class="menu-tree-container" style="max-height: 400px;">
                                <ul class="menu-tree" id="js-equipment-group-tree">
                                    <#if equipmentList??>
                                        <#list equipmentList as eq>
                                            <li class="eq-item" data-code="${eq.code!}" data-name="${eq.name!}">
                                                <div class="menu-item">
                                                    <span class="menu-expand" style="visibility:hidden;">+</span>
                                                    <span class="menu-icon"><i class="fa fa-cog"></i></span>
                                                    <input type="checkbox" name="equipmentIds" value="${eq.id}" lay-skin="primary" <#if eq.checked>checked</#if>>
                                                    <span class="menu-name">${eq.code} - ${eq.name}</span>
                                                    <span class="menu-url"><#if eq.model??>型号:${eq.model}</#if> <#if eq.type??>类型:${eq.type}</#if></span>
                                                </div>
                                            </li>
                                        </#list>
                                    </#if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${group.id!}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form', 'jquery'], function () {
        var form = layui.form;
        var $ = layui.jquery;

        // 统一设置复选框状态（兼容Layui样式）
        function setCheckboxState($input, checked) {
            $input.prop('checked', checked);
            form.render('checkbox'); // 核心：用Layui自带渲染，不要手动操作class
        }

        // 搜索过滤设备（修复版）
        function filterEquipment() {
            var keyword = $.trim($('#js-equipment-search').val()).toLowerCase();
            $('#js-equipment-group-tree .eq-item').each(function() {
                var $item = $(this);
                var code = ($item.data('code') || '').toLowerCase();
                var name = ($item.data('name') || '').toLowerCase();

                // 匹配关键词
                var match = !keyword || code.indexOf(keyword) > -1 || name.indexOf(keyword) > -1;
                $item.toggle(match); // 正确显示/隐藏
            });
        }

        // 提交事件
        form.on('submit(js-submit-filter)', function (data) {
            var checkedEquipmentIds = [];
            $('#js-equipment-group-tree input[name="equipmentIds"]:checked').each(function() {
                checkedEquipmentIds.push($(this).val());
            });
            var submitData = $.extend({}, data.field, {
                equipmentIds: checkedEquipmentIds
            });
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/equipmentgroup/add-or-update",
                data: submitData,
                traditional: true
            });
            return false;
        });

        // 绑定事件
        $('#js-equipment-search').on('input propertychange', filterEquipment);
        $('#js-equipment-search-btn').on('click', filterEquipment);

        // 全选
        $('#js-select-all-eq').on('click', function() {
            $('#js-equipment-group-tree .eq-item:visible input[name="equipmentIds"]').prop('checked', true);
            form.render('checkbox');
        });

        // 取消全选
        $('#js-deselect-all-eq').on('click', function() {
            $('#js-equipment-group-tree .eq-item:visible input[name="equipmentIds"]').prop('checked', false);
            form.render('checkbox');
        });

        // 最后渲染
        form.render();
    });
</script>
</body>
</html>