-- =============================================
-- 生产作业派工功能表
-- =============================================

-- 派工单（工单）表
DROP TABLE IF EXISTS `sp_dispatch_order`;
CREATE TABLE `sp_dispatch_order` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `order_no` varchar(64) NOT NULL COMMENT '工单号',
  `product_code` varchar(64) NOT NULL COMMENT '产品编码',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `bom_id` varchar(64) DEFAULT NULL COMMENT 'BOM ID',
  `qty` decimal(10,2) NOT NULL COMMENT '计划数量',
  `completed_qty` decimal(10,2) DEFAULT 0 COMMENT '完成数量',
  `qualified_qty` decimal(10,2) DEFAULT 0 COMMENT '合格数量',
  `scrap_qty` decimal(10,2) DEFAULT 0 COMMENT '报废数量',
  `plan_start_time` datetime DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` datetime DEFAULT NULL COMMENT '计划结束时间',
  `actual_start_time` datetime DEFAULT NULL COMMENT '实际开始时间',
  `actual_end_time` datetime DEFAULT NULL COMMENT '实际结束时间',
  `priority` int DEFAULT 2 COMMENT '优先级 1-高 2-中 3-低',
  `status` varchar(32) NOT NULL DEFAULT 'draft' COMMENT '状态 draft-已下发 assigned-已派工 started-已开工 completed-已完工 inspected-待检验 scrapped-废补',
  `source_order_no` varchar(64) DEFAULT NULL COMMENT '来源订单号',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_product_code` (`product_code`),
  KEY `idx_status` (`status`),
  KEY `idx_plan_start_time` (`plan_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='派工单（工单）表';

-- 生产班组表
DROP TABLE IF EXISTS `sp_production_team`;
CREATE TABLE `sp_production_team` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `team_code` varchar(64) NOT NULL COMMENT '班组编码',
  `team_name` varchar(128) NOT NULL COMMENT '班组名称',
  `team_type` varchar(32) DEFAULT 'production' COMMENT '班组类型 production-生产 team-检验 maintenance-维修',
  `workshop_id` varchar(64) DEFAULT NULL COMMENT '车间ID',
  `line_id` varchar(64) DEFAULT NULL COMMENT '产线ID',
  `leader_id` varchar(64) DEFAULT NULL COMMENT '班组长ID',
  `status` varchar(32) DEFAULT 'active' COMMENT '状态 active-启用 inactive-停用',
  `sort_no` int DEFAULT 0 COMMENT '排序号',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_team_code` (`team_code`),
  KEY `idx_team_type` (`team_type`),
  KEY `idx_workshop_id` (`workshop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='生产班组表';

-- 作业员表
DROP TABLE IF EXISTS `sp_operator`;
CREATE TABLE `sp_operator` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `operator_no` varchar(64) NOT NULL COMMENT '作业员编号',
  `operator_name` varchar(64) NOT NULL COMMENT '作业员姓名',
  `team_id` varchar(64) DEFAULT NULL COMMENT '所属班组ID',
  `skill_level` varchar(32) DEFAULT 'normal' COMMENT '技能等级 senior-高级 intermediate-中级 junior-初级 normal-普通',
  `work_status` varchar(32) DEFAULT 'working' COMMENT '工作状态 working-上班 resting-休息 off-下班',
  `current_order_id` varchar(64) DEFAULT NULL COMMENT '当前工单ID',
  `qualification` varchar(500) DEFAULT NULL COMMENT '技能证书/资质',
  `phone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `status` varchar(32) DEFAULT 'active' COMMENT '状态 active-启用 inactive-停用',
  `sort_no` int DEFAULT 0 COMMENT '排序号',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_operator_no` (`operator_no`),
  KEY `idx_team_id` (`team_id`),
  KEY `idx_work_status` (`work_status`),
  KEY `idx_current_order_id` (`current_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='作业员表';

-- 派工记录表
DROP TABLE IF EXISTS `sp_dispatch_record`;
CREATE TABLE `sp_dispatch_record` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `dispatch_order_id` varchar(64) NOT NULL COMMENT '派工单ID',
  `dispatch_type` varchar(32) NOT NULL COMMENT '派工类型 person-人员 equipment-设备',
  `team_id` varchar(64) DEFAULT NULL COMMENT '班组ID(sp_sys_group)',
  `operator_id` varchar(64) DEFAULT NULL COMMENT '作业员ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '人员派工用户ID(sp_sys_user)',
  `process_unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID(sp_sys_process_unit)',
  `equipment_id` varchar(64) DEFAULT NULL COMMENT '设备ID',
  `plan_qty` decimal(10,2) NOT NULL COMMENT '派工数量',
  `completed_qty` decimal(10,2) DEFAULT 0 COMMENT '完成数量',
  `qualified_qty` decimal(10,2) DEFAULT 0 COMMENT '合格数量',
  `scrap_qty` decimal(10,2) DEFAULT 0 COMMENT '报废数量',
  `work_hours` decimal(6,2) DEFAULT 0 COMMENT '实际工时（小时）',
  `dispatch_time` datetime DEFAULT NULL COMMENT '派工时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始作业时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束作业时间',
  `status` varchar(32) DEFAULT 'pending' COMMENT '状态 pending-待开工 started-已开工 completed-已完成 scrapped-已报废',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  KEY `idx_dispatch_order_id` (`dispatch_order_id`),
  KEY `idx_team_id` (`team_id`),
  KEY `idx_operator_id` (`operator_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_process_unit_id` (`process_unit_id`),
  KEY `idx_equipment_id` (`equipment_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='派工记录表';

-- 插入测试数据
INSERT INTO `sp_production_team` (`id`, `team_code`, `team_name`, `team_type`, `line_id`, `status`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('1745491200000000001', 'TEAM-001', '生产作业班组1', 'production', '1336867983196192', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000002', 'TEAM-002', '生产作业班组2', 'production', '1336868041916448', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000003', 'TEAM-003', '检验班组', 'team', NULL, 'active', NOW(), 'admin', NOW(), 'admin');

INSERT INTO `sp_operator` (`id`, `operator_no`, `operator_name`, `team_id`, `skill_level`, `work_status`, `status`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('1745491200000000101', 'OP-001', '作业员1', '1745491200000000001', 'senior', 'working', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000102', 'OP-002', '作业员2', '1745491200000000001', 'intermediate', 'working', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000103', '作业员3', '1745491200000000002', 'normal', 'working', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000104', 'OP-004', '作业员4', '1745491200000000002', 'intermediate', 'working', 'active', NOW(), 'admin', NOW(), 'admin'),
('1745491200000000105', 'OP-005', '检验员1', '1745491200000000003', 'senior', 'working', 'active', NOW(), 'admin', NOW(), 'admin');

-- 如果sp_dispatch_record表已存在，执行以下ALTER TABLE添加新字段
-- ALTER TABLE `sp_dispatch_record` ADD COLUMN `user_id` varchar(64) DEFAULT NULL COMMENT '人员派工用户ID(sp_sys_user)' AFTER `operator_id`;
-- ALTER TABLE `sp_dispatch_record` ADD COLUMN `process_unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID(sp_sys_process_unit)' AFTER `user_id`;
-- ALTER TABLE `sp_dispatch_record` ADD INDEX `idx_user_id` (`user_id`);
-- ALTER TABLE `sp_dispatch_record` ADD INDEX `idx_process_unit_id` (`process_unit_id`);

INSERT INTO `sp_dispatch_order` (`id`, `order_no`, `product_code`, `product_name`, `qty`, `plan_start_time`, `plan_end_time`, `priority`, `status`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('1745491200000001001', 'WO-20260524-001', 'PRD-001', '成品A', 100, '2026-05-25 08:00:00', '2026-05-25 17:00:00', 2, 'draft', NOW(), 'admin', NOW(), 'admin'),
('1745491200000001002', 'WO-20260524-002', 'PRD-002', '成品B', 200, '2026-05-25 08:00:00', '2026-05-26 17:00:00', 1, 'draft', NOW(), 'admin', NOW(), 'admin'),
('1745491200000001003', 'WO-20260524-003', 'PRD-001', '成品A', 150, '2026-05-26 08:00:00', '2026-05-26 17:00:00', 2, 'draft', NOW(), 'admin', NOW(), 'admin');