package com.wangziyang.mes.quality.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.time.LocalDate;

@TableName(value = "sp_qc_resource")
public class SpQcResource extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String resourceCode;
    private String resourceName;
    private String resourceType;
    private String resourceSpec;
    private String manufacturer;
    private String location;
    private Integer calibrationCycle;
    private LocalDate lastCalibrationDate;
    private LocalDate nextCalibrationDate;
    private String status;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
    public String getResourceType() { return resourceType; }
    public void setResourceType(String resourceType) { this.resourceType = resourceType; }
    public String getResourceSpec() { return resourceSpec; }
    public void setResourceSpec(String resourceSpec) { this.resourceSpec = resourceSpec; }
    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public Integer getCalibrationCycle() { return calibrationCycle; }
    public void setCalibrationCycle(Integer calibrationCycle) { this.calibrationCycle = calibrationCycle; }
    public LocalDate getLastCalibrationDate() { return lastCalibrationDate; }
    public void setLastCalibrationDate(LocalDate lastCalibrationDate) { this.lastCalibrationDate = lastCalibrationDate; }
    public LocalDate getNextCalibrationDate() { return nextCalibrationDate; }
    public void setNextCalibrationDate(LocalDate nextCalibrationDate) { this.nextCalibrationDate = nextCalibrationDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}