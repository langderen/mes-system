<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>产品BOM编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-item-row { display: flex; align-items: center; padding: 6px 0; border-bottom: 1px solid #f0f0f0; }
        .bom-item-row:hover { background: #fafafa; }
        .bom-item-level { display: inline-block; min-width: 24px; text-align: center; margin-right: 6px; color: #999; font-size: 12px; }
        .bom-item-indent { display: inline-block; }
        .bom-item-actions { margin-left: auto; white-space: nowrap; }
        .bom-tree-node { cursor: pointer; user-select: none; }
        .bom-tree-node .expand-icon { display: inline-block; width: 18px; text-align: center; cursor: pointer; }
        .bom-children { padding-left: 24px; }
        .bom-children.collapsed { display: none; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="layui-tab layui-tab-brief" lay-filter="js-bom-tab-filter">
            <ul class="layui-tab-title">
                <li class="layui-this">BOM基本信息</li>
                <li id="js-bom-item-tab"<#if !bom.id??> style="display:none"</#if>>BOM结构</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form splayui-form" lay-filter="js-bom-form-filter">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label sp-required">BOM编码</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="bomCode" lay-verify="required" autocomplete="off" class="layui-input" value="${bom.bomCode!}">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label sp-required">BOM名称</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="bomName" lay-verify="required" autocomplete="off" class="layui-input" value="${bom.bomName!}">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label sp-required">产品零部件</label>
                                <div class="layui-input-inline" style="width:220px;">
                                    <input type="text" id="js-product-part-code" name="productPartCode" readonly lay-verify="required" autocomplete="off" class="layui-input" value="${bom.productPartCode!}" placeholder="点击搜索">
                                    <input type="hidden" id="js-product-part-id" name="productPartId" value="${bom.productPartId!}">
                                </div>
                                <button type="button" id="js-btn-search-part" class="layui-btn layui-btn-sm"><i class="layui-icon layui-icon-search"></i></button>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">产品名称</label>
                                <div class="layui-input-inline">
                                    <input type="text" id="js-product-part-name" name="productPartName" readonly autocomplete="off" class="layui-input" value="${bom.productPartName!}">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">版本号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="version" autocomplete="off" class="layui-input" value="${bom.version!'1'}">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">BOM类型</label>
                                <div class="layui-input-inline">
                                    <select name="bomType">
                                        <option value="">请选择</option>
                                        <option value="EBOM" <#if bom.bomType?? && bom.bomType == 'EBOM'>selected</#if>>EBOM</option>
                                        <option value="MBOM" <#if bom.bomType?? && bom.bomType == 'MBOM'>selected</#if>>MBOM</option>
                                        <option value="SBOM" <#if bom.bomType?? && bom.bomType == 'SBOM'>selected</#if>>SBOM</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">描述</label>
                            <div class="layui-input-block">
                                <textarea name="descr" placeholder="请输入描述" class="layui-textarea">${bom.descr!}</textarea>
                            </div>
                        </div>
                        <div class="layui-form-item layui-hide">
                            <div class="layui-input-block">
                                <input name="id" value="${bom.id!}"/>
                                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="layui-tab-item">
                    <div id="js-bom-item-panel" style="display:none;">
                        <div class="layui-btn-container" style="margin-bottom:10px;">
                            <button class="layui-btn layui-btn-sm" id="js-btn-add-root-item"><i class="layui-icon">&#xe61f;</i>添加顶层子项</button>
                        </div>
                        <div id="js-bom-tree-container"></div>
                    </div>
                    <div id="js-no-bom-tip" style="padding:40px;text-align:center;color:#999;">
                        <i class="layui-icon" style="font-size:48px;">&#xe61f;</i>
                        <p style="margin-top:10px;">请先保存BOM基本信息后，再管理BOM结构</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use(['form', 'element', 'spLayer'], function () {
        var form = layui.form,
            element = layui.element,
            spLayer = layui.spLayer,
            layer = layui.layer;

        var bomId = '${bom.id!}';

        form.render();

        if (bomId) {
            $('#js-bom-item-panel').show();
            $('#js-no-bom-tip').hide();
            loadBomItems();
        }

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/productdata/productbom/add-or-update",
                data: data.field,
                success: function (result) {
                    if (result.code === 0 && result.data && result.data.id) {
                        if (bomId) {
                            // 编辑模式：更新成功后刷新子项列表
                            bomId = result.data.id;
                            $('input[name="id"]').val(bomId);
                            loadBomItems();
                            layer.msg('保存成功');
                        } else {
                            // 新建模式：保存成功后关闭弹窗
                            layer.msg('创建成功');
                            setTimeout(function() {
                                parent.layer.close(parent.layer.getFrameIndex(window.name));
                            }, 1000);
                        }
                    }
                }
            });
            return false;
        });

        $('#js-btn-search-part').click(function () {
            spLayer.open({
                type: 2,
                area: ['680px', '500px'],
                content: '${request.contextPath}/productdata/part/search-panel-ui',
                reload: false,
                close: true,
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var d = result.data[0];
                        $('#js-product-part-id').val(d.id);
                        $('#js-product-part-code').val(d.partCode);
                        $('#js-product-part-name').val(d.partName);
                    }
                }
            });
        });

        function loadBomItems() {
            spUtil.ajax({
                url: '${request.contextPath}/productdata/productbom/item/list',
                type: 'GET',
                data: {bomId: bomId},
                success: function (result) {
                    if (result.code === 0) {
                        renderBomTree(result.data || []);
                    }
                }
            });
        }

        function renderBomTree(items) {
            var map = {};
            var roots = [];
            for (var i = 0; i < items.length; i++) {
                map[items[i].id] = items[i];
                items[i]._children = [];
            }
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (item.parentItemId && map[item.parentItemId]) {
                    map[item.parentItemId]._children.push(item);
                } else {
                    roots.push(item);
                }
            }
            var html = buildTreeHtml(roots, 1);
            $('#js-bom-tree-container').html(html || '<div style="padding:20px;text-align:center;color:#999;">暂无BOM子项，请点击"添加顶层子项"</div>');
        }

        function buildTreeHtml(nodes, level) {
            if (!nodes || nodes.length === 0) return '';
            var html = '';
            for (var i = 0; i < nodes.length; i++) {
                var n = nodes[i];
                var hasChildren = n._children && n._children.length > 0;
                var expandIcon = hasChildren ? '<span class="expand-icon" onclick="toggleChildren(this)"><i class="layui-icon">&#xe623;</i></span>' : '<span class="expand-icon">&nbsp;</span>';
                html += '<div class="bom-tree-node">';
                html += '<div class="bom-item-row">';
                html += '<span class="bom-item-level">L' + level + '</span>';
                html += expandIcon;
                html += '<span style="margin:0 8px;"><b>' + esc(n.partCode) + '</b></span>';
                html += '<span style="margin:0 8px;color:#666;">' + esc(n.partName || '') + '</span>';
                html += '<span style="margin:0 8px;">用量: ' + (n.qty || 1) + ' ' + esc(n.unit || '') + '</span>';
                if (n.scrapRate && n.scrapRate > 0) {
                    html += '<span style="margin:0 8px;color:#f0ad4e;">损耗: ' + n.scrapRate + '%</span>';
                }
                if (n.operCode) {
                    html += '<span style="margin:0 8px;color:#1890ff;">工序: ' + esc(n.operCode) + '</span>';
                }
                html += '<span class="bom-item-actions">';
                html += '<button class="layui-btn layui-btn-xs" onclick="addChildItem(\'' + n.id + '\',' + (level + 1) + ')"><i class="layui-icon">&#xe61f;</i>添加子项</button>';
                html += '<button class="layui-btn layui-btn-xs layui-btn-normal" onclick="editItem(\'' + n.id + '\')"><i class="layui-icon layui-icon-edit"></i>编辑</button>';
                html += '<button class="layui-btn layui-btn-xs layui-btn-danger" onclick="deleteItem(\'' + n.id + '\')"><i class="layui-icon layui-icon-delete"></i>删除</button>';
                html += '</span>';
                html += '</div>';
                if (hasChildren) {
                    html += '<div class="bom-children">';
                    html += buildTreeHtml(n._children, level + 1);
                    html += '</div>';
                }
                html += '</div>';
            }
            return html;
        }

        window.toggleChildren = function (el) {
            var $children = $(el).closest('.bom-tree-node').children('.bom-children');
            if ($children.hasClass('collapsed')) {
                $children.removeClass('collapsed');
                $(el).html('<i class="layui-icon">&#xe623;</i>');
            } else {
                $children.addClass('collapsed');
                $(el).html('<i class="layui-icon">&#xe625;</i>');
            }
        };

        window.addChildItem = function (parentItemId, level) {
            openItemForm(null, parentItemId, level);
        };

        window.editItem = function (itemId) {
            spUtil.ajax({
                url: '${request.contextPath}/productdata/productbom/item/list',
                type: 'GET',
                data: {bomId: bomId},
                success: function (result) {
                    if (result.code === 0) {
                        var items = result.data || [];
                        var item = null;
                        for (var i = 0; i < items.length; i++) {
                            if (items[i].id === itemId) { item = items[i]; break; }
                        }
                        if (item) openItemForm(item, item.parentItemId || '', item.levelNo);
                    }
                }
            });
        };

        window.deleteItem = function (itemId) {
            layer.confirm('确认删除该BOM子项？删除后其下级子项也将被删除。', function (index) {
                spUtil.ajax({
                    url: '${request.contextPath}/productdata/productbom/item/delete',
                    type: 'POST',
                    serializable: false,
                    data: {id: itemId},
                    success: function () {
                        loadBomItems();
                        layer.close(index);
                    }
                });
            });
        };

        function openItemForm(data, parentItemId, level) {
            var isEdit = !!data;
            var esc = function(s) { return s ? String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;') : ''; };
            var formHtml = '<div style="padding:20px;">' +
                '<form class="layui-form" lay-filter="js-item-form-filter" onsubmit="return false;">' +
                '<div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label sp-required">零部件</label><div class="layui-input-inline" style="width:180px;"><input type="text" id="js-item-part-code" name="partCode" readonly lay-verify="required" class="layui-input" value="' + esc(data ? data.partCode : '') + '" placeholder="点击搜索"></div><button type="button" id="js-item-btn-search-part" class="layui-btn layui-btn-sm"><i class="layui-icon layui-icon-search"></i></button></div></div>' +
                '<input type="hidden" id="js-item-part-id" name="partId" value="' + esc(data ? data.partId : '') + '">' +
                '<input type="hidden" id="js-item-part-name" name="partName" value="' + esc(data ? data.partName : '') + '">' +
                '<div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label">零部件名称</label><div class="layui-input-inline"><input type="text" id="js-item-part-name-show" readonly class="layui-input" value="' + esc(data ? data.partName : '') + '"></div></div></div>' +
                '<div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label sp-required">用量</label><div class="layui-input-inline"><input type="text" name="qty" lay-verify="required" class="layui-input" value="' + (data ? data.qty : '1') + '"></div></div><div class="layui-inline"><label class="layui-form-label">单位</label><div class="layui-input-inline"><input type="text" name="unit" class="layui-input" value="' + esc(data ? data.unit : '') + '"></div></div></div>' +
                '<div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label">行号</label><div class="layui-input-inline"><input type="text" name="lineNo" class="layui-input" value="' + (data ? data.lineNo : '10') + '"></div></div><div class="layui-inline"><label class="layui-form-label">层级</label><div class="layui-input-inline"><input type="text" name="levelNo" class="layui-input" value="' + (level || 1) + '" readonly></div></div></div>' +
                '<div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label">损耗率(%)</label><div class="layui-input-inline"><input type="text" name="scrapRate" class="layui-input" value="' + (data ? data.scrapRate : '0') + '"></div></div><div class="layui-inline"><label class="layui-form-label">关联工序编码</label><div class="layui-input-inline"><input type="text" name="operCode" class="layui-input" value="' + esc(data ? data.operCode : '') + '"></div></div></div>' +
                '<div class="layui-form-item"><label class="layui-form-label">备注</label><div class="layui-input-block"><textarea name="remark" class="layui-textarea">' + esc(data ? data.remark : '') + '</textarea></div></div>' +
                '<input type="hidden" name="bomId" value="' + bomId + '">' +
                '<input type="hidden" name="parentItemId" value="' + esc(parentItemId || '') + '">' +
                (isEdit ? '<input type="hidden" name="id" value="' + esc(data.id) + '">' : '') +
                '</form></div>';

            layer.open({
                type: 1,
                title: isEdit ? '编辑BOM子项' : '新增BOM子项',
                area: ['600px', '520px'],
                content: formHtml,
                success: function (layero, index) {
                    form.render(null, 'js-item-form-filter');
                    $(layero).find('#js-item-btn-search-part').click(function () {
                        spLayer.open({
                            type: 2,
                            area: ['680px', '500px'],
                            content: '${request.contextPath}/productdata/part/search-panel-ui',
                            reload: false,
                            close: true,
                            spCallback: function (result) {
                                if (result && result.code === 0 && result.data && result.data.length > 0) {
                                    var d = result.data[0];
                                    $(layero).find('#js-item-part-id').val(d.id);
                                    $(layero).find('#js-item-part-code').val(d.partCode);
                                    $(layero).find('#js-item-part-name').val(d.partName);
                                    $(layero).find('#js-item-part-name-show').val(d.partName);
                                }
                            }
                        });
                    });
                },
                btn: ['保存', '取消'],
                yes: function (index, layero) {
                    var $form = $(layero).find('form');
                    var formData = {};
                    $form.find('input, select, textarea').each(function () {
                        var $el = $(this);
                        var name = $el.attr('name');
                        if (!name) return;
                        formData[name] = $el.val();
                    });
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/productbom/item/add-or-update',
                        type: 'POST',
                        data: formData,
                        success: function (result) {
                            if (result.code === 0) {
                                loadBomItems();
                                layer.close(index);
                                layer.msg(isEdit ? '修改成功' : '新增成功');
                            }
                        }
                    });
                }
            });
        }

        $('#js-btn-add-root-item').click(function () {
            openItemForm(null, '', 1);
        });

        function esc(s) {
            if (!s) return '';
            return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }
    });
</script>
</body>
</html>
