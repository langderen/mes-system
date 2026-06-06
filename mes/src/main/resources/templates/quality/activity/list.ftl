<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质量活动管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">活动编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="activityCode" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">活动名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="activityName" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">活动类型</label>
                    <div class="layui-input-inline">
                        <select name="activityType" lay-verify="">
                            <option value="">全部</option>
                            <option value="iqc">来料检验</option>
                            <option value="ipqc">过程检验</option>
                            <option value="oqc">出货检验</option>
                            <option value="spc">统计过程控制</option>
                            <option value="msa">测量系统分析</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status" lay-verify="">
                            <option value="">全部</option>
                            <option value="draft">草稿</option>
                            <option value="active">进行中</option>
                            <option value="paused">暂停</option>
                            <option value="completed">完成</option>
                            <option value="cancelled">取消</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search layuiadmin-button-btn"></i></a>
                </div>
            </div>
        </form>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增质量活动</button>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        var tableIns = spTable.render({
            url: '${request.contextPath}/quality/activity/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'activityCode', title: '活动编码', width: 140},
                {field: 'activityName', title: '活动名称', width: 180},
                {field: 'activityType', title: '活动类型', width: 120, templet: function(d){
                    var map = {iqc:'来料检验', ipqc:'过程检验', oqc:'出货检验', spc:'统计过程控制', msa:'测量系统分析'};
                    return map[d.activityType] || d.activityType;
                }},
                {field: 'triggerType', title: '触发方式', width: 100, templet: function(d){
                    return d.triggerType === 'manual' ? '手动' : d.triggerType === 'schedule' ? '定时' : '事件';
                }},
                {field: 'productCode', title: '产品编码', width: 120},
                {field: 'priority', title: '优先级', width: 80, templet: function(d){
                    return d.priority == 1 ? '<span class="layui-badge layui-bg-red">高</span>' :
                           d.priority == 3 ? '<span class="layui-badge">低</span>' : '<span class="layui-badge layui-bg-orange">中</span>';
                }},
                {field: 'status', title: '状态', width: 100, templet: function(d){
                    var map = {draft:'草稿', active:'进行中', paused:'暂停', completed:'完成', cancelled:'取消'};
                    return map[d.status] || d.status;
                }},
                {field: 'startTime', title: '开始时间', width: 160},
                {field: 'endTime', title: '结束时间', width: 160},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', toolbar: '#js-record-table-toolbar-right', width: 150, fixed: 'right'}
            ]]
        });

        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function(obj){
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增质量活动',
                    area: ['800px', '550px'],
                    content: '${request.contextPath}/quality/activity/add-or-update-ui',
                    end: function(){ tableIns.reload(); }
                });
            }
        });

        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑质量活动',
                    area: ['800px', '550px'],
                    content: '${request.contextPath}/quality/activity/add-or-update-ui',
                    spWhere: { id: data.id },
                    end: function(){ tableIns.reload(); }
                });
            } else if (obj.event === 'delete') {
                spLayer.confirm('确认删除该质量活动?', function(){
                    spUtil.ajax({
                        url: '${request.contextPath}/quality/activity/delete?id=' + data.id,
                        type: 'POST',
                        success: function(){ tableIns.reload(); }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
