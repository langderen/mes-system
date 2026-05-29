<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>人员作业派工</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .dispatch-container { display: flex; height: 100%; gap: 15px; }
        .dispatch-left { flex: 1; border: 1px solid #e6e6e6; border-radius: 4px; overflow: hidden; }
        .dispatch-left-header { padding: 12px 16px; font-weight: 600; font-size: 14px; border-bottom: 1px solid #e6e6e6; background: #fafafa; }
        .dispatch-left-body { padding: 15px; overflow-y: auto; }
        .dispatch-right { flex: 1.5; border: 1px solid #e6e6e6; border-radius: 4px; overflow: hidden; }
        .dispatch-right-header { padding: 12px 16px; font-weight: 600; font-size: 14px; border-bottom: 1px solid #e6e6e6; background: #fafafa; }
        .unit-card { margin-bottom: 10px; border: 1px solid #e6e6e6; border-radius: 4px; overflow: hidden; }
        .unit-header { padding: 10px 15px; background: #f0f7ff; cursor: pointer; font-weight: 500; font-size: 13px; }
        .unit-header:hover { background: #e6f0ff; }
        .unit-body { display: none; padding: 5px 0; }
        .unit-body.show { display: block; }
        .member-item { padding: 8px 15px; cursor: pointer; font-size: 13px; transition: background .15s; border-bottom: 1px solid #f0f0f0; }
        .member-item:hover { background: #f5f7fa; }
        .member-item.active { background: #ecf5ff; color: #1e9fff; border-left: 3px solid #1e9fff; }
        .member-item .member-info { display: flex; justify-content: space-between; }
        .member-item .member-name { font-weight: 500; }
        .info-row { display: flex; margin-bottom: 10px; }
        .info-label { width: 80px; color: #666; font-size: 13px; }
        .info-value { flex: 1; font-size: 13px; color: #333; }
        .no-member { padding: 8px 15px; font-size: 12px; color: #999; }
    </style>
</head>
<body>
<div class="splayui-container" style="padding:0; height:100%;">
    <div class="dispatch-container">
        <div class="dispatch-left">
            <div class="dispatch-left-header">工单信息</div>
            <div class="dispatch-left-body" id="js-order-info"></div>
        </div>
        <div class="dispatch-right">
            <div class="dispatch-right-header">
                选择作业员
                <span style="float:right; font-weight:normal; font-size:12px; color:#999;">按加工单元展开</span>
            </div>
            <div style="padding:15px;">
                <div id="js-unit-list"></div>
            </div>
            <div style="padding:15px; border-top:1px solid #e6e6e6; background:#fafafa;">
                <form class="layui-form" lay-filter="js-dispatch-form">
                    <input type="hidden" name="orderId" value="${orderId!}">
                    <div class="layui-form-item">
                        <label class="layui-form-label">派工数量</label>
                        <div class="layui-input-block">
                            <input type="number" name="qty" class="layui-input" placeholder="请输入派工数量" lay-verify="required|number|positive">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" lay-submit lay-filter="js-submit">确认派工</button>
                            <button type="button" class="layui-btn layui-btn-primary" onclick="parent.layer.closeAll()">取消</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    var orderId = '${orderId!}';
    var selectedUserId = '';
    var selectedProcessUnitId = '';
    var selectedUserInfo = null;
    var orderData = null;

    layui.use(['form', 'layer', 'util'], function () {
        var form = layui.form,
            layer = layui.layer,
            util = layui.util;

        if (!orderId) {
            layer.msg('参数错误', {icon: 2});
            return;
        }

        loadOrderInfo();
        loadProcessUnits();

        form.verify({
            positive: function(value) {
                if (value <= 0) {
                    return '派工数量必须大于0';
                }
            }
        });

        form.on('submit(js-submit)', function (data) {
            if (!selectedUserId) {
                layer.msg('请选择作业员', {icon: 2});
                return false;
            }

            data.field.userId = selectedUserId;
            data.field.processUnitId = selectedProcessUnitId;

            spUtil.ajax({
                url: '${request.contextPath}/production/dispatch/person-dispatch',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data.field),
                success: function (result) {
                    if (result.code === 0) {
                        window.spChildFrameResult = result;
                        parent.layer.closeAll();
                    }
                }
            });

            return false;
        });
    });

    function loadOrderInfo() {
        spUtil.ajax({
            url: '${request.contextPath}/production/dispatch/get',
            type: 'GET',
            data: { id: orderId },
            success: function (result) {
                if (result.code === 0 && result.data) {
                    orderData = result.data;
                    renderOrderInfo(orderData);
                    $('input[name="qty"]').val(orderData.qty);
                }
            }
        });
    }

    function renderOrderInfo(order) {
        var statusMap = { 'draft': '已下发', 'assigned': '已派工', 'started': '已开工', 'completed': '已完工', 'inspected': '待检验', 'scrapped': '废补' };
        var priorityMap = { 1: '高', 2: '中', 3: '低' };

        var html = '';
        html += '<div class="info-row"><span class="info-label">工单号</span><span class="info-value">' + (order.orderNo || '') + '</span></div>';
        html += '<div class="info-row"><span class="info-label">产品编码</span><span class="info-value">' + (order.productCode || '') + '</span></div>';
        html += '<div class="info-row"><span class="info-label">产品名称</span><span class="info-value">' + (order.productName || '') + '</span></div>';
        html += '<div class="info-row"><span class="info-label">计划数量</span><span class="info-value">' + (order.qty || 0) + '</span></div>';
        html += '<div class="info-row"><span class="info-label">完成数量</span><span class="info-value">' + (order.completedQty || 0) + '</span></div>';
        html += '<div class="info-row"><span class="info-label">优先级</span><span class="info-value">' + (priorityMap[order.priority] || '-') + '</span></div>';
        html += '<div class="info-row"><span class="info-label">状态</span><span class="info-value">' + (statusMap[order.status] || order.status) + '</span></div>';
        html += '<div class="info-row"><span class="info-label">计划开始</span><span class="info-value">' + (order.planStartTime || '') + '</span></div>';
        html += '<div class="info-row"><span class="info-label">计划结束</span><span class="info-value">' + (order.planEndTime || '') + '</span></div>';

        $('#js-order-info').html(html);
    }

    function loadProcessUnits() {
        spUtil.ajax({
            url: '${request.contextPath}/production/dispatch/process-units',
            type: 'GET',
            success: function (result) {
                if (result.code === 0) {
                    var units = result.data || [];
                    var html = '';
                    for (var i = 0; i < units.length; i++) {
                        var unit = units[i];
                        html += '<div class="unit-card">';
                        html += '<div class="unit-header" onclick="toggleUnit(this, \'' + unit.id + '\')">';
                        html += '▶ ' + (unit.name || unit.code) + (unit.groupName ? ' (' + unit.groupName + ')' : '');
                        html += '</div>';
                        html += '<div class="unit-body" id="js-unit-' + unit.id + '"></div>';
                        html += '</div>';
                    }
                    if (units.length === 0) {
                        html = '<div style="text-align:center; padding:20px; color:#999;">暂无加工单元</div>';
                    }
                    $('#js-unit-list').html(html);
                }
            }
        });
    }

    function toggleUnit(header, unitId) {
        var body = $(header).next();
        if (body.hasClass('show')) {
            body.removeClass('show');
            var text = $(header).text();
            $(header).text(text.replace('▼', '▶'));
        } else {
            body.addClass('show');
            var text = $(header).text();
            $(header).text(text.replace('▶', '▼'));
            if ($.trim(body.html()) === '') {
                loadGroupUsers(unitId, body);
            }
        }
    }

    function loadGroupUsers(processUnitId, container) {
        container.html('<div class="no-member">加载中...</div>');
        spUtil.ajax({
            url: '${request.contextPath}/production/dispatch/group-users',
            type: 'GET',
            data: { processUnitId: processUnitId },
            success: function (result) {
                if (result.code === 0) {
                    var users = result.data || [];
                    renderMembers(container, users, processUnitId);
                } else {
                    container.html('<div class="no-member">加载失败</div>');
                }
            }
        });
    }

    function renderMembers(container, users, processUnitId) {
        if (users.length === 0) {
            container.html('<div class="no-member">该加工单元暂无班组人员</div>');
            return;
        }

        var html = '';
        for (var i = 0; i < users.length; i++) {
            var user = users[i];
            html += '<div class="member-item" onclick="selectMember(\'' + user.userId + '\', \'' + processUnitId + '\', ' + JSON.stringify(user).replace(/"/g, '&quot;') + ')">';
            html += '<div class="member-info">';
            html += '<span class="member-name">' + (user.userName || '') + ' (' + (user.username || '') + ')</span>';
            html += '</div>';
            html += '</div>';
        }
        container.html(html);
    }

    function selectMember(userId, processUnitId, userInfo) {
        selectedUserId = userId;
        selectedProcessUnitId = processUnitId;
        selectedUserInfo = userInfo;

        $('.member-item').removeClass('active');
        event.currentTarget.classList.add('active');
    }
</script>
</body>
</html>