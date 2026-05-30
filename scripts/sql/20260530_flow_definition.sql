-- =============================================
-- 流程定义表
-- 创建日期: 2026-05-30
-- 说明: 用于存储流程定义的基本信息，与流程模型表(sp_flow_oper_relation)分离
-- =============================================

CREATE TABLE IF NOT EXISTS `sp_flow_definition` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `flow_code` varchar(128) NOT NULL COMMENT '流程编码',
  `flow_name` varchar(255) NOT NULL COMMENT '流程名称',
  `flow_category_id` varchar(64) DEFAULT NULL COMMENT '流程分类ID',
  `flow_category_name` varchar(128) DEFAULT NULL COMMENT '流程分类名称',
  `flow_type` varchar(64) DEFAULT NULL COMMENT '流程类型',
  `version` varchar(64) DEFAULT '1.0' COMMENT '版本',
  `state` varchar(32) DEFAULT '0' COMMENT '状态(0:正常;1:禁用)',
  `description` varchar(512) DEFAULT NULL COMMENT '流程描述',
  `bind_type` varchar(32) DEFAULT 'process' COMMENT '绑定类型(process:流程/button:按钮)',
  `button_code` varchar(128) DEFAULT NULL COMMENT '按钮编码',
  `script_content` text COMMENT '脚本内容',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_flow_code` (`flow_code`),
  KEY `idx_flow_category_id` (`flow_category_id`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程定义表';
