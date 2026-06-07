<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺内容编制</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        /* 全局样式 - 与原页面统一 */
        body { margin: 0; padding: 0; background: #f5f7fa; font-size: 14px; }
        .process-container { padding: 15px; height: calc(100vh - 30px); box-sizing: border-box; }
        .process-header { display: flex; justify-content: space-between; align-items: center; padding: 12px 15px; background: #fff; border-radius: 4px; margin-bottom: 12px; border: 1px solid #e6e6e6; }
        .process-title { font-size: 16px; font-weight: 600; color: #333; }
        .process-body { display: flex; gap: 12px; height: calc(100% - 70px); }

        /* 左侧工序列表 */
        .process-left { width: 260px; background: #fff; border-radius: 4px; border: 1px solid #e6e6e6; overflow: hidden; display: flex; flex-direction: column; }
        .left-header { padding: 12px; font-weight: 600; border-bottom: 1px solid #e6e6e6; background: #fafafa; }
        .oper-list { flex: 1; overflow-y: auto; padding: 8px; }
        .oper-item { padding: 10px 12px; border-radius: 3px; cursor: pointer; margin-bottom: 4px; transition: all 0.2s; }
        .oper-item:hover { background: #f5f7fa; }
        .oper-item.active { background: #ecf5ff; color: #1e9fff; border-left: 3px solid #1e9fff; }
        .oper-item .oper-name { font-weight: 500; }
        .oper-item .oper-desc { font-size: 12px; color: #999; margin-top: 4px; }
        .oper-status { font-size: 11px; padding: 1px 4px; border-radius: 2px; margin-left: 4px; }
        .status-edit { background: #fff3e0; color: #e65100; }
        .status-lock { background: #e8f5e9; color: #2e7d32; }

        /* 右侧编制区域 */
        .process-right { flex: 1; background: #fff; border-radius: 4px; border: 1px solid #e6e6e6; overflow-y: auto; padding: 15px; }
        .form-card { margin-bottom: 20px; border: 1px solid #e6e6e6; border-radius: 4px; }
        .card-header { padding: 10px 15px; background: #fafafa; border-bottom: 1px solid #e6e6e6; font-weight: 600; color: #333; }
        .card-body { padding: 15px; }

        /* 图片预览区域 */
        .img-preview-box { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; }
        .img-item { width: 120px; height: 120px; border: 1px dashed #e6e6e6; border-radius: 4px; position: relative; overflow: hidden; }
        .img-item img { width: 100%; height: 100%; object-fit: cover; }
        .img-del { position: absolute; top: 0; right: 0; width: 20px; height: 20px; background: #f56c6c; color: #fff; text-align: center; line-height: 20px; cursor: pointer; font-size: 12px; }

        /* 禁用样式 */
        .form-disabled { background: #fafafa !important; cursor: not-allowed; }
    </style>
</head>
<body>
<div class="process-container">
    <!-- 顶部操作栏 -->
    <div class="process-header">
        <div class="process-title">
            <i class="layui-icon layui-icon-home"></i> 工艺内容编制
            <span style="margin-left:15px; font-size:13px; color:#999" id="js-bom-info">产品：/</span>
            <span style="margin-left:15px;">
                <select id="js-part-select" lay-filter="part-select" style="width:320px; height:32px; border:1px solid #e6e6e6; border-radius:4px; padding:0 10px;">
                    <option value="">加载中...</option>
                </select>
            </span>
        </div>
        <div>
            <button class="layui-btn layui-btn-primary" onclick="backPage()">
                <i class="layui-icon layui-icon-return"></i> 返回
            </button>
            <button class="layui-btn" id="js-save-btn">
                <i class="layui-icon layui-icon-ok"></i> 保存
            </button>
            <button class="layui-btn layui-btn-normal" id="js-complete-btn">
                <i class="layui-icon layui-icon-face-smile"></i> 完成编制
            </button>
        </div>
    </div>

    <div class="process-body">
        <!-- 左侧：工序列表 -->
        <div class="process-left">
            <div class="left-header">关联工序列表</div>
            <div class="oper-list" id="js-oper-list">
                <div style="text-align:center; padding:30px; color:#ccc">加载中...</div>
            </div>
        </div>

        <!-- 右侧：编制表单 -->
        <div class="process-right" id="js-form-area">
            <!-- 1. 工序基础信息 -->
            <div class="form-card">
                <div class="card-header">一、工序基础信息</div>
                <div class="card-body">
                    <form class="layui-form" lay-filter="process-form">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">工序编号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="operCode" lay-verify="required" placeholder="自动获取" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">工序名称</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="operName" lay-verify="required" placeholder="自动获取" class="layui-input" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">标准工时</label>
                                <div class="layui-input-inline">
                                    <input type="number" name="workHour" placeholder="单位：分钟" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">工序类型</label>
                                <div class="layui-input-inline">
                                    <select name="operType">
                                        <option value="">请选择</option>
                                        <option value="加工">加工</option>
                                        <option value="装配">装配</option>
                                        <option value="检验">检验</option>
                                        <option value="包装">包装</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 2. 工艺操作步骤 -->
            <div class="form-card">
                <div class="card-header">二、工艺操作步骤</div>
                <div class="card-body">
                    <textarea class="layui-textarea" name="operStep" id="operStep"
                              placeholder="请详细编写工序操作步骤（支持多行文本）" style="min-height:120px"></textarea>
                </div>
            </div>

            <!-- 3. 工艺要求 & 注意事项 -->
            <div class="form-card">
                <div class="card-header">三、工艺要求 & 注意事项</div>
                <div class="card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">技术要求</label>
                        <div class="layui-input-block">
                            <textarea class="layui-textarea" name="techRequire" placeholder="填写质量、精度等技术要求"></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">注意事项</label>
                        <div class="layui-input-block">
                            <textarea class="layui-textarea" name="notice" placeholder="填写安全、关键操作注意事项"></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. 工装设备 & 刀具量具 -->
            <div class="form-card">
                <div class="card-header">四、工装设备 & 刀具量具</div>
                <div class="card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">生产设备</label>
                        <div class="layui-input-block">
                            <input type="text" name="equipment" placeholder="例：数控车床、加工中心" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">工装夹具</label>
                        <div class="layui-input-block">
                            <input type="text" name="tooling" placeholder="例：专用夹具、模具" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">刀具/量具</label>
                        <div class="layui-input-block">
                            <input type="text" name="cutter" placeholder="例：铣刀、卡尺、千分尺" class="layui-input">
                        </div>
                    </div>
                </div>
            </div>

            <!-- 5. 工艺图片/文档上传（PPT核心要求） -->
            <div class="form-card">
                <div class="card-header">五、工艺指导图/附件上传</div>
                <div class="card-body">
                    <button type="button" class="layui-btn layui-btn-normal" id="js-upload-img">
                        <i class="layui-icon layui-icon-upload"></i> 上传工艺图片
                    </button>
                    <button type="button" class="layui-btn layui-btn-warm" id="js-upload-file">
                        <i class="layui-icon layui-icon-upload-drag"></i> 上传工艺文档
                    </button>
                    <div class="img-preview-box" id="js-img-preview"></div>
                    <div style="margin-top:10px; font-size:12px; color:#999">支持：jpg/png/pdf/word，最大10MB</div>
                </div>
            </div>

            <!-- 6. 备料清单 -->
            <div class="form-card">
                <div class="card-header">六、工序备料清单</div>
                <div class="card-body">
                    <table class="layui-hide" id="js-material-table" lay-filter="material-filter"></table>
                    <script type="text/html" id="material-toolbar">
                        <div class="layui-btn-container">
                            <button class="layui-btn layui-btn-xs" lay-event="add">新增物料</button>
                        </div>
                    </script>
                    <script type="text/html" id="material-bar">
                        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
                        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
                    </script>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use(['layer', 'form', 'table', 'upload', 'laytpl'], function(){
        var layer = layui.layer,
            form = layui.form,
            table = layui.table,
            upload = layui.upload,
            laytpl = layui.laytpl;

        // 全局参数：从上一页传递的参数（BOM/零部件/工序ID）
        var params = {
            bomId: getUrlParam('bomId'),
            bomItemId: getUrlParam('bomItemId'),
            operId: '',
            status: 'edit' // edit=编制中 lock=已锁定
        };

        // 初始化页面
        initPage();
        // 初始化备料清单表格
        initMaterialTable();
        // 初始化图片上传
        initUpload();
        // 绑定按钮事件
        bindEvent();
        // 绑定下拉选择事件（使用原生change事件）
        $('#js-part-select').on('change', function(){
            var selectedValue = $(this).val();
            if(selectedValue && selectedValue !== params.bomItemId) {
                // 获取选中项的信息
                var option = $('#js-part-select option:selected');
                var partName = option.data('partname') || '';
                // 跳转到新的零部件
                var url = location.pathname + '?bomId=' + encodeURIComponent(params.bomId) +
                    '&bomItemId=' + encodeURIComponent(selectedValue) +
                    '&bomName=' + encodeURIComponent(getUrlParam('bomName')) +
                    '&partName=' + encodeURIComponent(partName);
                location.href = url;
            }
        });

        // 加载BOM子项列表到下拉框
        function loadBomItemList() {
            if(!params.bomId) return;

            spUtil.ajax({
                url: '${request.contextPath}/productdata/content/bom-item-list',
                type: 'GET',
                data: { bomId: params.bomId },
                success: function(res) {
                    if(res.code === 0) {
                        var items = res.data || [];
                        var html = '<option value="">请选择零部件</option>';
                        for(var i = 0; i < items.length; i++) {
                            var item = items[i];
                            var selected = item.id === params.bomItemId ? 'selected' : '';
                            var disabled = !item.hasOper ? 'disabled' : '';
                            html += '<option value="' + item.id + '" ' + selected + ' ' + disabled + ' data-partname="' + item.partName + '">' + item.displayText + '</option>';
                        }
                        $('#js-part-select').html(html);
                    }
                }
            });
        }

        // 初始化页面数据
        function initPage(){
            $('#js-bom-info').text('产品：' + getUrlParam('bomName'));
            // 加载BOM子项列表
            loadBomItemList();
            // 加载工序列表
            loadOperList();
        }

        // 加载工序列表
        function loadOperList(){
            if(!params.bomItemId) {
                $('#js-oper-list').html('<div style="text-align:center; padding:30px; color:#f56c6c">请从上方选择零部件</div>');
                return;
            }
            spUtil.ajax({
                url: '${request.contextPath}/productdata/content/oper-list',
                type: 'GET',
                data: { bomItemId: params.bomItemId },
                success: function(res){
                    if(res.code === 0){
                        var data = res.data || [];
                        if(data.length === 0){
                            $('#js-oper-list').html('<div style="text-align:center; padding:30px; color:#f56c6c">该BOM子项没有关联工序<br>请返回工艺流程规划页面绑定工序</div>');
                        } else {
                            renderOperList(data);
                        }
                    } else {
                        $('#js-oper-list').html('<div style="text-align:center; padding:30px; color:#f56c6c">加载失败: ' + (res.msg || '') + '</div>');
                    }
                },
                error: function(err) {
                    $('#js-oper-list').html('<div style="text-align:center; padding:30px; color:#f56c6c">网络错误</div>');
                }
            });
        }

        // 渲染工序列表
        function renderOperList(list){
            var html = '';
            if(list.length === 0){
                html = '<div style="text-align:center; padding:30px; color:#ccc">暂无绑定工序</div>';
                $('#js-oper-list').html(html);
                return;
            }
            for(var i = 0; i < list.length; i++){
                var item = list[i];
                var statusClass = item.status === 'lock' ? 'status-lock' : 'status-edit';
                var statusText = item.status === 'lock' ? '已完成' : '编制中';
                html += '<div class="oper-item" data-id="' + item.id + '" data-status="' + item.status + '">' +
                    '<div class="oper-name">' + item.operName + ' <span class="oper-status ' + statusClass + '">' + statusText + '</span></div>' +
                    '<div class="oper-desc">工序编号：' + item.operCode + '</div>' +
                    '</div>';
            }
            $('#js-oper-list').html(html);

            // 绑定工序点击事件
            $('.oper-item').click(function(){
                $('.oper-item').removeClass('active');
                $(this).addClass('active');
                params.operId = $(this).data('id');
                params.status = $(this).data('status');
                // 加载工序编制数据
                loadProcessData();
            });

            // 默认选中第一个
            var firstItem = $('.oper-item:first');
            if(firstItem.length > 0) {
                firstItem.click();
            }
        }

        // 加载工艺编制数据
        function loadProcessData(){
            if(!params.operId) {
                layer.msg('缺少工序ID', {icon: 2});
                return;
            }
            
            // 锁定状态禁用表单
            if(params.status === 'lock'){
                $('input,textarea,select').addClass('form-disabled').attr('disabled', true);
                $('#js-save-btn,#js-complete-btn').addClass('layui-btn-disabled').attr('disabled', true);
                layer.msg('该工序已完成编制，不可编辑', {icon:7});
            } else {
                $('input,textarea,select').removeClass('form-disabled').attr('disabled', false);
                $('#js-save-btn,#js-complete-btn').removeClass('layui-btn-disabled').attr('disabled', false);
            }

            // 加载表单数据
            spUtil.ajax({
                url: '${request.contextPath}/productdata/content/process-detail',
                data: { operId: params.operId },
                success: function(res){
                    if(res.code === 0){
                        form.val('process-form', res.data || {});
                        // 渲染图片预览
                        renderImgPreview(res.data.imgList || []);
                    }
                }
            });
        }

        // 初始化图片上传
        function initUpload(){
            upload.render({
                elem: '#js-upload-img',
                url: '${request.contextPath}/common/upload/image',
                accept: 'images',
                size: 10240,
                done: function(res){
                    if(res.code === 0){
                        layer.msg('上传成功');
                        var imgList = $('#js-img-preview').data('list') || [];
                        imgList.push(res.data);
                        $('#js-img-preview').data('list', imgList);
                        renderImgPreview(imgList);
                    }
                }
            });
        }

        // 渲染图片预览
        function renderImgPreview(list){
            var html = '';
            list.forEach((item, index) => {
                html += `
                <div class="img-item">
                    <img src="${item.url}" alt="工艺图">
                    <div class="img-del" data-index="${index}">×</div>
                </div>`;
            });
            $('#js-img-preview').html(html);

            // 删除图片
            $('.img-del').click(function(){
                var index = $(this).data('index');
                var imgList = $('#js-img-preview').data('list') || [];
                imgList.splice(index, 1);
                $('#js-img-preview').data('list', imgList);
                renderImgPreview(imgList);
            });
        }

        // 初始化备料清单表格
        function initMaterialTable(){
            table.render({
                elem: '#js-material-table',
                toolbar: '#material-toolbar',
                cols: [[
                    {type: 'numbers', title: '序号'},
                    {field: 'materialCode', title: '物料编码', edit: 'text'},
                    {field: 'materialName', title: '物料名称', edit: 'text'},
                    {field: 'qty', title: '用量', edit: 'text'},
                    {field: 'unit', title: '单位', edit: 'text'},
                    {fixed: 'right', title: '操作', toolbar: '#material-bar', width: 120}
                ]],
                data: [],
                page: false
            });
        }

        // 绑定按钮事件
        function bindEvent(){
            // 保存
            $('#js-save-btn').click(function(){
                var formData = form.val('process-form');
                formData.operId = params.operId;
                formData.bomId = params.bomId;
                formData.bomItemId = params.bomItemId;
                formData.imgList = $('#js-img-preview').data('list') || [];
                formData.materialList = table.cache['js-material-table'] || [];

                spUtil.ajax({
                    url: '${request.contextPath}/productdata/content/save-process',
                    type: 'post',
                    data: JSON.stringify(formData),
                    contentType: 'application/json',
                    success: function(res){
                        if(res.code === 0) layer.msg('保存成功', {icon:1});
                        else layer.msg(res.msg || '保存失败', {icon:2});
                    }
                });
            });

            // 完成编制（锁定）
            $('#js-complete-btn').click(function(){
                layer.confirm('确认完成编制？完成后将不可修改！', {icon:3}, function(index){
                    layer.close(index);
                    spUtil.ajax({
                        url: '${request.contextPath}/productdata/content/complete-process',
                        type: 'post',
                        data: { operId: params.operId },
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('编制完成！', {icon:1});
                                loadOperList(); // 刷新工序列表
                            }
                        }
                    });
                });
            });
        }

        // 获取URL参数
        function getUrlParam(name){
            var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if(r!=null)return decodeURIComponent(r[2]); return '';
        }
    });

    // 返回上一页
    function backPage(){
        history.back();
    }
</script>
</body>
</html>