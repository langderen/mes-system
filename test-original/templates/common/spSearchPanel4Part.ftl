<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件搜索</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">零部件编码</label>
                    <div class="layui-input-inline" style="width: 120px;">
                        <input type="text" name="partCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">零部件名称</label>
                    <div class="layui-input-inline" style="width: 120px;">
                        <input type="text" name="partNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i
                                class="layui-icon layui-icon-search"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        <form class="layui-form splayui-form">
            <div class="layui-row">
                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value=""/>
                        <button id="js-submit" type="button" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'util', 'table', 'spTable'], function () {
        var form = layui.form,
            util = layui.util,
            table = layui.table,
            spTable = layui.spTable;

        var tableIns = spTable.render({
            toolbar: '',
            url: '${request.contextPath}/productdata/part/page',
            cols: [[
                {type: 'radio'},
                {field: 'partCode', title: '零部件编码', width: 120},
                {field: 'partName', title: '零部件名称', width: 140},
                {field: 'partType', title: '类型', width: 80},
                {field: 'spec', title: '规格型号', width: 120},
                {field: 'unit', title: '单位', width: 60}
            ]]
        });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });

        form.on('submit(js-submit-filter)', function (data) {
            window.spChildFrameResult = {
                msg: '操作成功',
                code: 0,
                data: table.checkStatus('js-record-table').data,
                isAll: table.checkStatus('js-record-table').isAll
            };
            return false;
        });

        table.on('rowDouble(js-record-table-filter)', function (obj) {
            obj.tr.find('i[class="layui-anim layui-icon"]').trigger("click");
            parent.layui.$('.layui-layer-btn0').click();
        });
    });
</script>
</body>
</html>
