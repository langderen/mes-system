package com.wangziyang.mes.productdata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName(value = "sp_product_bom")
public class SpProductBom extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String bomCode;
    private String bomName;
    private String productPartId;
    private String productPartCode;
    private String productPartName;
    private String version;
    private String bomType;
    private String state;
    private String descr;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getBomCode() { return bomCode; }
    public void setBomCode(String bomCode) { this.bomCode = bomCode; }
    public String getBomName() { return bomName; }
    public void setBomName(String bomName) { this.bomName = bomName; }
    public String getProductPartId() { return productPartId; }
    public void setProductPartId(String productPartId) { this.productPartId = productPartId; }
    public String getProductPartCode() { return productPartCode; }
    public void setProductPartCode(String productPartCode) { this.productPartCode = productPartCode; }
    public String getProductPartName() { return productPartName; }
    public void setProductPartName(String productPartName) { this.productPartName = productPartName; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getBomType() { return bomType; }
    public void setBomType(String bomType) { this.bomType = bomType; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDescr() { return descr; }
    public void setDescr(String descr) { this.descr = descr; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
