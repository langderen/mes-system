<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .status-draft { color: #909399; }
        .status-assigned { color: #E6A23C; }
        .status-started { color: #409EFF; }
        .status-completed { color: #67C23A; }
        .status-inspected { color: #909399; }
        .status-scrapped { color: #F56C6C; }
        .priority-high { color: #F56C6C; }
        .priority-medium { color: #E6A23C; }
        .priority-low { color: #67C23A; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="layui-form" lay-filter="js-search-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">工单号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderNo" class="layui-input" placeholder="请输入工单号">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">产品编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productCode" class="layui-input" placeholder="请输入产品编码">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="">全部</option>
                                <option value="draft">已下发</option>
                                <option value="assigned">已派工</option>
                                <option value="started">已开工</option>
                                <option value="completed">已完工</option>
                                <option value="inspected">待检验</option>
                                <option value="scrapped">废补</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn" lay-submit lay-filter="js-search">查询</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
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

<script type="text/html" id="js-priority-tpl">
    {{# if(d.priority == 1){ }}
        <span class="priority-high">高</span>
    {{# } else if(d.priority == 2){ }}
        <span class="priority-medium">中</span>
    {{# } else { }}
        <span class="priority-low">低</span>
    {{# } }}
</script>

<script type="text/html" id="js-status-tpl">
    {{# if(d.status == 'draft'){ }}
        <span class="status-draft">已下发</span>
    {{# } else if(d.status == 'assigned'){ }}
        <span class="status-assigned">已派工</span>
    {{# } else if(d.status == 'started'){ }}
        <span class="status-started">已开工</span>
    {{# } else if(d.status == 'completed'){ }}
        <span class="status-completed">已完工</span>
    {{# } else if(d.status == 'inspected'){ }}
        <span class="status-inspected">待检验</span>
    {{# } else if(d.status == 'scrapped'){ }}
        <span class="status-scrapped">废补</span>
    {{# } }}
</script>

<script type="text/html" id="js-toolbar-tpl">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="personDispatch">人员作业派工</button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="viewRecords">查看派工记录</button>
    </div>
</script>

<script type="text/html" id="js-row-tool-tpl">
    <a class="layui-btn layui-btn-xs" lay-event="personDispatch">人员派工</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="viewRecords">派工记录</a>
</script>

<script>
    layui.use(['table', 'form', 'layer', 'util', 'spLayer'], function () {
        var table = layui.table,
            form = layui.form,
            layer = layui.layer,
            util = layui.util,
            spLayer = layui.spLayer;

        var selectedRows = [];

        table.render({
            elem: '#js-record-table',
            id: 'js-record-table',
            url: '${request.contextPath}/production/dispatch/page',
            method: 'GET',
            request: { pageName: 'current', limitName: 'size' },
            parseData: function (res) {
                return {
                    "code": res.code,
                    "msg": res.msg,
                    "count": res.data.total,
                    "data": res.data.records
                };
            },
            toolbar: '#js-toolbar-tpl',
            defaultToolbar: ['filter', 'exports', 'print'],
            cols: [[
                {type: 'checkbox'},
                {field: 'orderNo', title: '工单号', minWidth: 150},
                {field: 'productCode', title: '产品编码', minWidth: 120},
                {field: 'productName', title: '产品名称', minWidth: 150},
                {field: 'qty', title: '计划数量', width: 100},
                {field: 'completedQty', title: '完成数量', width: 100},
                {field: 'qualifiedQty', title: '合格数量', width: 100},
                {field: 'scrapQty', title: '报废数量', width: 100},
                {field: 'priority', title: '优先级', width: 80, templet: '#js-priority-tpl'},
                {field: 'status', title: '状态', width: 100, templet: '#js-status-tpl'},
                {field: 'planStartTime', title: '计划开始时间', width: 160},
                {field: 'planEndTime', title: '计划结束时间', width: 160},
                {field: 'actualStartTime', title: '实际开始时间', width: 160},
                {field: 'actualEndTime', title: '实际结束时间', width: 160},
                {title: '操作', toolbar: '#js-row-tool-tpl', width: 200}
            ]],
            page: true,
            limit: 20,
            limits: [20, 50, 100],
            height: 'full-120'
        });

        form.on('submit(js-search)', function (data) {
            table.reload('js-record-table', {
                where: data.field,
                page: { curr: 1 }
            });
            return false;
        });

        table.on('checkbox(js-record-table-filter)', function (obj) {
            var checkStatus = table.checkStatus('js-record-table');
            selectedRows = checkStatus.data;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            selectedRows = table.checkStatus('js-record-table').data || [];
            if (selectedRows.length === 0) {
                layer.msg('请先选择工单', {icon: 2});
                return;
            }

            if (obj.event === 'personDispatch') {
                if (selectedRows.length > 1) {
                    layer.msg('人员作业派工只能选择一个工单', {icon: 2});
                    return;
                }
                openPersonDispatch(selectedRows[0]);
            } else if (obj.event === 'viewRecords') {
                showDispatchRecords(selectedRows[0].id);
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var order = obj.data;
            if (obj.event === 'personDispatch') {
                openPersonDispatch(order);
            } else if (obj.event === 'viewRecords') {
                showDispatchRecords(order.id);
            }
        });

        function openPersonDispatch(order) {
            if (order.status === 'started' || order.status === 'completed') {
                layer.msg('当前工单状态不允许派工', {icon: 2});
                return;
            }
            spLayer.open({
                title: '人员作业派工 - ' + order.orderNo,
                type: 2,
                area: ['900px', '600px'],
                spWhere: { orderId: order.id },
                content: '${request.contextPath}/production/dispatch/dispatch-ui',
                reload: false,
                close: true,
                spCallback: function (result) {
                    if (result && result.code === 0) {
                        table.reload('js-record-table');
                    }
                }
            });
        }

        function showDispatchRecords(orderId) {
            spUtil.ajax({
                url: '${request.contextPath}/production/dispatch/records',
                type: 'GET',
                data: { orderId: orderId },
                success: function (result) {
                    if (result.code === 0) {
                        var records = result.data || [];
                        if (records.length === 0) {
                            layer.msg('该工单暂无派工记录', {icon: 0});
                            return;
                        }
                        var html = '<table class="layui-table" lay-skin="line">';
                        html += '<thead><tr><th>派工时间</th><th>加工单元</th><th>作业员</th><th>计划数量</th><th>完成数量</th><th>合格数量</th><th>报废数量</th><th>工时</th><th>状态</th></tr></thead>';
                        html += '<tbody>';
                        var statusMap = { 'pending': '待开工', 'started': '已开工', 'completed': '已完成', 'scrapped': '已报废' };
                        for (var i = 0; i < records.length; i++) {
                            var r = records[i];
                            html += '<tr>';
                            html += '<td>' + (r.dispatchTime || '') + '</td>';
                            html += '<td>' + (r.processUnitName || '-') + '</td>';
                            html += '<td>' + (r.operatorName || '-') + '</td>';
                            html += '<td>' + (r.planQty || 0) + '</td>';
                            html += '<td>' + (r.completedQty || 0) + '</td>';
                            html += '<td>' + (r.qualifiedQty || 0) + '</td>';
                            html += '<td>' + (r.scrapQty || 0) + '</td>';
                            html += '<td>' + (r.workHours || 0) + '</td>';
                            html += '<td>' + (statusMap[r.status] || r.status) + '</td>';
                            html += '</tr>';
                        }
                        html += '</tbody></table>';
                        layer.open({
                            type: 1,
                            title: '派工记录',
                            area: ['90%', '90%'],
                            content: '<div style="padding:20px;">' + html + '</div>'
                        });
                    }
                }
            });
        }
    });
</script>
</body>
</html>
