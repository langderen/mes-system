-- =============================================
-- SOP工艺内容编制模块 - 数据库表结构
-- 创建日期: 2026-05-30
-- 说明: 用于存储SOP工艺内容、作业步骤、物料资源、质量控制、审核版本等信息
-- =============================================

-- 1. SOP工艺内容主表
CREATE TABLE IF NOT EXISTS `sp_sop_content` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_code` varchar(128) NOT NULL COMMENT 'SOP编号',
  `sop_name` varchar(255) NOT NULL COMMENT 'SOP名称',
  `product_id` varchar(64) DEFAULT NULL COMMENT '产品ID',
  `product_code` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `part_id` varchar(64) DEFAULT NULL COMMENT '零部件ID',
  `part_code` varchar(128) DEFAULT NULL COMMENT '零部件编码',
  `part_name` varchar(255) DEFAULT NULL COMMENT '零部件名称',
  `flow_definition_id` varchar(64) DEFAULT NULL COMMENT '流程定义ID',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '工序ID',
  `oper_code` varchar(128) DEFAULT NULL COMMENT '工序编码',
  `oper_name` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `content_overview` text COMMENT '工序内容概述',
  `process_requirement` text COMMENT '整体工艺要求(富文本)',
  `standard_capacity` decimal(10,2) DEFAULT NULL COMMENT '标准产能(件/小时)',
  `personnel_requirement` int DEFAULT NULL COMMENT '人员配置要求(人)',
  `labor_protection` text COMMENT '劳保用品要求',
  `remark` text COMMENT '备注信息',
  `version` varchar(32) NOT NULL DEFAULT 'V1.0' COMMENT '版本号',
  `state` varchar(32) NOT NULL DEFAULT 'draft' COMMENT '状态(draft:草稿;pending:待审核;approved:已生效;rejected:审核不通过)',
  `is_latest` varchar(2) NOT NULL DEFAULT '1' COMMENT '是否最新版本(0:否;1:是)',
  `compile_user_id` varchar(64) DEFAULT NULL COMMENT '编制人ID',
  `compile_username` varchar(128) DEFAULT NULL COMMENT '编制人姓名',
  `compile_date` datetime DEFAULT NULL COMMENT '编制日期',
  `submit_audit_time` datetime DEFAULT NULL COMMENT '提交审核时间',
  `audit_time` datetime DEFAULT NULL COMMENT '审核完成时间',
  `audit_username` varchar(128) DEFAULT NULL COMMENT '审核人姓名',
  `audit_comment` text COMMENT '审核意见',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `publish_user_id` varchar(64) DEFAULT NULL COMMENT '发布人ID',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sop_code_version` (`sop_code`, `version`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_part_id` (`part_id`),
  KEY `idx_oper_id` (`oper_id`),
  KEY `idx_state` (`state`),
  KEY `idx_is_latest` (`is_latest`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP工艺内容主表';

-- 2. SOP作业步骤表
CREATE TABLE IF NOT EXISTS `sp_sop_work_step` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `step_no` int NOT NULL COMMENT '步骤序号',
  `operation_desc` text COMMENT '操作说明(富文本)',
  `technical_requirement` text COMMENT '技术要求(富文本)',
  `diagram_urls` text COMMENT '步骤示意图URL列表(JSON数组)',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_sort_num` (`sort_num`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP作业步骤表';

-- 3. SOP关键工艺参数表
CREATE TABLE IF NOT EXISTS `sp_sop_process_param` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `work_step_id` varchar(64) DEFAULT NULL COMMENT '关联作业步骤ID(为空表示全局参数)',
  `param_name` varchar(255) NOT NULL COMMENT '参数名称',
  `param_value` varchar(512) NOT NULL COMMENT '参数值',
  `param_unit` varchar(64) DEFAULT NULL COMMENT '参数单位',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_work_step_id` (`work_step_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP关键工艺参数表';

-- 4. SOP物料清单表
CREATE TABLE IF NOT EXISTS `sp_sop_material` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `bom_item_id` varchar(64) DEFAULT NULL COMMENT 'BOM子项ID',
  `material_id` varchar(64) DEFAULT NULL COMMENT '物料ID',
  `material_code` varchar(128) NOT NULL COMMENT '物料编码',
  `material_name` varchar(255) NOT NULL COMMENT '物料名称',
  `specification` varchar(255) DEFAULT NULL COMMENT '规格型号',
  `quantity` decimal(10,4) NOT NULL COMMENT '数量',
  `unit` varchar(32) DEFAULT NULL COMMENT '单位',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_material_id` (`material_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP物料清单表';

-- 5. SOP设备工装工具表
CREATE TABLE IF NOT EXISTS `sp_sop_resource` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `resource_type` varchar(32) NOT NULL COMMENT '资源类型(equipment:设备;tool:工装工具;fixture:夹具)',
  `resource_id` varchar(64) DEFAULT NULL COMMENT '资源ID(关联设备表等)',
  `resource_code` varchar(128) DEFAULT NULL COMMENT '资源编码',
  `resource_name` varchar(255) NOT NULL COMMENT '资源名称',
  `model` varchar(255) DEFAULT NULL COMMENT '型号',
  `setting_condition` text COMMENT '设定条件',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_resource_type` (`resource_type`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP设备工装工具表';

-- 6. SOP质量控制点表
CREATE TABLE IF NOT EXISTS `sp_sop_quality_control` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `work_step_id` varchar(64) DEFAULT NULL COMMENT '关联作业步骤ID',
  `check_content` text NOT NULL COMMENT '检查内容',
  `check_standard` text NOT NULL COMMENT '判定标准',
  `defect_handling` varchar(64) DEFAULT NULL COMMENT '不良品处理方式(cut:截出;rework:返工;scrap:报废)',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_work_step_id` (`work_step_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP质量控制点表';

-- 7. SOP自检项目表
CREATE TABLE IF NOT EXISTS `sp_sop_self_check` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `check_content` text NOT NULL COMMENT '检查内容',
  `check_standard` text NOT NULL COMMENT '判定标准',
  `sort_num` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP自检项目表';

-- 8. SOP技术文档表
CREATE TABLE IF NOT EXISTS `sp_sop_document` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `doc_name` varchar(255) NOT NULL COMMENT '文档名称',
  `doc_type` varchar(32) DEFAULT NULL COMMENT '文档类型(pdf:PDF;doc:Word;dwg:CAD)',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `file_url` varchar(512) NOT NULL COMMENT '文件URL',
  `upload_user_id` varchar(64) DEFAULT NULL COMMENT '上传人ID',
  `upload_username` varchar(128) DEFAULT NULL COMMENT '上传人姓名',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP技术文档表';

-- 9. SOP审核日志表
CREATE TABLE IF NOT EXISTS `sp_sop_audit_log` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `audit_type` varchar(32) NOT NULL COMMENT '审核类型(submit:提交审核;approve:审核通过;reject:审核不通过;publish:发布)',
  `audit_user_id` varchar(64) DEFAULT NULL COMMENT '审核人ID',
  `audit_username` varchar(128) DEFAULT NULL COMMENT '审核人姓名',
  `audit_comment` text COMMENT '审核意见',
  `audit_result` varchar(32) DEFAULT NULL COMMENT '审核结果(pass:通过;reject:不通过)',
  `audit_time` datetime NOT NULL COMMENT '审核时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_audit_type` (`audit_type`),
  KEY `idx_audit_time` (`audit_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP审核日志表';

-- 10. SOP操作日志表
CREATE TABLE IF NOT EXISTS `sp_sop_operation_log` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `operation_type` varchar(32) NOT NULL COMMENT '操作类型(create:新增;edit:编辑;delete:删除;audit:审核;publish:发布)',
  `operation_content` text COMMENT '操作内容描述',
  `operator_id` varchar(64) DEFAULT NULL COMMENT '操作人ID',
  `operator_username` varchar(128) DEFAULT NULL COMMENT '操作人姓名',
  `operation_time` datetime NOT NULL COMMENT '操作时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_operation_type` (`operation_type`),
  KEY `idx_operation_time` (`operation_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP操作日志表';

-- 11. SOP工位下发记录表
CREATE TABLE IF NOT EXISTS `sp_sop_publish_record` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `sop_content_id` varchar(64) NOT NULL COMMENT 'SOP工艺内容ID',
  `workstation_id` varchar(64) NOT NULL COMMENT '工位ID',
  `workstation_code` varchar(128) DEFAULT NULL COMMENT '工位编码',
  `workstation_name` varchar(255) DEFAULT NULL COMMENT '工位名称',
  `publish_user_id` varchar(64) DEFAULT NULL COMMENT '发布人ID',
  `publish_username` varchar(128) DEFAULT NULL COMMENT '发布人姓名',
  `publish_time` datetime NOT NULL COMMENT '发布时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_sop_content_id` (`sop_content_id`),
  KEY `idx_workstation_id` (`workstation_id`),
  KEY `idx_publish_time` (`publish_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SOP工位下发记录表';
