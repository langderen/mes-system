package com.wangziyang.mes.productdata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName(value = "sp_bom_oper_binding")
public class SpBomOperBinding extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String bomId;
    private String bomItemId;
    private String operId;
    private String operCode;
    private String operName;
    private Integer sortNo;

    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }
    public String getBomItemId() { return bomItemId; }
    public void setBomItemId(String bomItemId) { this.bomItemId = bomItemId; }
    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }
    public String getOperCode() { return operCode; }
    public void setOperCode(String operCode) { this.operCode = operCode; }
    public String getOperName() { return operName; }
    public void setOperName(String operName) { this.operName = operName; }
    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
}