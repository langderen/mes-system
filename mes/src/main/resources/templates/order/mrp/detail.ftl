<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MRP明细</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div style="padding:16px;">
    <#if errorMsg??>
        <div style="padding:40px;text-align:center;color:#ff5722;">${errorMsg}</div>
    <#elseif !result??>
        <div style="padding:40px;text-align:center;color:#999;">未找到MRP数据</div>
    <#else>
    <table class="layui-table">
        <tbody>
        <tr><th>MRP编号</th><td>${result.mrpNo!}</td></tr>
        <tr><th>来源订单号</th><td>${result.orderCode!}</td></tr>
        <tr><th>BOM编号</th><td>${result.bomCode!}</td></tr>
        <tr><th>产品编码</th><td>${result.productCode!}</td></tr>
        <tr><th>产品名称</th><td>${result.productName!}</td></tr>
        <tr><th>物料编码</th><td>${result.partCode!}</td></tr>
        <tr><th>物料名称</th><td>${result.partName!}</td></tr>
        <tr><th>需求数量</th><td>${result.demandQty!}</td></tr>
        <tr><th>单位</th><td>${result.unit!}</td></tr>
        <tr><th>创建时间</th><td>${result.createTime!}</td></tr>
        </tbody>
    </table>
    </#if>
</div>
</body>
</html>