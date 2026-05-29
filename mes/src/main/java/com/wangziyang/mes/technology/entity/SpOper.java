package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName(value = "sp_oper")
public class SpOper extends BaseEntity {

    private static final long serialVersionUID = 1L;
    private String oper;
    private String operDesc;
    private String operType;
    private BigDecimal standardTime;
    private String equipmentType;
    private String isKeyOper;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getOper() { return this.oper; }
    public void setOper(String oper) { this.oper = oper; }
    public String getOperDesc() { return this.operDesc; }
    public void setOperDesc(String operDesc) { this.operDesc = operDesc; }
    public String getOperType() { return this.operType; }
    public void setOperType(String operType) { this.operType = operType; }
    public BigDecimal getStandardTime() { return this.standardTime; }
    public void setStandardTime(BigDecimal standardTime) { this.standardTime = standardTime; }
    public String getEquipmentType() { return this.equipmentType; }
    public void setEquipmentType(String equipmentType) { this.equipmentType = equipmentType; }
    public String getIsKeyOper() { return this.isKeyOper; }
    public void setIsKeyOper(String isKeyOper) { this.isKeyOper = isKeyOper; }
    public String getDeleted() { return this.deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    @Override
    public String toString() {
        return "SpOper{" +
                "oper=" + oper +
                ", operDesc=" + operDesc +
                ", operType=" + operType +
                ", standardTime=" + standardTime +
                ", equipmentType=" + equipmentType +
                ", isKeyOper=" + isKeyOper +
                "}";
    }
}
