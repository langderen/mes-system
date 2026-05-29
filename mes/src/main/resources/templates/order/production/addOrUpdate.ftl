<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产订单录入</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="js-form-filter">
            <input type="hidden" name="id" value="${result.id!}">
            <input type="hidden" name="statue" value="${result.statue!1}">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">订单编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderCode" lay-verify="required" autocomplete="off" class="layui-input" value="${result.orderCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">订单描述</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderDescription" autocomplete="off" class="layui-input" value="${result.orderDescription!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">产品编号</label>
                        <div class="layui-input-inline" style="width: 320px;">
                            <button type="button" id="js-search-part-btn" class="layui-btn" style="height:38px; margin-right:8px;">
                                <i class="layui-icon layui-icon-search"></i>
                            </button>
                            <input type="text" id="js-materiel" name="materiel" lay-verify="required" readonly
                                   autocomplete="off" class="layui-input" value="${result.materiel!}" style="display:inline-block; width: 220px;">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">产品名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-materiel-desc" name="materielDesc" readonly
                                   autocomplete="off" class="layui-input" value="${result.materielDesc!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">数量</label>
                        <div class="layui-input-inline">
                            <input type="number" name="qty" lay-verify="required|number" autocomplete="off" class="layui-input" value="${result.qty!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">订单类型</label>
                        <div class="layui-input-inline">
                            <select name="orderType">
                                <option value="P" <#if (result.orderType!'P') == 'P'>selected</#if>>量产</option>
                                <option value="A" <#if (result.orderType!'') == 'A'>selected</#if>>验证</option>
                                <option value="F" <#if (result.orderType!'') == 'F'>selected</#if>>返工</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">流程ID</label>
                        <div class="layui-input-inline">
                            <input type="text" name="flowId" autocomplete="off" class="layui-input" value="${result.flowId!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计划开始</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planStartTime" id="js-plan-start" autocomplete="off" class="layui-input" value="${result.planStartTime!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计划结束</label>
                        <div class="layui-input-inline">
                            <input type="text" name="planEndTime" id="js-plan-end" autocomplete="off" class="layui-input" value="${result.planEndTime!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">来源订单号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="sourceOrderNo" autocomplete="off" class="layui-input" value="${result.sourceOrderNo!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs12">
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block">
                            <textarea name="remark" class="layui-textarea">${result.remark!}</textarea>
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs12" style="text-align:center;margin-top:20px;">
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter" style="display:none;"></button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'laydate', 'spLayer'], function () {
        var form = layui.form,
            laydate = layui.laydate,
            spLayer = layui.spLayer;

        laydate.render({ elem: '#js-plan-start', type: 'datetime' });
        laydate.render({ elem: '#js-plan-end', type: 'datetime' });

        $('#js-search-part-btn').on('click', function () {
            spLayer.open({
                type: 2,
                area: ['700px', '520px'],
                reload: false,
                content: '${request.contextPath}/productdata/productbom/search-panel-ui',
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var bom = result.data[0];
                        $('#js-materiel').val(bom.productPartCode || '');
                        $('#js-materiel-desc').val(bom.productPartName || '');
                    }
                }
            });
        });

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/order/release/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
