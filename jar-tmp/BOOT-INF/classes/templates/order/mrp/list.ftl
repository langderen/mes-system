<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料需求计划</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="layui-form" lay-filter="js-search-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">MRP编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="mrpNo" class="layui-input" placeholder="请输入MRP编号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderCode" class="layui-input" placeholder="请输入订单编号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">物料编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="partCode" class="layui-input" placeholder="请输入物料编码">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">物料名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="partName" class="layui-input" placeholder="请输入物料名称">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn" lay-submit lay-filter="js-search-filter">查询</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="layui-card">
        <div class="layui-card-body">
            <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        </div>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="generate"><i class="layui-icon">&#xe654;</i>批量生成入库单</button>
    </div>
</script>

<script type="text/html" id="js-row-tool-tpl">
    <a class="layui-btn layui-btn-xs" lay-event="detail">查看</a>
</script>

<script>
    layui.use(['table', 'form', 'layer', 'spLayer'], function () {
        var table = layui.table,
            form = layui.form,
            layer = layui.layer,
            spLayer = layui.spLayer;

        table.render({
            elem: '#js-record-table',
            id: 'js-record-table',
            url: '${request.contextPath}/order/mrp/page',
            method: 'GET',
            request: { pageName: 'current', limitName: 'size' },
            parseData: function (res) {
                return {
                    code: res.code,
                    msg: res.msg,
                    count: res.data.total,
                    data: res.data.records
                };
            },
            toolbar: '#js-record-table-toolbar-top',
            defaultToolbar: ['filter', 'exports', 'print'],
            cols: [[
                {type: 'checkbox'},
                {field: 'mrpNo', title: 'MRP编号', minWidth: 160},
                {field: 'orderCode', title: '来源订单号', minWidth: 150},
                {field: 'bomCode', title: 'BOM编号', minWidth: 140},
                {field: 'productCode', title: '产品编码', minWidth: 120},
                {field: 'productName', title: '产品名称', minWidth: 150},
                {field: 'partCode', title: '物料编码', minWidth: 120},
                {field: 'partName', title: '物料名称', minWidth: 150},
                {field: 'demandQty', title: '需求数量', width: 100},
                {field: 'unit', title: '单位', width: 80},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', toolbar: '#js-row-tool-tpl', width: 100}
            ]],
            page: true,
            limit: 20,
            limits: [20, 50, 100],
            height: 'full-120'
        });

        form.on('submit(js-search-filter)', function (data) {
            table.reload('js-record-table', {
                where: data.field,
                page: { curr: 1 }
            });
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'generate') {
                var checked = table.checkStatus('js-record-table').data || [];
                if (!checked.length) {
                    layer.msg('请先勾选要生成入库单的物料需求');
                    return;
                }
                var ids = [];
                for (var i = 0; i < checked.length; i++) {
                    ids.push(checked[i].id);
                }
                layer.confirm('确认根据所选物料需求生成计划入库单？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/order/inbound/generate',
                        type: 'POST',
                        data: { mrpIds: ids.join(',') },
                        success: function (result) {
                            layer.msg(result.msg || '操作成功');
                            if (result.code === 0) {
                                table.reload('js-record-table');
                            }
                        }
                    });
                    layer.close(index);
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            if (obj.event === 'detail') {
                console.log('MRP详情 - 数据:', obj.data);
                console.log('MRP详情 - ID:', obj.data.id);
                if (!obj.data.id) {
                    layer.msg('数据异常：MRP记录ID为空');
                    return;
                }
                spLayer.open({
                    title: 'MRP详情',
                    type: 2,
                    area: ['820px', '600px'],
                    content: '${request.contextPath}/order/mrp/detail-ui?id=' + obj.data.id,
                    reload: false
                });
            }
        });
    });
</script>
</body>
</html>
