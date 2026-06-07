<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序选择</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .oper-select-wrap { display: flex; gap: 16px; height: 340px; }
        .oper-select-panel { flex: 1; display: flex; flex-direction: column; border: 1px solid #e6e6e6; border-radius: 4px; overflow: hidden; }
        .oper-select-panel-header { padding: 8px 12px; font-weight: 600; font-size: 13px; border-bottom: 1px solid #e6e6e6; background: #fafafa; }
        .oper-select-panel-search { padding: 6px 10px; border-bottom: 1px solid #e6e6e6; }
        .oper-select-panel-search input { width: 100%; height: 30px; border: 1px solid #e6e6e6; border-radius: 3px; padding: 0 8px; font-size: 12px; }
        .oper-select-list { flex: 1; overflow-y: auto; padding: 4px 0; }
        .oper-select-list .oper-opt { padding: 6px 12px; cursor: pointer; font-size: 13px; transition: background .15s; display: flex; align-items: center; justify-content: space-between; }
        .oper-select-list .oper-opt:hover { background: #f0f7ff; }
        .oper-select-list .oper-opt.active { background: #ecf5ff; color: #1e9fff; }
        .oper-select-list .oper-opt .oper-code { font-size: 11px; color: #999; margin-left: 6px; }
        .oper-select-list .oper-opt .oper-del { color: #ff5722; cursor: pointer; font-size: 14px; display: none; }
        .oper-select-list .oper-opt:hover .oper-del { display: inline; }
        .oper-select-list .oper-opt .oper-seq { display: inline-block; width: 20px; height: 18px; line-height: 18px; text-align: center; background: #1e9fff; color: #fff; border-radius: 2px; font-size: 11px; margin-right: 6px; flex-shrink: 0; }
        .oper-select-actions { display: flex; flex-direction: column; justify-content: center; gap: 10px; padding: 0 4px; }
        .oper-select-actions button { width: 50px; }
        .oper-select-toolbar { padding: 6px 10px; border-top: 1px solid #e6e6e6; display: flex; gap: 6px; justify-content: center; }
        .oper-empty { display: flex; align-items: center; justify-content: center; height: 100%; color: #ccc; font-size: 13px; }
    </style>
</head>
<body>
<div class="splayui-container" style="padding:15px;">
    <form class="layui-form" lay-filter="js-oper-select-form">
        <div class="oper-select-wrap">
            <div class="oper-select-panel">
                <div class="oper-select-panel-header">可用工序</div>
                <div class="oper-select-panel-search">
                    <input type="text" id="js-left-search" placeholder="搜索工序...">
                </div>
                <div class="oper-select-list" id="js-left-list"></div>
            </div>

            <div class="oper-select-actions">
                <button type="button" class="layui-btn layui-btn-sm" id="js-btn-add" title="添加选中">▶</button>
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" id="js-btn-remove" title="移除选中">◀</button>
            </div>

            <div class="oper-select-panel">
                <div class="oper-select-panel-header">已选工序（按顺序执行）</div>
                <div class="oper-select-list" id="js-right-list"></div>
                <div class="oper-select-toolbar">
                    <button type="button" class="layui-btn layui-btn-xs" id="js-btn-up" title="上移">↑</button>
                    <button type="button" class="layui-btn layui-btn-xs" id="js-btn-down" title="下移">↓</button>
                </div>
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <input type="hidden" name="bomId" value="${bomId!}">
                <input type="hidden" name="bomItemId" value="${bomItemId!}">
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </div>
    </form>
</div>

<script>
    layui.use(['form', 'layer', 'spLayer'], function () {
        var form = layui.form,
            layer = layui.layer,
            spLayer = layui.spLayer;

        var bomItemId = '${bomItemId!}';
        var bomId = '${bomId!}';
        var allOpers = [];
        var selectedOpers = [];
        var leftActiveIdx = -1;
        var rightActiveIdx = -1;

        spUtil.ajax({
            url: '${request.contextPath}/productdata/flow/all-opers',
            type: 'GET',
            success: function (result) {
                if (result.code === 0 && result.data) {
                    allOpers = result.data;
                    loadCurrentOper();
                }
            }
        });

        function loadCurrentOper() {
            if (!bomId) {
                renderBoth();
                return;
            }
            spUtil.ajax({
                url: '${request.contextPath}/productdata/flow/bom-items',
                type: 'GET',
                data: { bomId: bomId },
                success: function (result) {
                    if (result.code === 0 && result.data) {
                        for (var i = 0; i < result.data.length; i++) {
                            var item = result.data[i];
                            if (item.id === bomItemId && item.opers && item.opers.length > 0) {
                                selectedOpers = item.opers;
                                break;
                            }
                        }
                    }
                    renderBoth();
                }
            });
        }

        function getAvailableOpers() {
            var selectedIds = {};
            for (var i = 0; i < selectedOpers.length; i++) {
                selectedIds[selectedOpers[i].operId] = true;
            }
            var avail = [];
            for (var j = 0; j < allOpers.length; j++) {
                if (!selectedIds[allOpers[j].id]) {
                    avail.push(allOpers[j]);
                }
            }
            return avail;
        }

        function filterOpers(list, keyword) {
            if (!keyword) return list;
            var kw = keyword.toLowerCase();
            var ret = [];
            for (var i = 0; i < list.length; i++) {
                var o = list[i];
                var code = (o.oper || '').toLowerCase();
                var desc = (o.operDesc || '').toLowerCase();
                if (code.indexOf(kw) >= 0 || desc.indexOf(kw) >= 0) {
                    ret.push(o);
                }
            }
            return ret;
        }

        function renderLeft(keyword) {
            var avail = getAvailableOpers();
            avail = filterOpers(avail, keyword || '');
            var html = '';
            if (avail.length === 0) {
                html = '<div class="oper-empty">暂无可选工序</div>';
            }
            for (var i = 0; i < avail.length; i++) {
                var o = avail[i];
                var activeClass = (i === leftActiveIdx) ? ' active' : '';
                html += '<div class="oper-opt' + activeClass + '" data-index="' + i + '" data-id="' + o.id + '" data-code="' + (o.oper || '') + '" data-name="' + (o.operDesc || '') + '">';
                html += '<span>' + (o.operDesc || '') + '<span class="oper-code">' + (o.oper || '') + '</span></span>';
                html += '</div>';
            }
            $('#js-left-list').html(html);
        }

        function renderRight() {
            var html = '';
            if (selectedOpers.length === 0) {
                html = '<div class="oper-empty">请从左侧添加工序</div>';
            }
            for (var i = 0; i < selectedOpers.length; i++) {
                var o = selectedOpers[i];
                var activeClass = (i === rightActiveIdx) ? ' active' : '';
                html += '<div class="oper-opt' + activeClass + '" data-index="' + i + '" data-id="' + o.operId + '">';
                html += '<span><span class="oper-seq">' + (i + 1) + '</span>' + (o.operName || '') + '<span class="oper-code">' + (o.operCode || '') + '</span></span>';
                html += '<i class="layui-icon layui-icon-close oper-del" data-del="' + i + '"></i>';
                html += '</div>';
            }
            $('#js-right-list').html(html);
        }

        function renderBoth(keyword) {
            renderLeft(keyword);
            renderRight();
        }

        $('#js-left-search').on('input', function () {
            renderBoth($(this).val());
        });

        $('#js-left-list').on('click', '.oper-opt', function () {
            leftActiveIdx = parseInt($(this).data('index'));
            renderLeft($('#js-left-search').val());
        });

        $('#js-left-list').on('dblclick', '.oper-opt', function () {
            var idx = parseInt($(this).data('index'));
            var avail = filterOpers(getAvailableOpers(), $('#js-left-search').val() || '');
            if (idx >= 0 && idx < avail.length) {
                var o = avail[idx];
                selectedOpers.push({ operId: o.id, operCode: o.oper, operName: o.operDesc });
                leftActiveIdx = -1;
                rightActiveIdx = selectedOpers.length - 1;
                renderBoth($('#js-left-search').val());
            }
        });

        $('#js-right-list').on('click', '.oper-opt', function () {
            rightActiveIdx = parseInt($(this).data('index'));
            renderBoth($('#js-left-search').val());
        });

        $('#js-right-list').on('click', '.oper-del', function (e) {
            e.stopPropagation();
            var idx = parseInt($(this).data('del'));
            if (idx >= 0 && idx < selectedOpers.length) {
                selectedOpers.splice(idx, 1);
                if (rightActiveIdx >= selectedOpers.length) {
                    rightActiveIdx = selectedOpers.length - 1;
                }
                leftActiveIdx = -1;
                renderBoth($('#js-left-search').val());
            }
        });

        $('#js-btn-add').on('click', function () {
            var avail = filterOpers(getAvailableOpers(), $('#js-left-search').val() || '');
            if (leftActiveIdx >= 0 && leftActiveIdx < avail.length) {
                var o = avail[leftActiveIdx];
                selectedOpers.push({ operId: o.id, operCode: o.oper, operName: o.operDesc });
                var newAvailLen = avail.length - 1;
                if (leftActiveIdx >= newAvailLen && newAvailLen > 0) {
                    leftActiveIdx = newAvailLen - 1;
                }
                rightActiveIdx = selectedOpers.length - 1;
                renderBoth($('#js-left-search').val());
            }
        });

        $('#js-btn-remove').on('click', function () {
            if (rightActiveIdx >= 0 && rightActiveIdx < selectedOpers.length) {
                selectedOpers.splice(rightActiveIdx, 1);
                if (rightActiveIdx >= selectedOpers.length) {
                    rightActiveIdx = selectedOpers.length - 1;
                }
                leftActiveIdx = -1;
                renderBoth($('#js-left-search').val());
            }
        });

        $('#js-btn-up').on('click', function () {
            if (rightActiveIdx > 0 && rightActiveIdx < selectedOpers.length) {
                var tmp = selectedOpers[rightActiveIdx];
                selectedOpers[rightActiveIdx] = selectedOpers[rightActiveIdx - 1];
                selectedOpers[rightActiveIdx - 1] = tmp;
                rightActiveIdx = rightActiveIdx - 1;
                renderBoth($('#js-left-search').val());
            }
        });

        $('#js-btn-down').on('click', function () {
            if (rightActiveIdx >= 0 && rightActiveIdx < selectedOpers.length - 1) {
                var tmp = selectedOpers[rightActiveIdx];
                selectedOpers[rightActiveIdx] = selectedOpers[rightActiveIdx + 1];
                selectedOpers[rightActiveIdx + 1] = tmp;
                rightActiveIdx = rightActiveIdx + 1;
                renderBoth($('#js-left-search').val());
            }
        });

        form.on('submit(js-submit-filter)', function (data) {
            var operIds = [];
            for (var i = 0; i < selectedOpers.length; i++) {
                operIds.push(selectedOpers[i].operId);
            }

            spUtil.submitForm({
                url: '${request.contextPath}/productdata/flow/save-bindings',
                dataType: 'json',
                data: {
                    bomId: bomId,
                    bomItemId: bomItemId,
                    operIds: operIds.join(',')
                }
            });

            return false;
        });
    });
</script>
</body>
</html>
