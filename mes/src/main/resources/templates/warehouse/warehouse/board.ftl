<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>库房看板</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .board-container {
            padding: 15px;
        }
        .board-toolbar {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .board-toolbar .layui-form-select {
            width: 200px;
            margin-right: 15px;
        }
        .board-grid-wrapper {
            overflow: auto;
            border: 1px solid #e6e6e6;
            background: #f5f5f5;
            padding: 10px;
            border-radius: 4px;
        }
        .board-grid {
            display: grid;
            gap: 6px;
            min-width: 800px;
        }
        .location-cell {
            border-radius: 6px;
            padding: 8px 4px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            min-height: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            border: 2px solid transparent;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12);
        }
        .location-cell:hover {
            transform: scale(1.05);
            z-index: 10;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
            border-color: #333;
        }
        .location-cell .cell-code {
            font-size: 11px;
            font-weight: bold;
            color: #333;
            margin-bottom: 2px;
            line-height: 1.2;
        }
        .location-cell .cell-name {
            font-size: 10px;
            color: #555;
            margin-bottom: 2px;
            line-height: 1.2;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .location-cell .cell-inventory {
            font-size: 11px;
            font-weight: bold;
            margin-top: 2px;
        }
        .location-cell .cell-capacity {
            font-size: 10px;
            color: #888;
        }
        .cell-level-empty { background: #f0f0f0; border-color: #d9d9d9; }
        .cell-level-low { background: #d4edda; border-color: #28a745; }
        .cell-level-normal { background: #d6e4ff; border-color: #1890ff; }
        .cell-level-high { background: #fff3cd; border-color: #f0ad4e; }
        .cell-level-full { background: #f8d7da; border-color: #dc3545; }
        .cell-level-overflow { background: #e2c0c5; border-color: #a71d2a; }

        .legend-bar {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 10px;
            padding: 10px;
            background: #fff;
            border: 1px solid #e6e6e6;
            border-radius: 4px;
        }
        .legend-item {
            display: flex;
            align-items: center;
            margin-right: 20px;
            font-size: 12px;
        }
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 3px;
            margin-right: 6px;
            border: 1px solid rgba(0,0,0,0.15);
        }

        .stats-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }
        .stat-card {
            flex: 1;
            min-width: 120px;
            padding: 12px 16px;
            border-radius: 6px;
            color: #fff;
            text-align: center;
        }
        .stat-card .stat-num {
            font-size: 28px;
            font-weight: bold;
        }
        .stat-card .stat-label {
            font-size: 12px;
            margin-top: 2px;
            opacity: 0.9;
        }
        .stat-total { background: linear-gradient(135deg, #667eea, #764ba2); }
        .stat-empty { background: linear-gradient(135deg, #a8a8a8, #787878); }
        .stat-low { background: linear-gradient(135deg, #43e97b, #38f9d7); color: #333; }
        .stat-normal { background: linear-gradient(135deg, #4facfe, #00f2fe); color: #333; }
        .stat-high { background: linear-gradient(135deg, #fa8c16, #ffc53d); color: #333; }
        .stat-full { background: linear-gradient(135deg, #f5222d, #ff4d4f); }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main board-container">
        <div class="board-toolbar">
            <label class="layui-form-label" style="width:80px;border:none;">选择库房</label>
            <select id="js-warehouse-select" lay-filter="js-warehouse-filter">
                <option value="">请选择库房</option>
                <#list warehouses as wh>
                <option value="${wh.id}">${wh.name} (${wh.code})</option>
                </#list>
            </select>
            <button class="layui-btn layui-btn-normal" id="js-refresh-btn"><i class="layui-icon layui-icon-refresh"></i>刷新</button>
        </div>

        <div id="js-board-content" style="display:none;">

            <div class="stats-bar" id="js-stats-bar"></div>

            <div class="legend-bar">
                <span style="font-weight:bold;margin-right:12px;">图例：</span>
                <div class="legend-item"><div class="legend-color cell-level-empty"></div>空闲(0%)</div>
                <div class="legend-item"><div class="legend-color cell-level-low"></div>低库存(1%-30%)</div>
                <div class="legend-item"><div class="legend-color cell-level-normal"></div>正常(30%-60%)</div>
                <div class="legend-item"><div class="legend-color cell-level-high"></div>较高(60%-90%)</div>
                <div class="legend-item"><div class="legend-color cell-level-full"></div>满仓(90%-100%)</div>
                <div class="legend-item"><div class="legend-color cell-level-overflow"></div>超储(>100%)</div>
            </div>

            <div class="board-grid-wrapper">
                <div class="board-grid" id="js-board-grid"></div>
            </div>
        </div>

        <div id="js-empty-tip" style="padding:60px;text-align:center;color:#999;">
            <i class="layui-icon" style="font-size:64px;">&#xe61f;</i>
            <p style="margin-top:15px;font-size:14px;">请选择库房查看库位状态看板</p>
        </div>
    </div>
</div>

<script type="text/html" id="js-cell-detail-tpl">
    <div style="padding:10px;">
        <table class="layui-table">
            <tr><td style="width:80px;font-weight:bold;">库位编码</td><td>{{d.code}}</td></tr>
            <tr><td style="font-weight:bold;">库位名称</td><td>{{d.name || '-'}}</td></tr>
            <tr><td style="font-weight:bold;">位置</td><td>第{{d.rowNo}}行 第{{d.colNo}}列</td></tr>
            <tr><td style="font-weight:bold;">库位类型</td><td>{{d.locationType || '-'}}</td></tr>
            <tr><td style="font-weight:bold;">最大容量</td><td>{{d.maxCapacity || '-'}}</td></tr>
            <tr><td style="font-weight:bold;">当前库存</td><td>{{d.currentInventory || 0}}</td></tr>
            <tr><td style="font-weight:bold;">库存占比</td><td>{{d.inventoryPercent}}%</td></tr>
            <tr><td style="font-weight:bold;">库位状态</td><td>{{d.statusText}}</td></tr>
        </table>
    </div>
</script>

<script>
    layui.use(['form', 'layer', 'laytpl'], function () {
        var form = layui.form,
            layer = layui.layer,
            laytpl = layui.laytpl;

        var currentData = null;

        function escHtml(str) {
            if (!str) return '';
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        form.render('select');

        form.on('select(js-warehouse-filter)', function (data) {
            if (data.value) {
                loadBoardData(data.value);
            } else {
                $('#js-board-content').hide();
                $('#js-empty-tip').show();
            }
        });

        $('#js-refresh-btn').on('click', function () {
            var whId = $('#js-warehouse-select').val();
            if (whId) {
                loadBoardData(whId);
            }
        });

        function loadBoardData(warehouseId) {
            spUtil.ajax({
                url: '${request.contextPath}/warehouse/warehouse/board-data',
                type: 'GET',
                data: { warehouseId: warehouseId },
                success: function (result) {
                    if (result.code === 0) {
                        currentData = result.data;
                        renderBoard(result.data);
                        $('#js-board-content').show();
                        $('#js-empty-tip').hide();
                    }
                }
            });
        }

        function getInventoryPercent(loc) {
            var inv = parseFloat(loc.currentInventory) || 0;
            var max = parseFloat(loc.maxCapacity) || 0;
            if (max <= 0) return 0;
            return Math.round((inv / max) * 100);
        }

        function getCellLevel(percent) {
            if (percent <= 0) return 'empty';
            if (percent <= 30) return 'low';
            if (percent <= 60) return 'normal';
            if (percent <= 90) return 'high';
            if (percent <= 100) return 'full';
            return 'overflow';
        }

        function getStatusText(loc) {
            var statusMap = { '0': '空闲', '1': '使用中', '2': '已满', '3': '超储' };
            return statusMap[loc.status] || '未知';
        }

        function renderBoard(data) {
            var locations = data.locations || [];
            var maxRow = data.maxRow || 1;
            var maxCol = data.maxCol || 1;

            var stats = { total: 0, empty: 0, low: 0, normal: 0, high: 0, full: 0 };
            stats.total = locations.length;

            var gridHtml = '';
            var gridStyle = 'grid-template-columns: repeat(' + maxCol + ', 1fr); grid-template-rows: repeat(' + maxRow + ', 1fr);';
            document.getElementById('js-board-grid').style = gridStyle;

            for (var r = 1; r <= maxRow; r++) {
                for (var c = 1; c <= maxCol; c++) {
                    var loc = null;
                    for (var i = 0; i < locations.length; i++) {
                        if (locations[i].rowNo === r && locations[i].colNo === c) {
                            loc = locations[i];
                            break;
                        }
                    }
                    if (loc) {
                        var pct = getInventoryPercent(loc);
                        var level = getCellLevel(pct);
                        switch (level) {
                            case 'low': stats.low++; break;
                            case 'normal': stats.normal++; break;
                            case 'high': stats.high++; break;
                            case 'full': stats.full++; break;
                            default: stats.empty++; break;
                        }
                        gridHtml += '<div class="location-cell cell-level-' + level + '" data-loc-id="' + loc.id + '">';
                        gridHtml += '<span class="cell-code">' + escHtml(loc.code || '') + '</span>';
                        if (loc.name) {
                            gridHtml += '<span class="cell-name" title="' + escHtml(loc.name) + '">' + escHtml(loc.name) + '</span>';
                        }
                        gridHtml += '<span class="cell-inventory">' + (loc.currentInventory || 0);
                        if (loc.maxCapacity) {
                            gridHtml += ' / ' + loc.maxCapacity;
                        }
                        gridHtml += '</span>';
                        gridHtml += '<span class="cell-capacity">' + pct + '%</span>';
                        gridHtml += '</div>';
                    } else {
                        gridHtml += '<div class="location-cell cell-level-empty" style="opacity:0.4;">-</div>';
                    }
                }
            }

            document.getElementById('js-board-grid').innerHTML = gridHtml;

            document.getElementById('js-stats-bar').innerHTML =
                '<div class="stat-card stat-total"><div class="stat-num">' + stats.total + '</div><div class="stat-label">库位总数</div></div>' +
                '<div class="stat-card stat-empty"><div class="stat-num">' + stats.empty + '</div><div class="stat-label">空闲</div></div>' +
                '<div class="stat-card stat-low"><div class="stat-num">' + stats.low + '</div><div class="stat-label">低库存</div></div>' +
                '<div class="stat-card stat-normal"><div class="stat-num">' + stats.normal + '</div><div class="stat-label">正常</div></div>' +
                '<div class="stat-card stat-high"><div class="stat-num">' + stats.high + '</div><div class="stat-label">较高</div></div>' +
                '<div class="stat-card stat-full"><div class="stat-num">' + stats.full + '</div><div class="stat-label">满仓/超储</div></div>';

            $('.location-cell').off('click').on('click', function () {
                var locId = $(this).data('loc-id');
                if (!locId) return;
                var loc = null;
                for (var i = 0; i < locations.length; i++) {
                    if (locations[i].id === locId) { loc = locations[i]; break; }
                }
                if (!loc) return;
                loc.inventoryPercent = getInventoryPercent(loc);
                loc.statusText = getStatusText(loc);
                var detailHtml = '';
                laytpl($('#js-cell-detail-tpl').html()).render(loc, function (html) {
                    detailHtml = html;
                });
                layer.open({
                    type: 1,
                    title: '库位详情 - ' + loc.code,
                    area: ['400px', '380px'],
                    content: detailHtml
                });
            });
        }
    });
</script>
</body>
</html>