<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>质检定义编辑</title>
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
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">定义编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="defCode" lay-verify="required" autocomplete="off" class="layui-input" value="${result.defCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">定义名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="defName" lay-verify="required" autocomplete="off" class="layui-input" value="${result.defName!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">检验类型</label>
                        <div class="layui-input-inline">
                            <select name="inspectionType" lay-verify="required">
                                <option value="">请选择</option>
                                <option value="iqc" ${((result.inspectionType!'') == 'iqc')?string('selected','')}>来料检验(IQC)</option>
                                <option value="ipqc" ${((result.inspectionType!'') == 'ipqc')?string('selected','')}>过程检验(IPQC)</option>
                                <option value="oqc" ${((result.inspectionType!'') == 'oqc')?string('selected','')}>出货检验(OQC)</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">产品编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productCode" autocomplete="off" class="layui-input" value="${result.productCode!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">产品名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="productName" autocomplete="off" class="layui-input" value="${result.productName!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">检验方法</label>
                        <div class="layui-input-inline">
                            <select name="inspectionMethod">
                                <option value="visual" ${((result.inspectionMethod!'') == 'visual')?string('selected','')}>目视</option>
                                <option value="measure" ${((result.inspectionMethod!'') == 'measure')?string('selected','')}>测量</option>
                                <option value="test" ${((result.inspectionMethod!'') == 'test')?string('selected','')}>试验</option>
                                <option value="sample" ${((result.inspectionMethod!'') == 'sample')?string('selected','')}>抽样</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">检验项目</label>
                        <div class="layui-input-inline">
                            <input type="text" name="inspectionItem" autocomplete="off" class="layui-input" value="${result.inspectionItem!}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">标准值</label>
                        <div class="layui-input-inline">
                            <input type="text" name="standardValue" autocomplete="off" class="layui-input" value="${result.standardValue!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">上公差</label>
                        <div class="layui-input-inline">
                            <input type="text" name="toleranceUpper" autocomplete="off" class="layui-input" value="${result.toleranceUpper!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">下公差</label>
                        <div class="layui-input-inline">
                            <input type="text" name="toleranceLower" autocomplete="off" class="layui-input" value="${result.toleranceLower!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">单位</label>
                        <div class="layui-input-inline">
                            <input type="text" name="unit" autocomplete="off" class="layui-input" value="${result.unit!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">抽样方案</label>
                        <div class="layui-input-inline">
                            <input type="text" name="samplePlan" autocomplete="off" class="layui-input" value="${result.samplePlan!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">AQL等级</label>
                        <div class="layui-input-inline">
                            <input type="text" name="aqlLevel" autocomplete="off" class="layui-input" value="${result.aqlLevel!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">抽样数量</label>
                        <div class="layui-input-inline">
                            <input type="number" name="sampleQty" autocomplete="off" class="layui-input" value="${result.sampleQty!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">关键检验项</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isCritical" value="1" lay-skin="switch" lay-text="是|否" ${((result.isCritical!'') == '1')?string('checked','')}>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">排序号</label>
                        <div class="layui-input-inline">
                            <input type="number" name="sortNo" autocomplete="off" class="layui-input" value="${result.sortNo!0}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="active" ${((result.status!'') == 'active')?string('selected','')}>启用</option>
                                <option value="inactive" ${((result.status!'') == 'inactive')?string('selected','')}>停用</option>
                            </select>
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
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter" style="display:none;">保存</button>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function(){
        var form = layui.form;
        form.on('submit(js-submit-filter)', function(data){
            var field = data.field;
            field.isCritical = field.isCritical ? '1' : '0';
            spUtil.submitForm({
                url: '${request.contextPath}/quality/def/save',
                data: field
            });
            return false;
        });
    });
</script>
</body>
</html>
