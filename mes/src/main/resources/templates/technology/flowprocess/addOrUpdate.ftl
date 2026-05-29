<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程节点设计</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        :root {
            --border: #e6e6e6;
            --bg: #f5f7fb;
            --panel: #ffffff;
            --accent: #2f54eb;
            --accent-soft: rgba(47, 84, 235, 0.10);
        }
        body { background: var(--bg); }
        .designer {
            display: grid;
            grid-template-columns: 220px minmax(560px, 1fr) 320px;
            gap: 12px;
            padding: 12px;
            min-height: 100vh;
            box-sizing: border-box;
        }
        .panel {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            min-height: 0;
            display: flex;
            flex-direction: column;
        }
        .panel-hd {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border);
            font-weight: 600;
            background: linear-gradient(180deg, #fff, #fafafa);
        }
        .panel-bd {
            padding: 12px;
            overflow: auto;
            min-height: 0;
        }
        .tool-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 12px;
            margin-bottom: 10px;
            border: 1px dashed #cfd8e6;
            border-radius: 8px;
            cursor: grab;
            background: #fff;
            user-select: none;
        }
        .tool-item:hover { background: var(--accent-soft); border-color: var(--accent); color: var(--accent); }
        .hint { font-size: 12px; color: #999; line-height: 1.6; }
        .workbench {
            position: relative;
            height: calc(100vh - 24px);
            min-height: 700px;
            border-radius: 8px;
            overflow: hidden;
            background:
                linear-gradient(90deg, rgba(0,0,0,0.03) 1px, transparent 1px) 0 0 / 28px 28px,
                linear-gradient(rgba(0,0,0,0.03) 1px, transparent 1px) 0 0 / 28px 28px,
                #fff;
        }
        .toolbar {
            position: sticky;
            top: 0;
            z-index: 5;
            display: flex;
            gap: 8px;
            padding: 10px 12px;
            border-bottom: 1px solid var(--border);
            background: rgba(255,255,255,0.92);
        }
        .canvas-wrap {
            position: relative;
            width: 100%;
            height: calc(100% - 53px);
            overflow: auto;
        }
        .canvas {
            position: relative;
            width: 1600px;
            height: 1000px;
        }
        .svg-layer {
            position: absolute;
            left: 0;
            top: 0;
            width: 1600px;
            height: 1000px;
            z-index: 1;
            pointer-events: none;
            overflow: visible;
        }
        .node {
            position: absolute;
            width: 164px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
            z-index: 2;
            cursor: move;
            overflow: hidden;
        }
        .node.active { border-color: var(--accent); box-shadow: 0 10px 28px rgba(47,84,235,0.18); }
        .node-head {
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 10px;
            color: #fff;
            font-size: 12px;
            background: linear-gradient(135deg, #4c6fff, #2f54eb);
        }
        .node-body { padding: 10px; font-size: 13px; color: #333; line-height: 1.5; }
        .node-desc { color: #999; font-size: 12px; word-break: break-all; }
        .node-del { border: 0; background: transparent; color: #fff; cursor: pointer; }
        .anchor {
            position: absolute;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #fff;
            border: 2px solid var(--accent);
            box-sizing: border-box;
            cursor: crosshair;
        }
        .anchor.start { left: -6px; top: 50%; transform: translateY(-50%); }
        .anchor.end { right: -6px; top: 50%; transform: translateY(-50%); }
        .prop-item { margin-bottom: 12px; }
        .prop-item label { display: block; margin-bottom: 6px; color: #555; font-size: 13px; }
        .mini-badge {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 12px;
            color: #2f54eb;
            background: var(--accent-soft);
        }
        .empty-tip {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            color: #999;
            font-size: 14px;
            pointer-events: none;
        }
    </style>
</head>
<body>
<div class="designer">
    <div class="panel">
        <div class="panel-hd">节点库</div>
        <div class="panel-bd">
            <div class="hint" style="margin-bottom:10px;">拖拽节点到画布，或者直接点击添加。</div>
            <div id="js-toolbox"></div>
        </div>
    </div>

    <div class="panel workbench">
        <div class="panel-hd" style="display:flex;align-items:center;justify-content:space-between;">
            <span>流程图设计</span>
            <span class="mini-badge" id="js-status">未保存</span>
        </div>
        <div class="toolbar">
            <button type="button" class="layui-btn layui-btn-sm" id="js-save">保存流程图</button>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" id="js-clear">清空画布</button>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" id="js-back">返回列表</button>
        </div>
        <div class="canvas-wrap" id="js-canvas-wrap">
            <div class="canvas" id="js-canvas">
                <svg class="svg-layer" id="js-svg" width="1600" height="1000" viewBox="0 0 1600 1000">
                    <defs>
                        <marker id="js-arrow" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto" markerUnits="strokeWidth">
                            <path d="M 0 0 L 10 5 L 0 10 z" fill="#91a7ff"></path>
                        </marker>
                    </defs>
                </svg>
                <div class="empty-tip" id="js-empty">从左侧拖入节点，开始设计流程图</div>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-hd">节点属性</div>
        <div class="panel-bd">
            <input type="hidden" id="js-flow-id" value="${flow.id!}">
            <input type="hidden" id="js-flow-code" value="${flow.flow!}">
            <input type="hidden" id="js-flow-desc" value="${flow.flowDesc!}">
            <input type="hidden" id="js-flow-category" value="${flow.flowCategoryId!}">
            <input type="hidden" id="js-bind-type" value="${flow.bindType!'process'}">
            <input type="hidden" id="js-button-code" value="${flow.buttonCode!}">
            <input type="hidden" id="js-script-content" value="${flow.scriptContent!}">
            <input type="hidden" id="js-state" value="${flow.state!'0'}">
            <input type="hidden" id="js-process" value="${flow.process!}">

            <div class="prop-item">
                <label>当前节点</label>
                <input type="text" class="layui-input" id="js-node-title" placeholder="请选择节点">
            </div>
            <div class="prop-item">
                <label>节点描述</label>
                <textarea class="layui-textarea" rows="4" id="js-node-desc" placeholder="节点说明"></textarea>
            </div>
            <div class="prop-item">
                <label>节点类型</label>
                <select class="layui-select" id="js-node-type">
                    <option value="start">开始</option>
                    <option value="task">任务</option>
                    <option value="review">审核</option>
                    <option value="end">结束</option>
                </select>
            </div>
            <div class="prop-item">
                <label>排序</label>
                <input type="number" class="layui-input" id="js-node-sort" value="0">
            </div>
            <div class="prop-item">
                <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" id="js-apply">应用属性</button>
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" id="js-connect">连到下一个</button>
            </div>
            <div class="hint">保存后会把流程图结构序列化到 `process` 字段，后端接口保持不变。</div>
        </div>
    </div>
</div>

<script>
layui.use(['form', 'layer'], function () {
    var layer = layui.layer;
    var $toolbox = $('#js-toolbox');
    var $canvas = $('#js-canvas');
    var $wrap = $('#js-canvas-wrap');
    var $svg = $('#js-svg');
    var $empty = $('#js-empty');
    var $status = $('#js-status');
    var $process = $('#js-process');
    var $title = $('#js-node-title');
    var $desc = $('#js-node-desc');
    var $type = $('#js-node-type');
    var $sort = $('#js-node-sort');

    var allOper = [
        <#if allOper??>
        <#list allOper as item>
        {"value":"${(item.value!'')?js_string}","title":"${(item.title!'')?js_string}"}<#if item_has_next>,</#if>
        </#list>
        </#if>
    ];
    var currentOper = [
        <#if currentOper??>
        <#list currentOper as item>
        {"value":"${(item.value!'')?js_string}","title":"${(item.title!'')?js_string}"}<#if item_has_next>,</#if>
        </#list>
        </#if>
    ];

    var state = {
        nodes: [],
        links: [],
        selectedId: null,
        drag: null,
        connectFrom: null,
        seq: 1
    };

    function parseJson(raw) {
        if (!raw) return null;
        try { return JSON.parse(raw); } catch (e) { return null; }
    }

    function esc(text) {
        return String(text == null ? '' : text)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function setStatus(text, ok) {
        $status.text(text);
        $status.css({
            color: ok ? '#389e0d' : '#2f54eb',
            background: ok ? 'rgba(56,158,13,0.1)' : 'rgba(47,84,235,0.1)'
        });
    }

    function renderToolbox() {
        if (!allOper.length) {
            $toolbox.html('<div class="hint">节点库为空，请检查工序数据。</div>');
            return;
        }
        var html = [];
        allOper.forEach(function (item) {
            html.push(
                '<div class="tool-item" draggable="true" data-id="' + esc(item.value) + '" data-title="' + esc(item.title) + '">' +
                    '<span>' + esc(item.title) + '</span>' +
                    '<small>拖入画布</small>' +
                '</div>'
            );
        });
        $toolbox.html(html.join(''));
    }

    function nodeById(id) {
        for (var i = 0; i < state.nodes.length; i++) {
            if (state.nodes[i].id === id) return state.nodes[i];
        }
        return null;
    }

    function linkPoint(node, side) {
        return {
            x: side === 'left' ? node.x : node.x + 164,
            y: node.y + 37
        };
    }

    function syncProcess() {
        $process.val(JSON.stringify({ nodes: state.nodes, links: state.links }));
    }

    function refreshEmpty() {
        $empty.toggle(state.nodes.length === 0);
    }

    function renderLinks() {
        $svg.find('path.flow-link').remove();
        state.links.forEach(function (link) {
            var from = nodeById(link.from);
            var to = nodeById(link.to);
            if (!from || !to) return;
            var a = linkPoint(from, 'right');
            var b = linkPoint(to, 'left');
            var midX = a.x + (b.x - a.x) * 0.5;
            var d = 'M ' + a.x + ' ' + a.y + ' C ' + midX + ' ' + a.y + ', ' + midX + ' ' + b.y + ', ' + b.x + ' ' + b.y;
            $svg.append('<path class="flow-link" d="' + d + '" stroke="#2f54eb" stroke-width="3" fill="none" marker-end="url(#js-arrow)"></path>');
        });
    }

    function renderNodes() {
        $canvas.find('.node').remove();
        state.nodes.forEach(function (node) {
            var active = state.selectedId === node.id ? 'active' : '';
            var html = '' +
                '<div class="node ' + active + '" data-id="' + node.id + '" style="left:' + node.x + 'px;top:' + node.y + 'px;">' +
                    '<div class="node-head">' +
                        '<span>' + esc(node.title) + '</span>' +
                        '<button type="button" class="node-del">×</button>' +
                    '</div>' +
                    '<div class="node-body">' +
                        '<div class="node-desc">' + esc(node.desc || '双击编辑描述') + '</div>' +
                    '</div>' +
                    '<span class="anchor start"></span>' +
                    '<span class="anchor end"></span>' +
                '</div>';
            $canvas.append(html);
        });
        bindNodeEvents();
        refreshEmpty();
    }

    function redraw() {
        renderNodes();
        renderLinks();
        syncProcess();
    }

    function selectNode(id) {
        state.selectedId = id;
        var node = nodeById(id);
        if (node) {
            $title.val(node.title || '');
            $desc.val(node.desc || '');
            $type.val(node.type || 'task');
            $sort.val(node.sortNo || 0);
        }
        renderNodes();
    }

    function addNode(item) {
        var node = {
            id: 'node_' + Date.now() + '_' + state.seq++,
            operId: item.id || item.value || '',
            title: item.title || '新节点',
            desc: item.title || '',
            type: 'task',
            sortNo: state.nodes.length + 1,
            x: Math.max(20, $wrap.scrollLeft() + 120),
            y: Math.max(20, $wrap.scrollTop() + 100)
        };
        state.nodes.push(node);
        state.selectedId = node.id;
        setStatus('已添加节点', true);
        redraw();
        selectNode(node.id);
    }

    function removeNode(id) {
        state.nodes = state.nodes.filter(function (n) { return n.id !== id; });
        state.links = state.links.filter(function (l) { return l.from !== id && l.to !== id; });
        if (state.connectFrom === id) {
            state.connectFrom = null;
        }
        if (state.selectedId === id) {
            state.selectedId = null;
            $title.val('');
            $desc.val('');
            $sort.val(0);
        }
        redraw();
    }

    function connectNodes(fromId, toId) {
        if (!fromId || !toId) return;
        if (fromId === toId) {
            layer.msg('不能连接到同一个节点');
            return;
        }
        var exists = state.links.some(function (link) {
            return link.from === fromId && link.to === toId;
        });
        if (exists) {
            layer.msg('该连线已存在');
            state.connectFrom = null;
            return;
        }
        state.links.push({ from: fromId, to: toId });
        state.connectFrom = null;
        setStatus('已生成连线', true);
        redraw();
    }

    function bindNodeEvents() {
        $canvas.find('.node').off();
        $canvas.find('.node').on('mousedown', function (e) {
            if ($(e.target).closest('.node-del,.anchor').length) return;
            var id = $(this).data('id');
            var node = nodeById(id);
            if (!node) return;
            if (state.connectFrom && state.connectFrom !== id) {
                connectNodes(state.connectFrom, id);
                e.preventDefault();
                return;
            }
            state.selectedId = id;
            state.drag = { id: id, startX: e.clientX, startY: e.clientY, ox: node.x, oy: node.y };
            selectNode(id);
            e.preventDefault();
        });
        $canvas.find('.node').on('click', function (e) {
            if ($(e.target).closest('.node-del,.anchor').length) return;
            var id = $(this).data('id');
            if (state.connectFrom && state.connectFrom !== id) {
                connectNodes(state.connectFrom, id);
            }
        });
        $canvas.find('.node').on('dblclick', function () {
            selectNode($(this).data('id'));
            layer.msg('请在右侧修改节点属性');
        });
        $canvas.find('.node .node-del').on('click', function (e) {
            e.stopPropagation();
            removeNode($(this).closest('.node').data('id'));
        });
        $canvas.find('.node .anchor.end').on('click', function (e) {
            e.stopPropagation();
            var id = $(this).closest('.node').data('id');
            if (!state.connectFrom) {
                state.connectFrom = id;
                layer.msg('已选起点，再点击目标节点完成连线');
                return;
            }
            connectNodes(state.connectFrom, id);
        });
    }

    function loadInitial() {
        var parsed = parseJson($process.val());
        if (parsed && parsed.nodes) {
            state.nodes = parsed.nodes.map(function (n, idx) {
                return {
                    id: n.id || ('node_' + idx),
                    operId: n.operId || '',
                    title: n.title || ('节点' + (idx + 1)),
                    desc: n.desc || '',
                    type: n.type || 'task',
                    sortNo: n.sortNo || (idx + 1),
                    x: n.x || (80 + idx * 180),
                    y: n.y || (80 + (idx % 2) * 120)
                };
            });
            state.links = Array.isArray(parsed.links) ? parsed.links : [];
            state.seq = state.nodes.length + 1;
            redraw();
            setStatus('已载入流程图', false);
            return;
        }
        if (currentOper.length) {
            state.nodes = currentOper.map(function (item, idx) {
                return {
                    id: 'node_' + idx + '_' + Date.now(),
                    operId: item.value || '',
                    title: item.title || ('节点' + (idx + 1)),
                    desc: item.title || '',
                    type: 'task',
                    sortNo: idx + 1,
                    x: 100 + idx * 180,
                    y: 120 + (idx % 2) * 120
                };
            });
            for (var i = 0; i < state.nodes.length - 1; i++) {
                state.links.push({ from: state.nodes[i].id, to: state.nodes[i + 1].id });
            }
            state.seq = state.nodes.length + 1;
            redraw();
            setStatus('已载入当前工序', false);
        } else {
            redraw();
        }
    }

    renderToolbox();
    loadInitial();

    $toolbox.on('dragstart', '.tool-item', function (e) {
        e.originalEvent.dataTransfer.setData('text/plain', JSON.stringify({
            id: $(this).data('id'),
            title: $(this).data('title')
        }));
    });
    $toolbox.on('click', '.tool-item', function () {
        addNode({ id: $(this).data('id'), title: $(this).data('title') });
    });

    $wrap.on('dragover', function (e) {
        e.preventDefault();
    });
    $wrap.on('drop', function (e) {
        e.preventDefault();
        var payload = parseJson(e.originalEvent.dataTransfer.getData('text/plain')) || {};
        addNode(payload);
    });

    $(document).on('mousemove', function (e) {
        if (!state.drag) return;
        var node = nodeById(state.drag.id);
        if (!node) return;
        node.x = Math.max(0, Math.min(1436, state.drag.ox + (e.clientX - state.drag.startX)));
        node.y = Math.max(0, Math.min(926, state.drag.oy + (e.clientY - state.drag.startY)));
        renderNodes();
        renderLinks();
        syncProcess();
    });
    $(document).on('mouseup', function () {
        if (state.drag) {
            state.drag = null;
            setStatus('已调整节点位置', false);
        }
    });
    $(document).on('keydown', function (e) {
        var tagName = (e.target.tagName || '').toLowerCase();
        if (tagName === 'input' || tagName === 'textarea' || tagName === 'select') return;
        if (e.key === 'Delete' && state.selectedId) {
            removeNode(state.selectedId);
            setStatus('已删除节点', true);
            e.preventDefault();
        }
    });

    $('#js-apply').on('click', function () {
        if (!state.selectedId) {
            layer.msg('先选择一个节点');
            return;
        }
        var node = nodeById(state.selectedId);
        if (!node) return;
        node.title = $title.val() || node.title;
        node.desc = $desc.val();
        node.type = $type.val();
        node.sortNo = Number($sort.val() || 0);
        redraw();
        selectNode(node.id);
        setStatus('已更新节点属性', true);
    });

    $('#js-connect').on('click', function () {
        if (!state.selectedId) {
            layer.msg('先选择一个节点');
            return;
        }
        state.connectFrom = state.selectedId;
        layer.msg('已选择起点，再点击目标节点完成连线');
    });

    $('#js-clear').on('click', function () {
        layer.confirm('确认清空画布吗？', function (index) {
            state.nodes = [];
            state.links = [];
            state.selectedId = null;
            state.connectFrom = null;
            $title.val('');
            $desc.val('');
            $sort.val(0);
            redraw();
            layer.close(index);
            setStatus('已清空', true);
        });
    });

    $('#js-back').on('click', function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    });

    $('#js-save').on('click', function () {
        syncProcess();
        if (!$('#js-flow-id').val() && !$('#js-flow-code').val()) {
            layer.msg('请先在流程定义中创建流程，再进行节点设计');
            return;
        }
        var data = {
            id: $('#js-flow-id').val(),
            flow: $('#js-flow-code').val(),
            flowDesc: $('#js-flow-desc').val(),
            flowCategoryId: $('#js-flow-category').val(),
            bindType: $('#js-bind-type').val(),
            buttonCode: $('#js-button-code').val(),
            scriptContent: $('#js-script-content').val(),
            state: $('#js-state').val(),
            process: $process.val()
        };
        $.ajax({
            url: '${request.contextPath}/basedata/flow/add-or-update',
            type: 'POST',
            data: data,
            success: function (result) {
                if (result.code === 0) {
                    setStatus('保存成功', true);
                    layer.msg('保存成功');
                } else {
                    layer.msg(result.msg || '保存失败');
                }
            },
            error: function () {
                layer.msg('保存失败，请检查后端接口');
            }
        });
    });
});
</script>
</body>
</html>
