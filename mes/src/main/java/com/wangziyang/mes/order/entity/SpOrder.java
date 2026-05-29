package com.wangziyang.mes.order.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * 生产订单
 */
@TableName(value = "sp_order")
public class SpOrder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String orderCode;
    private String orderDescription;
    private BigDecimal qty;
    private String orderType;
    private String flowId;
    private String materiel;
    private String materielDesc;
    private String planStartTime;
    private String planEndTime;

    /**
     * 1-创建，2-审批中，3-审批通过，4-已运算，5-已结束
     */
    private Integer statue;

    /**
     * 来源订单号，供生产计划/MRP追溯
     */
    private String sourceOrderNo;

    /**
     * 运算后生成的生产计划编号
     */
    private String generatedPlanNo;

    /**
     * 运算后生成的物料需求计划编号
     */
    private String generatedMrpNo;

    @TableField(exist = false)
    private String approvalStatus;

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getOrderDescription() {
        return orderDescription;
    }

    public void setOrderDescription(String orderDescription) {
        this.orderDescription = orderDescription;
    }

    public BigDecimal getQty() {
        return qty;
    }

    public void setQty(BigDecimal qty) {
        this.qty = qty;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getFlowId() {
        return flowId;
    }

    public void setFlowId(String flowId) {
        this.flowId = flowId;
    }

    public String getMateriel() {
        return materiel;
    }

    public void setMateriel(String materiel) {
        this.materiel = materiel;
    }

    public String getMaterielDesc() {
        return materielDesc;
    }

    public void setMaterielDesc(String materielDesc) {
        this.materielDesc = materielDesc;
    }

    public String getPlanStartTime() {
        return planStartTime;
    }

    public void setPlanStartTime(String planStartTime) {
        this.planStartTime = planStartTime;
    }

    public String getPlanEndTime() {
        return planEndTime;
    }

    public void setPlanEndTime(String planEndTime) {
        this.planEndTime = planEndTime;
    }

    public Integer getStatue() {
        return statue;
    }

    public void setStatue(Integer statue) {
        this.statue = statue;
    }

    public String getSourceOrderNo() {
        return sourceOrderNo;
    }

    public void setSourceOrderNo(String sourceOrderNo) {
        this.sourceOrderNo = sourceOrderNo;
    }

    public String getGeneratedPlanNo() {
        return generatedPlanNo;
    }

    public void setGeneratedPlanNo(String generatedPlanNo) {
        this.generatedPlanNo = generatedPlanNo;
    }

    public String getGeneratedMrpNo() {
        return generatedMrpNo;
    }

    public void setGeneratedMrpNo(String generatedMrpNo) {
        this.generatedMrpNo = generatedMrpNo;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    @Override
    public String toString() {
        return "SpOrder{" +
                "orderCode='" + orderCode + '\'' +
                ", orderDescription='" + orderDescription + '\'' +
                ", qty=" + qty +
                ", orderType='" + orderType + '\'' +
                ", flowId='" + flowId + '\'' +
                ", materiel='" + materiel + '\'' +
                ", materielDesc='" + materielDesc + '\'' +
                ", planStartTime='" + planStartTime + '\'' +
                ", planEndTime='" + planEndTime + '\'' +
                ", statue=" + statue +
                ", sourceOrderNo='" + sourceOrderNo + '\'' +
                ", generatedPlanNo='" + generatedPlanNo + '\'' +
                ", generatedMrpNo='" + generatedMrpNo + '\'' +
                '}';
    }
}
