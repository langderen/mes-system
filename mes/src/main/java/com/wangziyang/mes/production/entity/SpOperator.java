package com.wangziyang.mes.production.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName(value = "sp_operator")
public class SpOperator extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String operatorNo;
    private String operatorName;
    private String teamId;
    private String skillLevel;
    private String workStatus;
    private String currentOrderId;
    private String qualification;
    private String phone;
    private String status;
    private Integer sortNo;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getOperatorNo() { return operatorNo; }
    public void setOperatorNo(String operatorNo) { this.operatorNo = operatorNo; }
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }
    public String getSkillLevel() { return skillLevel; }
    public void setSkillLevel(String skillLevel) { this.skillLevel = skillLevel; }
    public String getWorkStatus() { return workStatus; }
    public void setWorkStatus(String workStatus) { this.workStatus = workStatus; }
    public String getCurrentOrderId() { return currentOrderId; }
    public void setCurrentOrderId(String currentOrderId) { this.currentOrderId = currentOrderId; }
    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}