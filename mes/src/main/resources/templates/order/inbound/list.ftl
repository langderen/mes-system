<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>计划入库管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="js-search-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">入库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="inboundNo" class="layui-input" placeholder="请输入入库单号">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">来源MRP</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sourceMrpNos" class="layui-input" placeholder="请输入来源MRP编号">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="draft">待登账</option>
                            <option value="confirmed">已登账</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="js-search-filter">查询</button>
                </div>
            </div>
        </form>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="confirm">登账</a>
</script>

<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        var tableIns = spTable.render({
            url: '${request.contextPath}/order/inbound/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'inboundNo', title: '入库单号', minWidth: 160},
                {field: 'sourceMrpNos', title: '来源MRP', minWidth: 220},
                {field: 'itemCount', title: '明细数', width: 90},
                {field: 'totalDemandQty', title: '总需求量', width: 100},
                {
                    field: 'status',
                    title: '状态',
                    width: 100,
                    templet: function (d) {
                        var map = {'draft': '待登账', 'confirmed': '已登账'};
                        return map[d.status] || d.status;
                    }
                },
                {field: 'createTime', title: '创建时间', width: 170},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 150}
            ]],
            page: true,
            limit: 20,
            limits: [20, 50, 100],
            height: 'full-120'
        });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'detail') {
                spLayer.open({
                    title: '入库单详情',
                    type: 2,
                    area: ['900px', '640px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/order/inbound/detail-ui',
                    reload: false
                });
            } else if (obj.event === 'confirm') {
                openConfirmDialog(data);
            }
        });

        function openConfirmDialog(row) {
            spUtil.ajax({
                url: '${request.contextPath}/order/inbound/warehouse-list',
                type: 'GET',
                success: function (result) {
                    var warehouses = (result.code === 0 && result.data) ? result.data : [];
                    var warehouseOptions = '<option value="">请选择库房</option>';
                    for (var i = 0; i < warehouses.length; i++) {
                        warehouseOptions += '<option value="' + warehouses[i].id + '">' + (warehouses[i].name || warehouses[i].code || '') + '</option>';
                    }

                    var html = ''
                        + '<div style="padding:20px;">'
                        + '<form class="layui-form" lay-filter="js-inbound-confirm-form">'
                        + '<div class="layui-form-item">'
                        + '<label class="layui-form-label sp-required">库房</label>'
                        + '<div class="layui-input-inline">'
                        + '<select name="warehouseId" id="js-confirm-warehouse-id" lay-filter="js-confirm-warehouse-filter" lay-verify="required">'
                        + warehouseOptions
                        + '</select>'
                        + '</div>'
                        + '</div>'
                        + '<div class="layui-form-item">'
                        + '<label class="layui-form-label">推荐库位</label>'
                        + '<div class="layui-input-block" id="js-location-hint" style="color:#999;">请选择库房后自动推荐空余库位</div>'
                        + '</div>'
                        + '<div class="layui-form-item">'
                        + '<label class="layui-form-label sp-required">库位</label>'
                        + '<div class="layui-input-block" id="js-location-box" style="max-height:180px;overflow:auto;border:1px solid #eee;padding:10px;">'
                        + '<span style="color:#999;">请选择库房</span>'
                        + '</div>'
                        + '</div>'
                        + '</form>'
                        + '</div>';

                    layer.open({
                        type: 1,
                        title: '入库登账',
                        area: ['740px', '520px'],
                        content: html,
                        success: function () {
                            form.render('select');
                            form.on('select(js-confirm-warehouse-filter)', function (data) {
                                loadLocationCandidates(data.value, row.totalDemandQty);
                            });
                        },
                        btn: ['确认登账', '取消'],
                        yes: function (index) {
                            var warehouseId = $('#js-confirm-warehouse-id').val();
                            var selected = [];
                            $('#js-location-box input[name="locationIds"]:checked').each(function () {
                                selected.push($(this).val());
                            });
                            if (!warehouseId) {
                                layer.msg('请选择库房');
                                return;
                            }
                            if (!selected.length) {
                                layer.msg('请选择库位');
                                return;
                            }
                            spUtil.ajax({
                                url: '${request.contextPath}/order/inbound/confirm',
                                type: 'POST',
                                data: {
                                    id: row.id,
                                    warehouseId: warehouseId,
                                    warehouseLocationId: selected.join(',')
                                },
                                success: function (resp) {
                                    layer.msg(resp.msg || '操作成功');
                                    if (resp.code === 0) {
                                        tableIns.reload();
                                        layer.close(index);
                                    }
                                }
                            });
                        }
                    });
                }
            });
        }

        function loadLocationCandidates(warehouseId, needQty) {
            spUtil.ajax({
                url: '${request.contextPath}/order/inbound/warehouse-location-suggest',
                type: 'GET',
                data: {warehouseId: warehouseId, demandQty: needQty},
                success: function (result) {
                    var box = $('#js-location-box');
                    if (result.code !== 0 || !result.data) {
                        box.html('<span style="color:#999;">暂无可用库位</span>');
                        $('#js-location-hint').text('未找到可用库位');
                        return;
                    }

                    var candidates = result.data.candidates || [];
                    var html = '';
                    for (var i = 0; i < candidates.length; i++) {
                        var item = candidates[i];
                        html += '<div style="margin-bottom:8px;">'
                            + '<label>'
                            + '<input type="checkbox" name="locationIds" value="' + item.id + '">'
                            + ' ' + (item.code || '') + ' ' + (item.name || '')
                            + ' <span style="color:#999;">(free ' + item.freeCapacity + ' / max ' + item.maxCapacity + ' / current ' + item.currentInventory + ')</span>'
                            + '</label>'
                            + '</div>';
                    }
                    if (!html) {
                        html = '<span style="color:#999;">暂无空余库位</span>';
                    }
                    box.html(html);
                    $('#js-location-hint').text(result.data.canFulfill ? '当前库位可满足需求，建议按顺序勾选' : '空余库位不足，建议调整库房或拆分登账');
                }
            });
        }
    });
</script>
</body>
</html>
