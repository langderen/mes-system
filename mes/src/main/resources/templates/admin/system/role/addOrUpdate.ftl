<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加角色</title>
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
                        <label for="js-name" class="layui-form-label sp-required">角色名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${result.name}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-code" class="layui-form-label sp-required">角色编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${result.code}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" autocomplete="off" class="layui-input" value="${result.descr}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常" <#if result.deleted == "0" || !(result??)>checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if result.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if result.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs12 layui-col-sm12 layui-col-md6">
                    <div class="layui-form-item" pane="">
                        <label class="layui-form-label">分配权限</label>
                        <div class="layui-input-block">
                            <div style="text-align: right; margin-bottom: 8px;">
                                <a href="javascript:;" id="js-expand-all" class="layui-btn layui-btn-xs">展开</a>
                                <a href="javascript:;" id="js-collapse-all" class="layui-btn layui-btn-xs layui-btn-primary">折叠</a>
                            </div>
                            <div class="menu-tree-container">
                                <ul class="menu-tree" id="js-menu-tree">
                                    <#if sysMenus??>
                                        <#assign topMenus = []>
                                        <#list sysMenus as menu>
                                            <#if menu.parentId == "0" || !menu.parentId?? || menu.parentId == "" || menu.parentId == null>
                                                <#assign topMenus = topMenus + [menu]>
                                            </#if>
                                        </#list>
                                        <#list topMenus as topMenu>
                                            <li>
                                                <div class="menu-item" data-id="${topMenu.id}">
                                                    <span class="menu-expand" data-id="${topMenu.id}">+</span>
                                                    <span class="menu-icon"><i class="fa fa-folder"></i></span>
                                                    <input type="checkbox" name="menuIds" value="${topMenu.id}" lay-filter="menuCheck" lay-skin="primary" <#if topMenu.checked>checked</#if>>
                                                    <span class="menu-name">${topMenu.name}</span>
                                                </div>
                                                <#assign children = []>
                                                <#list sysMenus as m>
                                                    <#if m.parentId == topMenu.id>
                                                        <#assign children = children + [m]>
                                                    </#if>
                                                </#list>
                                                <#if children?size gt 0>
                                                    <ul class="menu-child" data-parent="${topMenu.id}">
                                                        <#list children as child>
                                                            <@renderSubMenu menu=child />
                                                        </#list>
                                                    </ul>
                                                </#if>
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
                        <input id="js-id" name="id" value="${result.id}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<#macro renderSubMenu menu>
    <#assign hasChildren = false>
    <#list sysMenus as m>
        <#if m.parentId == menu.id>
            <#assign hasChildren = true>
            <#break>
        </#if>
    </#list>
    <li>
        <div class="menu-item" data-id="${menu.id}">
            <span class="menu-expand" data-id="${menu.id}"><#if hasChildren>+</#if></span>
            <span class="menu-icon">
                <#if menu.type == "0"><i class="fa fa-folder"></i>
                <#elseif menu.type == "1"><i class="fa fa-file-text"></i>
                <#else><i class="fa fa-circle-o"></i></#if>
            </span>
            <input type="checkbox" name="menuIds" value="${menu.id}" lay-filter="menuCheck" lay-skin="primary" <#if menu.checked>checked</#if>>
            <span class="menu-name">${menu.name}</span>
            <#if menu.url?? && menu.url != "">
                <span class="menu-url">${menu.url}</span>
            </#if>
        </div>
        <#if hasChildren>
            <ul class="menu-child" data-parent="${menu.id}">
                <#list sysMenus as child>
                    <#if child.parentId == menu.id>
                        <@renderSubMenu menu=child />
                    </#if>
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
            $childUl.find('> li > .menu-item > input[name="menuIds"]').each(function() {
                setCheckboxState($(this), checked);
                cascadeChildrenRecursive($(this).val(), checked);
            });
        }

        function updateParentState($childUl) {
            var parentId = $childUl.data('parent');
            var $parentInput = $('.menu-item[data-id="' + parentId + '"]').children('input[name="menuIds"]');
            if ($parentInput.length === 0) return;
            var $allChildInputs = $childUl.find('> li > .menu-item > input[name="menuIds"]');
            var allChecked = $allChildInputs.length > 0 && $allChildInputs.length === $allChildInputs.filter(':checked').length;
            setCheckboxState($parentInput, allChecked);
            var $parentUl = $parentInput.closest('li').parent('.menu-child');
            if ($parentUl.length > 0) {
                updateParentState($parentUl);
            }
        }

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

        form.on('checkbox(menuCheck)', function(data) {
            var checked = data.elem.checked;
            var id = data.value;
            cascadeChildrenRecursive(id, checked);
            var $parentUl = $(data.othis).closest('li').parent('.menu-child');
            if ($parentUl.length > 0) {
                updateParentState($parentUl);
            }
        });

        form.on('submit(js-submit-filter)', function (data) {
            var checkedMenuIds = [];
            $('#js-menu-tree input[name="menuIds"]:checked').each(function() {
                checkedMenuIds.push($(this).val());
            });
            var submitData = $.extend({}, data.field, { menuIds: checkedMenuIds });
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/role/add-or-update",
                data: submitData,
                traditional: true
            });
            return false;
        });
    });
</script>
</body>
</html>