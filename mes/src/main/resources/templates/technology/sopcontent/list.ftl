<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SOP工艺内容管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sop-layout { padding: 12px; }
        .sop-card { background: #fff; border: 1px solid #e6e6e6; border-radius: 6px; overflow: hidden; margin-bottom: 12px; }
        .sop-card-header { padding: 12px 16px; border-bottom: 1px solid #eee; font-weight: 600; display: flex; align-items: center; justify-content: space-between; background: #fafafa; }
        .sop-card-body { padding: 12px; }
        .sop-tip { color: #999; font-size: 12px; }
    </style>
</head>
<body>
<div class="splayui-container sop-layout">
    <div class="sop-card">
        <div class="sop-card-header">
            <span>SOP工艺内容管理</span>
            <span class="sop-tip">管理SOP工艺内容的编制、审核和发布</span>
        </div>
        <div class="sop-card-body">
            <form id="js-search-form" class="layui-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">SOP编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="sopCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">SOP名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="sopNameLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">产品编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">工序编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="operCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="state">
                                <option value="">全部</option>
                                <option value="draft">草稿</option>
                                <option value="pending">待审核</option>
                                <option value="approved">已生效</option>
                                <option value="rejected">审核不通过</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn" lay-submit lay-filter="js-search-filter">搜索</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        </div>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">新增SOP</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="detail">详情</a>
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="submitAudit">提交审核</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
</script>

<script>
layui.use(['form', 'table', 'spLayer', 'spTable', 'layer'], function () {
    var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable, layer = layui.layer;
    var tableIns = spTable.render({
        url: '${request.contextPath}/technology/sop/content/page',
        toolbar: '#js-record-table-toolbar-top',
        cols: [[
            {type: 'checkbox'},
            {field: 'sopCode', title: 'SOP编号', width: 140},
            {field: 'sopName', title: 'SOP名称', width: 180},
            {field: 'productCode', title: '产品编码', width: 120},
            {field: 'productName', title: '产品名称', width: 140},
            {field: 'operCode', title: '工序编码', width: 120},
            {field: 'operName', title: '工序名称', width: 140},
            {field: 'version', title: '版本', width: 80},
            {field: 'state', title: '状态', width: 100, templet: function(d) {
                var stateMap = {'draft': '草稿', 'pending': '待审核', 'approved': '已生效', 'rejected': '审核不通过'};
                return stateMap[d.state] || d.state;
            }},
            {field: 'compileUsername', title: '编制人', width: 100},
            {field: 'compileDate', title: '编制日期', width: 160},
            {field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 280, fixed: 'right'}
        ]]
    });

    form.on('submit(js-search-filter)', function (data) {
        tableIns.reload({ where: data.field, page: { curr: 1 } });
        return false;
    });

    table.on('toolbar(js-record-table-filter)', function (obj) {
        if (obj.event === 'add') {
            spLayer.open({
                title: '新增SOP工艺内容',
                area: ['960px', '720px'],
                content: '${request.contextPath}/technology/sop/content/add-or-update-ui'
            });
        }
    });

    table.on('tool(js-record-table-filter)', function (obj) {
        var data = obj.data;
        if (obj.event === 'edit') {
            spLayer.open({
                title: '编辑SOP工艺内容',
                area: ['960px', '720px'],
                spWhere: {id: data.id},
                content: '${request.contextPath}/technology/sop/content/add-or-update-ui'
            });
        }
        if (obj.event === 'detail') {
            spLayer.open({
                title: 'SOP工艺内容详情',
                area: ['960px', '720px'],
                spWhere: {id: data.id},
                content: '${request.contextPath}/technology/sop/content/detail-ui'
            });
        }
        if (obj.event === 'submitAudit') {
            if (data.state !== 'draft' && data.state !== 'rejected') {
                layer.msg('当前状态不允许提交审核', {icon: 2});
                return;
            }
            layer.confirm('确认提交审核吗？', function (index) {
                layer.close(index);
                $.post('${request.contextPath}/technology/sop/content/submit-audit', {id: data.id}, function (result) {
                    if (result.code === 0) {
                        layer.msg('提交成功', {icon: 1});
                        tableIns.reload();
                    } else {
                        layer.msg(result.msg || '提交失败', {icon: 2});
                    }
                });
            });
        }
        if (obj.event === 'delete') {
            if (data.state === 'approved' || data.state === 'pending') {
                layer.msg('已审核或审核中的SOP不允许删除', {icon: 2});
                return;
            }
            layer.confirm('确认删除该SOP工艺内容吗？', function (index) {
                layer.close(index);
                $.post('${request.contextPath}/technology/sop/content/delete', {id: data.id}, function (result) {
                    if (result.code === 0) {
                        layer.msg('删除成功', {icon: 1});
                        tableIns.reload();
                    } else {
                        layer.msg(result.msg || '删除失败', {icon: 2});
                    }
                });
            });
        }
    });
});
</script>
</body>
</html>
