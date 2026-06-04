package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_sop_material")
public class SpSopMaterial extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String sopContentId;
    private String bomItemId;
    private String materialId;
    private String materialCode;
    private String materialName;
    private String specification;
    private BigDecimal quantity;
    private String unit;
    private Integer sortNum;
    private String deleted;

    public String getSopContentId() {
        return sopContentId;
    }

    public void setSopContentId(String sopContentId) {
        this.sopContentId = sopContentId;
    }

    public String getBomItemId() {
        return bomItemId;
    }

    public void setBomItemId(String bomItemId) {
        this.bomItemId = bomItemId;
    }

    public String getMaterialId() {
        return materialId;
    }

    public void setMaterialId(String materialId) {
        this.materialId = materialId;
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Integer getSortNum() {
        return sortNum;
    }

    public void setSortNum(Integer sortNum) {
        this.sortNum = sortNum;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
