<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库房编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="layui-tab layui-tab-brief" lay-filter="js-tab-filter">
            <ul class="layui-tab-title">
                <li class="layui-this">库房信息</li>
                <li>库位列表</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form splayui-form" lay-filter="js-wh-form-filter">
                        <div class="layui-form-item">
                            <label for="js-code" class="layui-form-label sp-required">库房编码</label>
                            <div class="layui-input-inline">
                                <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${warehouse.code!}">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label for="js-name" class="layui-form-label sp-required">库房名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${warehouse.name!}">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label for="js-type" class="layui-form-label sp-required">库房类型</label>
                            <div class="layui-input-inline">
                                <select id="js-type" name="type" lay-verify="required">
                                    <option value="">请选择</option>
                                    <option value="原料仓" <#if warehouse?? && warehouse.type == "原料仓">selected</#if>>原料仓</option>
                                    <option value="半成品仓" <#if warehouse?? && warehouse.type == "半成品仓">selected</#if>>半成品仓</option>
                                    <option value="成品仓" <#if warehouse?? && warehouse.type == "成品仓">selected</#if>>成品仓</option>
                                    <option value="线边仓" <#if warehouse?? && warehouse.type == "线边仓">selected</#if>>线边仓</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label for="js-address" class="layui-form-label">库房地址</label>
                            <div class="layui-input-inline">
                                <input type="text" id="js-address" name="address" autocomplete="off" class="layui-input" value="${warehouse.address!}">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label for="js-wh-status" class="layui-form-label sp-required">库房状态</label>
                            <div class="layui-input-block" id="js-wh-status">
                                <input type="radio" name="status" value="0" title="正常" <#if !warehouse?? || warehouse.status == "0">checked</#if>>
                                <input type="radio" name="status" value="1" title="停用" <#if warehouse?? && warehouse.status == "1">checked</#if>>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label for="js-descr" class="layui-form-label">描述</label>
                            <div class="layui-input-inline">
                                <input type="text" id="js-descr" name="descr" autocomplete="off" class="layui-input" value="${warehouse.descr!}">
                            </div>
                        </div>

                        <div class="layui-form-item layui-hide">
                            <div class="layui-input-block">
                                <input id="js-id" name="id" value="${warehouse.id!}"/>
                                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-wh-submit-filter">确定</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="layui-tab-item">
                    <div id="js-location-panel" style="display:none;">
                        <div class="layui-btn-container" style="margin-bottom:10px;">
                            <button class="layui-btn layui-btn-sm" id="js-btn-add-location"><i class="layui-icon">&#xe61f;</i>新增库位</button>
                        </div>
                        <table class="layui-hide" id="js-location-table" lay-filter="js-location-table-filter"></table>
                    </div>
                    <div id="js-no-warehouse-tip" style="padding:40px;text-align:center;color:#999;">
                        <i class="layui-icon" style="font-size:48px;">&#xe61f;</i>
                        <p style="margin-top:10px;">请先保存库房信息后，再管理库位</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="js-location-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    var warehouseId = '${warehouse.id!}';

    layui.use(['form', 'table', 'element', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            element = layui.element,
            spTable = layui.spTable;
        var locationTableIns = null;

        form.render();

        if (warehouseId) {
            $('#js-location-panel').show();
            $('#js-no-warehouse-tip').hide();
            initLocationTable();
        }

        form.on('submit(js-wh-submit-filter)', function (data) {
            spUtil.submitForm({
                url: '${request.contextPath}/warehouse/warehouse/add-or-update',
                data: data.field
            });
            return false;
        });

        $('#js-btn-add-location').on('click', function () {
            openLocationForm(null);
        });

        table.on('tool(js-location-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                openLocationForm(data);
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除该库位吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/warehouse/warehouse/location/delete',
                        type: 'POST',
                        data: { id: data.id },
                        success: function (result) {
                            if (result.code === 0) {
                                locationTableIns.reload();
                                layer.msg('删除成功');
                            }
                        }
                    });
                    layer.close(index);
                });
            }
        });

        function initLocationTable() {
            if (locationTableIns) return;
            locationTableIns = spTable.render({
                elem: '#js-location-table',
                toolbar: false,
                url: '${request.contextPath}/warehouse/warehouse/location/page',
                where: { warehouseId: warehouseId },
                cols: [[
                    { field: 'code', title: '库位编码', width: 120 },
                    { field: 'name', title: '库位名称', width: 120 },
                    { field: 'rowNo', title: '行号', width: 70 },
                    { field: 'colNo', title: '列号', width: 70 },
                    { field: 'locationType', title: '库位类型', width: 110 },
                    { field: 'maxCapacity', title: '最大容量', width: 100 },
                    { field: 'currentInventory', title: '当前库存', width: 100 },
                    { field: 'status', title: '库位状态', width: 100, templet: function (d) {
                        var dict = { '0': '空闲', '1': '使用中', '2': '已满', '3': '超储' };
                        return dict[d.status] || d.status;
                    }},
                    { fixed: 'right', title: '操作', toolbar: '#js-location-table-toolbar-right', unresize: true, width: 150 }
                ]],
                page: true
            });
        }

        function openLocationForm(data) {
            var isEdit = !!data;
            var esc = function(s) { return s ? String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;') : ''; };
            var formHtml = '<div style="padding:20px;">' +
                '<form class="layui-form" lay-filter="js-loc-form-filter" onsubmit="return false;">' +
                '<div class="layui-form-item layui-hide">' +
                '<input name="id" value="' + esc(isEdit ? data.id : '') + '"/>' +
                '<input name="warehouseId" value="' + esc(warehouseId) + '"/>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label sp-required">库位编码</label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" name="code" lay-verify="required" class="layui-input" value="' + esc(isEdit ? data.code : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">库位名称</label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" name="name" class="layui-input" value="' + esc(isEdit ? (data.name || '') : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label sp-required">行号</label>' +
                '<div class="layui-input-inline">' +
                '<input type="number" name="rowNo" lay-verify="required" class="layui-input" value="' + (isEdit ? data.rowNo : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label sp-required">列号</label>' +
                '<div class="layui-input-inline">' +
                '<input type="number" name="colNo" lay-verify="required" class="layui-input" value="' + (isEdit ? data.colNo : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">库位类型</label>' +
                '<div class="layui-input-inline">' +
                '<select name="locationType">' +
                '<option value="">请选择</option>' +
                '<option value="存储位"' + (isEdit && data.locationType == '存储位' ? ' selected' : '') + '>存储位</option>' +
                '<option value="暂存位"' + (isEdit && data.locationType == '暂存位' ? ' selected' : '') + '>暂存位</option>' +
                '<option value="检验位"' + (isEdit && data.locationType == '检验位' ? ' selected' : '') + '>检验位</option>' +
                '<option value="不良品位"' + (isEdit && data.locationType == '不良品位' ? ' selected' : '') + '>不良品位</option>' +
                '</select>' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">最大容量</label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" name="maxCapacity" class="layui-input" value="' + esc(isEdit ? (data.maxCapacity || '') : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">当前库存</label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" name="currentInventory" class="layui-input" value="' + (isEdit ? (data.currentInventory || '') : '') + '">' +
                '</div></div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label sp-required">库位状态</label>' +
                '<div class="layui-input-block">' +
                '<input type="radio" name="status" value="0" title="空闲"' + (!isEdit || data.status == '0' ? ' checked' : '') + '>' +
                '<input type="radio" name="status" value="1" title="使用中"' + (isEdit && data.status == '1' ? ' checked' : '') + '>' +
                '<input type="radio" name="status" value="2" title="已满"' + (isEdit && data.status == '2' ? ' checked' : '') + '>' +
                '<input type="radio" name="status" value="3" title="超储"' + (isEdit && data.status == '3' ? ' checked' : '') + '>' +
                '</div></div>' +
                '</form></div>';

            layer.open({
                type: 1,
                title: isEdit ? '编辑库位' : '新增库位',
                area: ['500px', '520px'],
                content: formHtml,
                success: function (layero, index) {
                    form.render('radio');
                    form.render('select');
                },
                btn: ['保存', '取消'],
                yes: function (index, layero) {
                    var $form = $(layero).find('form');
                    var formData = {};
                    $form.find('input, select').each(function () {
                        var $el = $(this);
                        var name = $el.attr('name');
                        if (!name) return;
                        if ($el.attr('type') === 'radio') {
                            if ($el.is(':checked')) {
                                formData[name] = $el.val();
                            }
                        } else {
                            formData[name] = $el.val();
                        }
                    });
                    spUtil.ajax({
                        url: '${request.contextPath}/warehouse/warehouse/location/add-or-update',
                        type: 'POST',
                        data: formData,
                        success: function (result) {
                            if (result.code === 0) {
                                if (locationTableIns) {
                                    locationTableIns.reload();
                                }
                                layer.close(index);
                                layer.msg(isEdit ? '修改成功' : '新增成功');
                            }
                        }
                    });
                }
            });
        }
    });
</script>
</body>
</html>