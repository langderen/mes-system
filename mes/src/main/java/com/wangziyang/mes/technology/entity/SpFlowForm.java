package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_flow_form")
public class SpFlowForm extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String flowId;
    private String formName;
    private String formKey;
    private String formType;
    private String flowTitle;
    private String pcFormUrl;
    private String mobileFormUrl;

    @TableField("init_script")
    private String initScript;

    @TableField("approve_script")
    private String approveScript;

    @TableField("reject_script")
    private String rejectScript;

    @TableField("end_script")
    private String endScript;

    @TableField("skip_first")
    private Integer skipFirst;

    @TableField("skip_same_handler")
    private Integer skipSameHandler;

    @TableField("allow_return")
    private Integer allowReturn;

    @TableField("allow_transfer")
    private Integer allowTransfer;

    @TableField("allow_delegate")
    private Integer allowDelegate;

    @TableField("allow_withdraw")
    private Integer allowWithdraw;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getFlowId() { return flowId; }
    public void setFlowId(String flowId) { this.flowId = flowId; }
    public String getFormName() { return formName; }
    public void setFormName(String formName) { this.formName = formName; }
    public String getFormKey() { return formKey; }
    public void setFormKey(String formKey) { this.formKey = formKey; }
    public String getFormType() { return formType; }
    public void setFormType(String formType) { this.formType = formType; }
    public String getFlowTitle() { return flowTitle; }
    public void setFlowTitle(String flowTitle) { this.flowTitle = flowTitle; }
    public String getPcFormUrl() { return pcFormUrl; }
    public void setPcFormUrl(String pcFormUrl) { this.pcFormUrl = pcFormUrl; }
    public String getMobileFormUrl() { return mobileFormUrl; }
    public void setMobileFormUrl(String mobileFormUrl) { this.mobileFormUrl = mobileFormUrl; }
    public String getInitScript() { return initScript; }
    public void setInitScript(String initScript) { this.initScript = initScript; }
    public String getApproveScript() { return approveScript; }
    public void setApproveScript(String approveScript) { this.approveScript = approveScript; }
    public String getRejectScript() { return rejectScript; }
    public void setRejectScript(String rejectScript) { this.rejectScript = rejectScript; }
    public String getEndScript() { return endScript; }
    public void setEndScript(String endScript) { this.endScript = endScript; }
    public Integer getSkipFirst() { return skipFirst; }
    public void setSkipFirst(Integer skipFirst) { this.skipFirst = skipFirst; }
    public Integer getSkipSameHandler() { return skipSameHandler; }
    public void setSkipSameHandler(Integer skipSameHandler) { this.skipSameHandler = skipSameHandler; }
    public Integer getAllowReturn() { return allowReturn; }
    public void setAllowReturn(Integer allowReturn) { this.allowReturn = allowReturn; }
    public Integer getAllowTransfer() { return allowTransfer; }
    public void setAllowTransfer(Integer allowTransfer) { this.allowTransfer = allowTransfer; }
    public Integer getAllowDelegate() { return allowDelegate; }
    public void setAllowDelegate(Integer allowDelegate) { this.allowDelegate = allowDelegate; }
    public Integer getAllowWithdraw() { return allowWithdraw; }
    public void setAllowWithdraw(Integer allowWithdraw) { this.allowWithdraw = allowWithdraw; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
