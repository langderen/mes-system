<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产订单管理</title>
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
                        <button class="layui-btn" lay-submit lay-filter="js-add-order">新建生产订单</button>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderCode" class="layui-input" placeholder="请输入订单编号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">订单描述</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderDescription" class="layui-input" placeholder="请输入订单描述">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="statue">
                                <option value="">全部</option>
                                <option value="1">创建</option>
                                <option value="2">审批中</option>
                                <option value="3">审批通过</option>
                                <option value="4">已运算</option>
                                <option value="5">已结束</option>
                            </select>
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

<script type="text/html" id="js-status-tpl">
    {{# if(d.statue == 1){ }}
        <span>创建</span>
    {{# } else if(d.statue == 2){ }}
        <span>审批中</span>
    {{# } else if(d.statue == 3){ }}
        <span>审批通过</span>
    {{# } else if(d.statue == 4){ }}
        <span style="color:#67C23A;">已运算</span>
    {{# } else if(d.statue == 5){ }}
        <span>已结束</span>
    {{# } else { }}
        <span>-</span>
    {{# } }}
</script>

<script type="text/html" id="js-row-tool-tpl">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="approve">审批通过</a>
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="execute">运算</a>
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
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
            url: '${request.contextPath}/order/release/page',
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
            cols: [[
                {field: 'orderCode', title: '订单编号', minWidth: 160},
                {field: 'orderDescription', title: '订单描述', minWidth: 180},
                {field: 'materiel', title: '产品编码', minWidth: 120},
                {field: 'materielDesc', title: '产品名称', minWidth: 150},
                {field: 'qty', title: '数量', width: 90},
                {field: 'planStartTime', title: '计划开始', width: 160},
                {field: 'planEndTime', title: '计划结束', width: 160},
                {field: 'sourceOrderNo', title: '来源订单号', minWidth: 160},
                {field: 'generatedPlanNo', title: '生产计划号', minWidth: 160},
                {field: 'generatedMrpNo', title: 'MRP号', minWidth: 160},
                {field: 'statue', title: '状态', width: 100, templet: '#js-status-tpl'},
                {title: '操作', toolbar: '#js-row-tool-tpl', width: 260}
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

        form.on('submit(js-add-order)', function () {
            openEdit();
            return false;
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var row = obj.data;
            if (obj.event === 'edit') {
                openEdit(row.id);
            } else if (obj.event === 'approve') {
                approveOrder(row.id);
            } else if (obj.event === 'execute') {
                executeOrder(row.id);
            } else if (obj.event === 'delete') {
                layer.confirm('确认删除该订单吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/order/release/delete',
                        type: 'POST',
                        data: { id: row.id },
                        success: function (result) {
                            if (result.code === 0) {
                                table.reload('js-record-table');
                            }
                            layer.close(index);
                        }
                    });
                });
            }
        });

        function openEdit(id) {
            spLayer.open({
                title: id ? '编辑生产订单' : '新建生产订单',
                type: 2,
                area: ['720px', '680px'],
                content: '${request.contextPath}/order/release/add-or-update-ui' + (id ? '?id=' + id : ''),
                reload: false,
                spCallback: function (result) {
                    if (result && result.code === 0) {
                        table.reload('js-record-table');
                    }
                }
            });
        }

        function approveOrder(id) {
            spUtil.ajax({
                url: '${request.contextPath}/order/release/approve',
                type: 'POST',
                data: { id: id },
                success: function (result) {
                    layer.msg(result.msg || '操作成功');
                    if (result.code === 0) {
                        table.reload('js-record-table');
                    }
                }
            });
        }

        function executeOrder(id) {
            spUtil.ajax({
                url: '${request.contextPath}/order/release/execute',
                type: 'POST',
                data: { id: id },
                success: function (result) {
                    layer.msg(result.msg || '操作成功');
                    if (result.code === 0) {
                        table.reload('js-record-table');
                    }
                }
            });
        }
    });
</script>
</body>
</html>
