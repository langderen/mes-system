<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检分配</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .unit-card {border:1px solid #e2e2e2;border-radius:4px;margin:0 15px 10px 0;display:inline-block;vertical-align:top;width:260px;}
        .unit-header {background:#f2f2f2;padding:10px 12px;cursor:pointer;font-weight:bold;}
        .unit-body {display:none;padding:8px 12px;max-height:300px;overflow-y:auto;}
        .member-item {padding:6px 8px;cursor:pointer;border-bottom:1px dotted #eee;}
        .member-item:hover {background:#e6f7ff;}
        .member-item.selected {background:#1890ff;color:#fff;}
        .qty-input {width:80px;display:inline-block;margin-left:10px;}
        .assign-btn{margin-top:15px;}
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <input type="hidden" id="js-plan-id" value="${planId!}">
        <blockquote class="layui-elem-quote">
            选择加工单元 → 选择检验员 → 分配检验任务
        </blockquote>
        <div id="js-unit-list"></div>
        <div style="margin-top:20px;">
            <label class="layui-form-label" style="width:80px;">分配数量:</label>
            <div class="layui-input-inline">
                <input type="number" id="js-assigned-qty" class="layui-input" value="1" style="width:120px;">
            </div>
            <span id="js-selected-info" style="color:#999;margin-left:10px;">请先选择加工单元和检验员</span>
        </div>
        <div class="assign-btn">
            <button class="layui-btn" id="js-btn-assign" disabled>确认分配</button>
            <button class="layui-btn layui-btn-primary" onclick="spLayer.closeAll();">取消</button>
        </div>
    </div>
</div>
<script>
    var selectedUserId = null;
    var selectedProcessUnitId = null;

    layui.use(['layer'], function(){
        var layer = layui.layer;

        function loadProcessUnits() {
            spUtil.ajax({
                url: '${request.contextPath}/quality/task/process-units',
                success: function(result) {
                    var html = '';
                    $.each(result.data, function(i, unit) {
                        html += '<div class="unit-card"><div class="unit-header" onclick="toggleUnit(this,\''+unit.id+'\')">' +
                                '&#9654; ' + unit.name + ' (' + (unit.groupName || '') + ')</div>' +
                                '<div class="unit-body" id="js-unit-'+unit.id+'"></div></div>';
                    });
                    $('#js-unit-list').html(html);
                }
            });
        }

        window.toggleUnit = function(header, unitId) {
            var body = $('#js-unit-' + unitId);
            if (body.is(':visible')) {
                body.slideUp();
                header.innerHTML = header.innerHTML.replace('▼','▶');
            } else {
                body.slideUp(0);
                spUtil.ajax({
                    url: '${request.contextPath}/quality/task/group-users?processUnitId=' + unitId,
                    success: function(result) {
                        var html = '';
                        if (!result.data || result.data.length === 0) {
                            html = '<div style="color:#999;padding:8px;">该单元无成员</div>';
                        } else {
                            $.each(result.data, function(i, user) {
                                html += '<div class="member-item" data-user-id="'+user.userId+'" data-unit-id="'+unitId+'" ' +
                                        'onclick="selectMember(\''+user.userId+'\',\''+unitId+'\',\''+user.userName+'\', this)">' +
                                        user.userName + ' (' + user.username + ')</div>';
                            });
                        }
                        body.html(html).slideDown();
                        header.innerHTML = '▼ ' + header.innerHTML.substring(2);
                    }
                });
            }
        };

        window.selectMember = function(userId, processUnitId, userName, elem) {
            $('.member-item').removeClass('selected');
            $(elem).addClass('selected');
            selectedUserId = userId;
            selectedProcessUnitId = processUnitId;
            $('#js-selected-info').text('已选择: ' + userName);
            $('#js-btn-assign').prop('disabled', false);
        };

        $('#js-btn-assign').click(function(){
            var qty = $('#js-assigned-qty').val();
            if (!selectedUserId || !selectedProcessUnitId) { layer.msg('请选择检验员'); return; }
            if (!qty || parseFloat(qty) <= 0) { layer.msg('请输入有效数量'); return; }
            spUtil.ajax({
                url: '${request.contextPath}/quality/task/assign',
                type: 'POST', contentType: 'application/json',
                data: JSON.stringify({
                    planId: $('#js-plan-id').val(),
                    userId: selectedUserId,
                    processUnitId: selectedProcessUnitId,
                    assignedQty: qty
                }),
                success: function(){ layer.closeAll(); }
            });
        });

        loadProcessUnits();
    });
</script>
</body>
</html>