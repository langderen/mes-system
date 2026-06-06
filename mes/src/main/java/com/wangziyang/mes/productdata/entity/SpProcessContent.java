package com.wangziyang.mes.productdata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * 工艺内容实体类
 */
@TableName(value = "sp_process_content")
public class SpProcessContent extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 工序ID
     */
    private String operId;

    /**
     * BOM子项ID
     */
    private String bomItemId;

    /**
     * BOM ID
     */
    private String bomId;

    /**
     * 工序编号
     */
    private String operCode;

    /**
     * 工序名称
     */
    private String operName;

    /**
     * 标准工时（分钟）
     */
    private BigDecimal workHour;

    /**
     * 工序类型
     */
    private String operType;

    /**
     * 工艺操作步骤
     */
    private String operStep;

    /**
     * 技术要求
     */
    private String techRequire;

    /**
     * 注意事项
     */
    private String notice;

    /**
     * 生产设备
     */
    private String equipment;

    /**
     * 工装夹具
     */
    private String tooling;

    /**
     * 刀具/量具
     */
    private String cutter;

    /**
     * 工艺图片/附件（JSON格式）
     */
    private String imgList;

    /**
     * 状态：edit-编制中，lock-已锁定
     */
    private String status;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getOperId() {
        return operId;
    }

    public void setOperId(String operId) {
        this.operId = operId;
    }

    public String getBomItemId() {
        return bomItemId;
    }

    public void setBomItemId(String bomItemId) {
        this.bomItemId = bomItemId;
    }

    public String getBomId() {
        return bomId;
    }

    public void setBomId(String bomId) {
        this.bomId = bomId;
    }

    public String getOperCode() {
        return operCode;
    }

    public void setOperCode(String operCode) {
        this.operCode = operCode;
    }

    public String getOperName() {
        return operName;
    }

    public void setOperName(String operName) {
        this.operName = operName;
    }

    public BigDecimal getWorkHour() {
        return workHour;
    }

    public void setWorkHour(BigDecimal workHour) {
        this.workHour = workHour;
    }

    public String getOperType() {
        return operType;
    }

    public void setOperType(String operType) {
        this.operType = operType;
    }

    public String getOperStep() {
        return operStep;
    }

    public void setOperStep(String operStep) {
        this.operStep = operStep;
    }

    public String getTechRequire() {
        return techRequire;
    }

    public void setTechRequire(String techRequire) {
        this.techRequire = techRequire;
    }

    public String getNotice() {
        return notice;
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    public String getEquipment() {
        return equipment;
    }

    public void setEquipment(String equipment) {
        this.equipment = equipment;
    }

    public String getTooling() {
        return tooling;
    }

    public void setTooling(String tooling) {
        this.tooling = tooling;
    }

    public String getCutter() {
        return cutter;
    }

    public void setCutter(String cutter) {
        this.cutter = cutter;
    }

    public String getImgList() {
        return imgList;
    }

    public void setImgList(String imgList) {
        this.imgList = imgList;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
