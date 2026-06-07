<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inbound Detail</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div style="padding:16px;">
    <#if !result??>
        <div style="padding:40px;text-align:center;color:#999;">No inbound order data found</div>
    <#else>
        <table class="layui-table">
            <tbody>
            <tr><th width="120">Inbound No</th><td>${result.inboundNo!}</td></tr>
            <tr><th>MRP No</th><td>${result.sourceMrpNos!}</td></tr>
            <tr><th>Status</th><td>${result.status!}</td></tr>
            <tr><th>Lines</th><td>${result.itemCount!}</td></tr>
            <tr><th>Total Qty</th><td>${result.totalDemandQty!}</td></tr>
            <tr><th>Remark</th><td>${result.remark!}</td></tr>
            </tbody>
        </table>

        <table class="layui-table">
            <thead>
            <tr>
                <th>MRP No</th>
                <th>Part Code</th>
                <th>Part Name</th>
                <th>Demand Qty</th>
                <th>Unit</th>
            </tr>
            </thead>
            <tbody>
            <#list items! as item>
                <tr>
                    <td>${item.mrpNo!}</td>
                    <td>${item.partCode!}</td>
                    <td>${item.partName!}</td>
                    <td>${item.demandQty!}</td>
                    <td>${item.unit!}</td>
                </tr>
            </#list>
            </tbody>
        </table>
    </#if>
</div>
</body>
</html>
