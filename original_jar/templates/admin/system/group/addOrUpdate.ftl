<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>班组编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .menu-tree-container {
            max-height: 500px;
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
        .menu-tree ul {
            list-style: none;
            padding-left: 22px;
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
        .menu-expand:hover {
            color: #1E9FFF;
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
        .menu-group-title { font-weight: bold; color: #333; }
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
                        <label for="js-name" class="layui-form-label sp-required">班组名称</label>
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
                        <div class="layui-input-block" id="js-is-deleted" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常" <#if !group?? || group.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if group?? && group.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if group?? && group.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs12 layui-col-sm12 layui-col-md6">
                    <div class="layui-form-item" pane="">
                        <label class="layui-form-label">班组员工管理</label>
                        <div class="layui-input-block">
                            <div style="text-align: right; margin-bottom: 8px;">
                                <a href="javascript:;" id="js-expand-all" class="layui-btn layui-btn-xs">展开</a>
                                <a href="javascript:;" id="js-collapse-all" class="layui-btn layui-btn-xs layui-btn-primary">折叠</a>
                            </div>
                            <div class="menu-tree-container">
                                <ul class="menu-tree" id="js-group-user-tree">
                                    <#if deptUserTree??>
                                        <#list deptUserTree as deptNode>
                                            <@renderDeptUserNode node=deptNode />
                                        </#list>
                                    </#if>
                                </ul>
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

<#macro renderDeptUserNode node>
    <#assign hasChildren = (node.children?? && node.children?size gt 0)>
    <li>
        <div class="menu-item" data-id="${node.id}">
            <#if node.type == "dept">
                <span class="menu-expand" data-id="${node.id}"><#if hasChildren>+</#if></span>
                <span class="menu-icon"><i class="fa fa-sitemap"></i></span>
                <input type="checkbox" name="userIds" value="" lay-filter="userCheck" lay-skin="primary" <#if node.checked>checked</#if>>
                <span class="menu-name menu-group-title">${node.name}</span>
            <#else>
                <span class="menu-expand" style="visibility:hidden;">+</span>
                <span class="menu-icon"><i class="fa fa-user"></i></span>
                <input type="checkbox" name="userIds" value="${node.id}" lay-filter="userCheck" lay-skin="primary" <#if node.checked>checked</#if>>
                <span class="menu-name">${node.name}</span>
            </#if>
        </div>
        <#if hasChildren>
            <ul class="menu-child" data-parent="${node.id}">
                <#list node.children as child>
                    <@renderDeptUserNode node=child />
                </#list>
            </ul>
        </#if>
    </li>
</#macro>

<script>
    layui.use(['form', 'util'], function () {
        var form = layui.form;

        function setCheckboxState($input, checked) {
            $input.prop('checked', checked);
            var $formCheckbox = $input.closest('.menu-item').find('.layui-form-checkbox');
            if (checked) {
                $formCheckbox.addClass('layui-form-checked');
            } else {
                $formCheckbox.removeClass('layui-form-checked');
            }
        }

        function cascadeChildrenRecursive(parentId, checked) {
            var $childUl = $('ul.menu-child[data-parent="' + parentId + '"]');
            if ($childUl.length === 0) return;
            $childUl.find('> li > .menu-item > input[name="userIds"]').each(function() {
                setCheckboxState($(this), checked);
                cascadeChildrenRecursive($(this).closest('li').find('> .menu-item').data('id'), checked);
            });
        }

        function updateParentState($childUl) {
            var parentId = $childUl.data('parent');
            var $parentInput = $('.menu-item[data-id="' + parentId + '"]').children('input[name="userIds"]');
            if ($parentInput.length === 0) return;
            var $allChildInputs = $childUl.find('> li > .menu-item > input[name="userIds"]');
            var allChecked = $allChildInputs.length > 0 && $allChildInputs.length === $allChildInputs.filter(':checked').length;
            setCheckboxState($parentInput, allChecked);
            var $parentUl = $parentInput.closest('li').parent('.menu-child');
            if ($parentUl.length > 0) {
                updateParentState($parentUl);
            }
        }

        form.on('checkbox(userCheck)', function(data) {
            var checked = data.elem.checked;
            var id = data.elem.value;
            if (id && id.length > 0) {
                cascadeChildrenRecursive(id, checked);
            } else {
                var parentId = $(data.elem).closest('.menu-item').data('id');
                cascadeChildrenRecursive(parentId, checked);
            }
            var $parentUl = $(data.othis).closest('li').parent('.menu-child');
            if ($parentUl.length > 0) {
                updateParentState($parentUl);
            }
        });

        $(function() {
            $('.menu-child').hide();

            $(document).on('click', '.menu-expand', function() {
                var id = $(this).data('id');
                var $child = $('ul.menu-child[data-parent="' + id + '"]');
                if ($child.is(':visible')) {
                    $child.hide();
                    $(this).text('+');
                } else {
                    $child.show();
                    $(this).text('-');
                }
            });

            $('#js-expand-all').click(function() {
                $('.menu-child').show();
                $('.menu-expand').text('-');
            });

            $('#js-collapse-all').click(function() {
                $('.menu-child').hide();
                $('.menu-expand').text('+');
            });

            form.render();
        });

        form.on('submit(js-submit-filter)', function (data) {
            var checkedUserIds = [];
            $('#js-group-user-tree input[name="userIds"]:checked').each(function() {
                var val = $(this).val();
                if (val) {
                    checkedUserIds.push(val);
                }
            });
            var submitData = $.extend({}, data.field, {
                userIds: checkedUserIds
            });
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/group/add-or-update",
                data: submitData,
                traditional: true
            });
            return false;
        });
    });
</script>
</body>
</html>