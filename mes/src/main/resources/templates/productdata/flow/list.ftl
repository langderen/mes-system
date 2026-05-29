<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺流程管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .flowplan-container { display: flex; height: calc(100vh - 120px); gap: 12px; padding: 12px; }
        .flowplan-left { width: 320px; min-width: 280px; background: #fff; border-radius: 4px; overflow: hidden; display: flex; flex-direction: column; border: 1px solid #e6e6e6; }
        .flowplan-left-header { padding: 12px 16px; font-weight: 600; font-size: 14px; border-bottom: 1px solid #e6e6e6; background: #fafafa; }
        .flowplan-left-list { flex: 1; overflow-y: auto; }
        .flowplan-left-list .bom-item { padding: 10px 16px; border-bottom: 1px solid #f0f0f0; cursor: pointer; transition: background .2s; }
        .flowplan-left-list .bom-item:hover { background: #f5f7fa; }
        .flowplan-left-list .bom-item.active { background: #ecf5ff; border-left: 3px solid #1e9fff; }
        .flowplan-left-list .bom-item .bom-name { font-weight: 500; font-size: 13px; color: #333; }
        .flowplan-left-list .bom-item .bom-info { font-size: 12px; color: #999; margin-top: 3px; }
        .flowplan-left-list .bom-item .bom-state { display: inline-block; padding: 1px 6px; border-radius: 2px; font-size: 11px; margin-left: 6px; }
        .bom-state-create { background: #fff3e0; color: #e65100; }
        .bom-state-locked { background: #e8f5e9; color: #2e7d32; }
        .bom-state-pass { background: #e3f2fd; color: #1565c0; }
        .flowplan-right { flex: 1; background: #fff; border-radius: 4px; overflow: hidden; display: flex; flex-direction: column; border: 1px solid #e6e6e6; }
        .flowplan-right-header { padding: 12px 16px; font-weight: 600; font-size: 14px; border-bottom: 1px solid #e6e6e6; background: #fafafa; display: flex; align-items: center; justify-content: space-between; }
        .flowplan-right-body { flex: 1; overflow-y: auto; padding: 0; }
        .flowplan-empty { display: flex; align-items: center; justify-content: center; height: 100%; color: #bbb; font-size: 14px; flex-direction: column; }
        .flowplan-empty i { font-size: 64px; margin-bottom: 16px; }
        .lock-banner { margin: 12px 16px; padding: 16px 20px; border-radius: 4px; display: none; }
        .lock-banner.locked { display: block; background: #f0f9eb; border: 1px solid #c2e7b0; color: #2e7d32; }
        .lock-banner.locked .lock-title { font-size: 15px; font-weight: 600; margin-bottom: 6px; }
        .lock-banner.locked .lock-desc { font-size: 13px; color: #67a84a; }
        .btn-lock { border-color: #67c23a !important; background: #67c23a !important; color: #fff !important; }
        .btn-lock:hover { opacity: .85; }
        .btn-unlock { border-color: #e6a23c !important; background: #e6a23c !important; color: #fff !important; }
        .tree-prefix { font-family: Consolas, monospace; white-space: pre; color: #c0c4cc; font-size: 13px; line-height: 1; }
        .oper-tag { display: inline-block; padding: 2px 8px; background: #f0f2f5; border-radius: 3px; font-size: 12px; color: #666; margin-right: 4px; }
        .oper-tag::after { content: '→'; margin-left: 4px; color: #ccc; }
        .oper-tag:last-child::after { content: none; }
        .oper-none { color: #ccc; font-size: 12px; font-style: italic; }
    </style>
</head>
<body>
<div class="splayui-container" style="padding:0;">
    <div class="flowplan-container">
        <div class="flowplan-left">
            <div class="flowplan-left-header">产品列表（BOM）</div>
            <div class="flowplan-left-list" id="js-bom-list"></div>
        </div>
        <div class="flowplan-right">
            <div class="flowplan-right-header" id="js-right-header">
                <span>BOM结构及工艺规划</span>
                <span id="js-lock-btn-area"></span>
            </div>
            <div id="js-lock-banner" class="lock-banner">
                <div class="lock-title"><i class="layui-icon" style="font-size:16px;">&#xe605;</i> 产品工艺规划成功</div>
                <div class="lock-desc">请核对工艺流程信息，等待进行工艺内容编制</div>
            </div>
            <div class="flowplan-right-body" id="js-right-body">
                <table class="layui-hide" id="js-bom-item-table" lay-filter="js-bom-item-table-filter"></table>
                <div class="flowplan-empty" id="js-empty-hint">
                    <i class="layui-icon">&#xe61f;</i>
                    <span>请从左侧选择一个BOM产品，查看并管理其工艺流程</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="js-oper-bar-tpl">
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit-oper">编辑工艺</a>
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="clear-oper">清空</a>
</script>

<script type="text/html" id="js-part-col-tpl">
    <span class="tree-prefix">{{d._treePrefix || ''}}</span>{{d.partCode || ''}} / {{d.partName || ''}}
</script>

<script type="text/html" id="js-opers-col-tpl">
    {{# if(d.opers && d.opers.length > 0){ }}
        {{# layui.each(d.opers, function(idx, o){ }}
            <span class="oper-tag">{{o.operName}}</span>
        {{# }); }}
    {{# } else { }}
        <span class="oper-none">未规划</span>
    {{# } }}
</script>

<script>
    layui.use(['layer', 'spLayer', 'util', 'table', 'laytpl'], function () {
        var layer = layui.layer,
            spLayer = layui.spLayer,
            util = layui.util,
            table = layui.table,
            laytpl = layui.laytpl;

        var currentBomId = '';
        var currentBomData = null;
        var allBomList = [];
        var currentRawItems = [];

        loadBomList();

        function loadBomList() {
            spUtil.ajax({
                url: '${request.contextPath}/productdata/flow/bom-list',
                type: 'GET',
                success: function (result) {
                    if (result.code === 0) {
                        allBomList = result.data || [];
                        renderBomList(allBomList);
                    }
                }
            });
        }

        function renderBomList(list) {
            var $el = $('#js-bom-list');
            if (!list || list.length === 0) {
                $el.html('<div style="padding:40px;text-align:center;color:#bbb;">暂无BOM产品</div>');
                return;
            }
            var html = '';
            var stateDict = {'create': '编辑中', 'locked': '已锁定', 'pass': '审核通过'};
            var stateClass = {'create': 'bom-state-create', 'locked': 'bom-state-locked', 'pass': 'bom-state-pass'};
            for (var i = 0; i < list.length; i++) {
                var b = list[i];
                var active = (b.id === currentBomId) ? ' active' : '';
                html += '<div class="bom-item' + active + '" data-id="' + b.id + '">';
                html += '<div class="bom-name">' + (b.bomName || b.bomCode || '') + '</div>';
                html += '<div class="bom-info">';
                html += (b.productPartCode || '') + ' | v' + (b.version || '1');
                html += '<span class="bom-state ' + (stateClass[b.state] || '') + '">' + (stateDict[b.state] || b.state || '创建') + '</span>';
                html += '</div>';
                html += '</div>';
            }
            $el.html(html);
        }

        $('#js-bom-list').on('click', '.bom-item', function () {
            var bomId = $(this).data('id');
            selectBom(bomId);
        });

        function selectBom(bomId) {
            currentBomId = bomId;
            currentBomData = null;
            for (var i = 0; i < allBomList.length; i++) {
                if (allBomList[i].id === bomId) {
                    currentBomData = allBomList[i];
                    break;
                }
            }
            renderBomList(allBomList);
            if (currentBomData) {
                updateLockBanner();
                loadBomItems(bomId);
            }
        }

        function updateLockBanner() {
            var banner = $('#js-lock-banner');
            var btnArea = $('#js-lock-btn-area');
            if (!currentBomData) {
                banner.removeClass('locked').hide();
                btnArea.html('');
                return;
            }
            if (currentBomData.state === 'locked') {
                banner.addClass('locked').show();
                btnArea.html('<button class="layui-btn layui-btn-sm btn-unlock" id="js-unlock-btn"><i class="layui-icon">&#xe642;</i> 解锁</button>');
                $('#js-unlock-btn').on('click', unlockBom);
            } else {
                banner.removeClass('locked').hide();
                btnArea.html('<button class="layui-btn layui-btn-sm btn-lock" id="js-lock-btn"><i class="layui-icon">&#xe641;</i> 锁定BOM</button>');
                $('#js-lock-btn').on('click', lockBom);
            }
        }

        function loadBomItems(bomId) {
            spUtil.ajax({
                url: '${request.contextPath}/productdata/flow/bom-items',
                type: 'GET',
                data: { bomId: bomId },
                success: function (result) {
                    if (result.code === 0) {
                        var rawItems = result.data || [];
                        if (rawItems.length === 0) {
                            $('#js-bom-item-table').addClass('layui-hide');
                            $('#js-empty-hint').show().html('<div class="flowplan-empty"><i class="layui-icon">&#xe61f;</i><span>该BOM暂无子项，请先在BOM管理中维护BOM结构</span></div>');
                            return;
                        }
                        currentRawItems = rawItems;
                        renderBomTable();
                    }
                }
            });
        }

        function buildTree(items) {
            var map = {};
            var roots = [];
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                map[item.id] = item;
                item._children = [];
            }
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                var pid = item.parentItemId;
                if (pid && map[pid]) {
                    map[pid]._children.push(item);
                } else {
                    roots.push(item);
                }
            }

            var flat = [];
            function walk(nodes, ancestors) {
                for (var i = 0; i < nodes.length; i++) {
                    var node = nodes[i];
                    var isLast = (i === nodes.length - 1);
                    var prefix = '';
                    for (var a = 0; a < ancestors.length; a++) {
                        prefix += ancestors[a] ? '&nbsp;&nbsp;&nbsp;&nbsp;' : '│&nbsp;&nbsp;';
                    }
                    prefix += isLast ? '└─&nbsp;' : '├─&nbsp;';
                    node._treePrefix = prefix;
                    flat.push(node);
                    if (node._children && node._children.length > 0) {
                        var newAncestors = ancestors.concat([isLast]);
                        walk(node._children, newAncestors);
                    }
                }
            }
            walk(roots, []);
            return flat;
        }

        function renderBomTable() {
            var isLocked = currentBomData && currentBomData.state === 'locked';
            var treeData = buildTree(currentRawItems);

            $('#js-empty-hint').hide();
            $('#js-bom-item-table').removeClass('layui-hide');

            var cols = [[
                {field: 'partName', title: '零部件', minWidth: 180, templet: '#js-part-col-tpl'},
                {field: 'qty', title: '用量', width: 70},
                {field: 'unit', title: '单位', width: 60},
                {field: 'opers', title: '已绑定工序', templet: '#js-opers-col-tpl'}
            ]];
            if (!isLocked) {
                cols[0].push({fixed: 'right', title: '操作', toolbar: '#js-oper-bar-tpl', unresize: true, width: 165});
            }

            table.render({
                elem: '#js-bom-item-table',
                data: treeData,
                page: false,
                cols: cols,
                height: 'full-' + ($('#js-lock-banner').outerHeight(true) + $('#js-right-header').outerHeight(true) + 40),
                text: { none: ' ' }
            });
        }

        table.on('tool(js-bom-item-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit-oper') {
                spLayer.open({
                    title: '编辑工艺规划 - ' + (data.partCode || '') + ' ' + (data.partName || ''),
                    type: 2,
                    area: ['820px', '500px'],
                    content: '${request.contextPath}/productdata/flow/oper-select-ui',
                    spWhere: { bomId: currentBomId, bomItemId: data.id },
                    reload: false,
                    close: true,
                    spCallback: function (bomResult) {
                        if (bomResult && bomResult.code === 0) {
                            loadBomItems(currentBomId);
                        }
                    }
                });
            }
            if (obj.event === 'clear-oper') {
                layer.confirm('确认清空该BOM子项的全部工序绑定吗？', function (index) {
                    layer.close(index);
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/flow/save-bindings',
                        type: 'POST',
                        data: { bomId: currentBomId, bomItemId: data.id, operIds: '' },
                        success: function () {
                            loadBomItems(currentBomId);
                        }
                    });
                });
            }
        });

        function lockBom() {
            if (!currentBomId) return;
            layer.confirm('确认锁定该BOM吗？锁定后将无法再编辑工艺规划。', { icon: 3, title: '锁定确认' }, function (index) {
                layer.close(index);
                spUtil.ajax({
                    url: '${request.contextPath}/productdata/flow/lock-bom',
                    type: 'POST',
                    data: { bomId: currentBomId },
                    success: function (result) {
                        if (result.code === 0) {
                            if (currentBomData) {
                                currentBomData.state = 'locked';
                            }
                            updateLockBanner();
                            loadBomItems(currentBomId);
                            renderBomList(allBomList);
                            layer.msg('产品工艺规划成功，请核对工艺流程信息，等待进行工艺内容编制', { icon: 1, time: 3000 });
                        } else {
                            layer.msg(result.msg || '锁定失败', { icon: 2 });
                        }
                    }
                });
            });
        }

        function unlockBom() {
            if (!currentBomId) return;
            layer.confirm('确认解锁该BOM吗？解锁后可以重新编辑工艺规划。', { icon: 3, title: '解锁确认' }, function (index) {
                layer.close(index);
                spUtil.ajax({
                    url: '${request.contextPath}/productdata/flow/unlock-bom',
                    type: 'POST',
                    data: { bomId: currentBomId },
                    success: function (result) {
                        if (result.code === 0) {
                            if (currentBomData) {
                                currentBomData.state = 'create';
                            }
                            updateLockBanner();
                            loadBomItems(currentBomId);
                            renderBomList(allBomList);
                            layer.msg('已解锁，可以重新编辑工艺规划', { icon: 1 });
                        } else {
                            layer.msg(result.msg || '解锁失败', { icon: 2 });
                        }
                    }
                });
            });
        }
    });
</script>
</body>
</html>