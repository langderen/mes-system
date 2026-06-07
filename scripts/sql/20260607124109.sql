/*
MySQL Backup
Database: mes2026
Backup Time: 2026-06-07 12:41:18
*/

SET FOREIGN_KEY_CHECKS=0;
SET SESSION sql_mode=NO_AUTO_VALUE_ON_ZERO;
DROP TABLE IF EXISTS `mes2026`.`sp_dispatch_order`;
DROP TABLE IF EXISTS `mes2026`.`sp_dispatch_record`;
DROP TABLE IF EXISTS `mes2026`.`sp_flow`;
DROP TABLE IF EXISTS `mes2026`.`sp_flow_category`;
DROP TABLE IF EXISTS `mes2026`.`sp_flow_definition`;
DROP TABLE IF EXISTS `mes2026`.`sp_flow_form`;
DROP TABLE IF EXISTS `mes2026`.`sp_flow_oper_relation`;
DROP TABLE IF EXISTS `mes2026`.`sp_inbound_application`;
DROP TABLE IF EXISTS `mes2026`.`sp_inbound_order`;
DROP TABLE IF EXISTS `mes2026`.`sp_inbound_order_item`;
DROP TABLE IF EXISTS `mes2026`.`sp_line`;
DROP TABLE IF EXISTS `mes2026`.`sp_material_info`;
DROP TABLE IF EXISTS `mes2026`.`sp_material_requirement_plan`;
DROP TABLE IF EXISTS `mes2026`.`sp_mrp_record`;
DROP TABLE IF EXISTS `mes2026`.`sp_oper`;
DROP TABLE IF EXISTS `mes2026`.`sp_order`;
DROP TABLE IF EXISTS `mes2026`.`sp_part`;
DROP TABLE IF EXISTS `mes2026`.`sp_planned_inbound`;
DROP TABLE IF EXISTS `mes2026`.`sp_process_content`;
DROP TABLE IF EXISTS `mes2026`.`sp_process_material`;
DROP TABLE IF EXISTS `mes2026`.`sp_product_bom`;
DROP TABLE IF EXISTS `mes2026`.`sp_product_bom_item`;
DROP TABLE IF EXISTS `mes2026`.`sp_production_plan`;
DROP TABLE IF EXISTS `mes2026`.`sp_production_team`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_activity`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_inspection_data`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_inspection_def`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_inspection_plan`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_inspection_record`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_inspection_task`;
DROP TABLE IF EXISTS `mes2026`.`sp_qc_resource`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_department`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_dict`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_equipment`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_equipment_group`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_equipment_group_equipment`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_group`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_group_user`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_menu`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_process_unit`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_role`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_role_menu`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_user`;
DROP TABLE IF EXISTS `mes2026`.`sp_sys_user_role`;
DROP TABLE IF EXISTS `mes2026`.`sp_table_manager`;
DROP TABLE IF EXISTS `mes2026`.`sp_table_manager_item`;
DROP TABLE IF EXISTS `mes2026`.`sp_warehouse`;
DROP TABLE IF EXISTS `mes2026`.`sp_warehouse_location`;
DROP TABLE IF EXISTS `mes2026`.`sp_work_shop`;
CREATE TABLE `sp_dispatch_order`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `qty` decimal(10, 2) NOT NULL,
  `completed_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `qualified_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `scrap_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `plan_start_time` datetime NULL DEFAULT NULL,
  `plan_end_time` datetime NULL DEFAULT NULL,
  `actual_start_time` datetime NULL DEFAULT NULL,
  `actual_end_time` datetime NULL DEFAULT NULL,
  `priority` int NULL DEFAULT 2,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'draft',
  `source_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_dispatch_record`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dispatch_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dispatch_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `operator_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '人员派工用户ID(sp_sys_user)',
  `process_unit_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '加工单元ID(sp_sys_process_unit)',
  `equipment_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `plan_qty` decimal(10, 2) NOT NULL,
  `completed_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `qualified_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `scrap_qty` decimal(10, 2) NULL DEFAULT 0.00,
  `work_hours` decimal(6, 2) NULL DEFAULT 0.00,
  `dispatch_time` datetime NULL DEFAULT NULL,
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dispatch_order_id`(`dispatch_order_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_flow`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程',
  `flow_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '流程绘制JSON',
  `flow_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程类型',
  `flow_category_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程分类ID',
  `flow_category_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程分类名称',
  `product_part_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品零件ID',
  `product_part_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品零件编码',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '版本',
  `state` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `script_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '脚本内容',
  `bind_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'process' COMMENT '绑定类型(process/button)',
  `button_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '按钮编码',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_flow_category`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `category_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类编码',
  `category_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `category_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类描述',
  `sort_num` int NOT NULL DEFAULT 1 COMMENT '排序',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标记',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程分类表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_flow_definition`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程编码',
  `flow_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程名称',
  `flow_category_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程分类ID',
  `flow_category_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程分类名称',
  `flow_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程类型',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1.0' COMMENT '版本',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0:正常;1:禁用)',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程描述',
  `bind_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'process' COMMENT '绑定类型(process:流程/button:按钮)',
  `button_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '按钮编码',
  `script_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '脚本内容',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除(0:未删除;1:已删除)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_flow_code`(`flow_code` ASC) USING BTREE,
  INDEX `idx_flow_category_id`(`flow_category_id` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程定义表' ROW_FORMAT = Dynamic;
CREATE TABLE `sp_flow_form`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程ID',
  `form_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表单名称',
  `form_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表单key',
  `form_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'default' COMMENT '表单类型(default/script/url)',
  `flow_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程标题',
  `pc_form_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'PC表单地址',
  `mobile_form_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机表单地址',
  `init_script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '表单初始化脚本',
  `approve_script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审批通过脚本',
  `reject_script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审批退回脚本',
  `end_script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '流程结束脚本',
  `skip_first` tinyint(1) NULL DEFAULT 0 COMMENT '跳过第一个环节',
  `skip_same_handler` tinyint(1) NULL DEFAULT 0 COMMENT '跳过相同处理人',
  `allow_return` tinyint(1) NULL DEFAULT 1 COMMENT '允许退回',
  `allow_transfer` tinyint(1) NULL DEFAULT 1 COMMENT '允许转办',
  `allow_delegate` tinyint(1) NULL DEFAULT 1 COMMENT '允许委托',
  `allow_withdraw` tinyint(1) NULL DEFAULT 1 COMMENT '允许撤回',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_flow_id`(`flow_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程表单表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_flow_oper_relation`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程ID',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程代码',
  `per_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前道工序ID',
  `per_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前道工序代码',
  `oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前工序ID',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前工序',
  `next_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下道工序ID',
  `next_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下道工序',
  `sort_num` int NULL DEFAULT NULL COMMENT '排序',
  `oper_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序类型',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `flow_id_index`(`flow_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程与工序关系表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_inbound_application`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `application_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请单编号',
  `mrp_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源MRP编号',
  `order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源生产订单编号',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `total_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '入库总数量',
  `supplier_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `expected_delivery_date` datetime NULL DEFAULT NULL COMMENT '预计交货日期',
  `warehouse_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标仓库ID',
  `warehouse_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标仓库名称',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '状态 pending-待审核 approved-已审核 sent-已下发 receiving-收货中 completed-已完成 cancelled-已取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_application_code`(`application_code` ASC) USING BTREE,
  INDEX `idx_mrp_code`(`mrp_code` ASC) USING BTREE,
  INDEX `idx_order_code`(`order_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '入库申请单表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_inbound_order`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'primary key',
  `inbound_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'inbound no',
  `source_mrp_nos` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'source mrp nos',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'status',
  `item_count` int NULL DEFAULT 0 COMMENT 'item count',
  `total_demand_qty` decimal(18, 4) NULL DEFAULT 0.0000 COMMENT 'total demand qty',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'remark',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT 'deleted flag',
  `warehouse_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'warehouse id',
  `warehouse_location_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'warehouse location id',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_inbound_no`(`inbound_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_warehouse_id`(`warehouse_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'plan inbound order' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_inbound_order_item`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'primary key',
  `inbound_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'inbound order id',
  `source_mrp_record_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'source mrp record id',
  `mrp_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'mrp no',
  `order_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'source order no',
  `bom_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'bom code',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'product code',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'product name',
  `part_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'part code',
  `part_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'part name',
  `demand_qty` decimal(18, 4) NULL DEFAULT NULL COMMENT 'demand qty',
  `unit` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'unit',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT 'deleted flag',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_inbound_order_id`(`inbound_order_id` ASC) USING BTREE,
  INDEX `idx_source_mrp_record_id`(`source_mrp_record_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'plan inbound order item' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_line`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体',
  `line_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process_section` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序段代号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '线体表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_material_info`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料名称',
  `mat_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料类型',
  `mat_source` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料来源',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `texture` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '材质',
  `model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `size` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '尺寸',
  `lead_time` decimal(10, 2) NULL DEFAULT NULL COMMENT '物料需求提前期(天)',
  `safety_stock` decimal(10, 2) NULL DEFAULT NULL COMMENT '安全库存',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_material_info_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料信息定义表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_material_requirement_plan`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `mrp_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MRP编号',
  `order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源生产订单编号',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生产订单ID',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM ID',
  `material_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `material_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料名称',
  `material_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料规格',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `unit_qty` decimal(10, 2) NULL DEFAULT NULL COMMENT '单件用量',
  `total_qty` decimal(10, 2) NOT NULL COMMENT '需求总数量',
  `available_stock` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '可用库存',
  `shortage_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '缺货数量',
  `supplier_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `delivery_date` datetime NULL DEFAULT NULL COMMENT '要求交货日期',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '状态 pending-待下发 issued-已下发 completed-已完成',
  `inbound_application_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联入库申请单ID',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mrp_code`(`mrp_code` ASC) USING BTREE,
  INDEX `idx_order_code`(`order_code` ASC) USING BTREE,
  INDEX `idx_material_code`(`material_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料需求计划表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_mrp_record`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'primary key',
  `mrp_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'mrp no',
  `order_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'source order no',
  `bom_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'bom code',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'product code',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'product name',
  `part_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'part code',
  `part_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'part name',
  `demand_qty` decimal(18, 4) NULL DEFAULT NULL COMMENT 'demand qty',
  `unit` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'unit',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mrp_no`(`mrp_no` ASC) USING BTREE,
  INDEX `idx_order_code`(`order_code` ASC) USING BTREE,
  INDEX `idx_part_code`(`part_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'mrp record' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_oper`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序\r\n',
  `oper_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序描述',
  `oper_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序类型:加工/装配/检验/包装/搬运',
  `standard_time` decimal(10, 2) NULL DEFAULT NULL COMMENT '标准工时(分钟)',
  `equipment_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所需设备类型',
  `is_key_oper` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否关键工序:0否,1是',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工序表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_order`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `order_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '工单编号',
  `order_description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '工单描述',
  `qty` int NULL DEFAULT NULL COMMENT '工单数量',
  `order_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '订单类型 P 量产 A验证 F返工 ',
  `flow_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '流程ID',
  `materiel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料描述',
  `plan_start_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '计划结束时间',
  `statue` tinyint NULL DEFAULT NULL COMMENT '1,创建 2 进行中，3订单结束，4订单终结',
  `source_order_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'source order no',
  `generated_plan_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'generated plan no',
  `generated_mrp_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'generated mrp no',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_part`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `part_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件编码',
  `part_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件名称',
  `part_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '零部件类型:原料/半成品/成品/辅料/包装',
  `spec` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基本单位',
  `material` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '材质',
  `weight` decimal(12, 4) NULL DEFAULT NULL COMMENT '重量(kg)',
  `drawing_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图号',
  `version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '版本号',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态:0正常,1停用',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_part_code`(`part_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '零部件定义表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_planned_inbound`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `inbound_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计划入库编号',
  `application_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '入库申请单ID',
  `application_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '入库申请单编号',
  `order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源生产订单编号',
  `material_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `material_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料名称',
  `qty` decimal(10, 2) NOT NULL COMMENT '入库数量',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `supplier_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `supplier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `warehouse_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '仓库ID',
  `warehouse_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `location_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库位编码',
  `logistics_company` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物流公司',
  `logistics_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物流单号',
  `estimated_arrival_date` datetime NULL DEFAULT NULL COMMENT '预计到达日期',
  `actual_arrival_date` datetime NULL DEFAULT NULL COMMENT '实际到达日期',
  `qc_inspector_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检员ID',
  `qc_result` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检结果 pass-合格 fail-不合格',
  `qc_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检备注',
  `step` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'order_processed' COMMENT '当前步骤 order_processed-订单已处理 supplier_coordinated-供应商已协调 logistics_arranged-物流已安排 warehouse_ready-仓储已准备 qc_completed-质检完成 inbound_completed-已入库',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'processing' COMMENT '状态 processing-进行中 completed-已完成 cancelled-已取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_inbound_code`(`inbound_code` ASC) USING BTREE,
  INDEX `idx_application_id`(`application_id` ASC) USING BTREE,
  INDEX `idx_order_code`(`order_code` ASC) USING BTREE,
  INDEX `idx_material_code`(`material_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_step`(`step` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '计划入库表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_process_content`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序ID',
  `bom_item_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM子项ID',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM ID',
  `oper_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序编号',
  `oper_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序名称',
  `work_hour` decimal(10, 2) NULL DEFAULT NULL COMMENT '标准工时（分钟）',
  `oper_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序类型',
  `oper_step` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工艺操作步骤',
  `tech_require` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '技术要求',
  `notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '注意事项',
  `equipment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生产设备',
  `tooling` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工装夹具',
  `cutter` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '刀具/量具',
  `img_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工艺图片/附件（JSON格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'edit' COMMENT '状态：edit-编制中，lock-已锁定',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_time` datetime NULL DEFAULT NULL,
  `create_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;
CREATE TABLE `sp_process_material`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序ID',
  `material_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `material_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料名称',
  `qty` decimal(10, 4) NULL DEFAULT NULL COMMENT '用量',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_time` datetime NULL DEFAULT NULL,
  `create_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;
CREATE TABLE `sp_product_bom`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM编码',
  `bom_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM名称',
  `product_part_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品零部件id',
  `product_part_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品零部件编码',
  `product_part_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品零部件名称',
  `version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '版本号',
  `bom_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM类型:EBOM/MBOM/SBOM',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'create' COMMENT 'BOM状态:create创建,pass审核通过,reject驳回',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_product_bom_code`(`bom_code` ASC) USING BTREE,
  INDEX `idx_product_bom_part`(`product_part_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品BOM主表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_product_bom_item`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属BOM主表id',
  `parent_item_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '父级BOM子项id(顶级为空,用于实现层级关系)',
  `part_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件id',
  `part_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件编码',
  `part_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '零部件名称',
  `line_no` int NOT NULL DEFAULT 0 COMMENT '行号',
  `level_no` int NOT NULL DEFAULT 1 COMMENT '层级(1为顶层)',
  `qty` decimal(12, 4) NOT NULL DEFAULT 1.0000 COMMENT '用量',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `scrap_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '损耗率(%)',
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联工序id',
  `oper_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联工序编码',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pbom_item_bom_id`(`bom_id` ASC) USING BTREE,
  INDEX `idx_pbom_item_parent`(`parent_item_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品BOM子项表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_production_plan`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `plan_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计划编号',
  `plan_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计划名称',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联订单id',
  `order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联订单编号',
  `order_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单类型(demand需求订单/forecast预测订单)',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `product_spec` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品规格',
  `plan_qty` int NULL DEFAULT NULL COMMENT '计划生产数量',
  `unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `scheduling_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'forward' COMMENT '排产方式(forward正向/backward逆向)',
  `plan_start_time` datetime NULL DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` datetime NULL DEFAULT NULL COMMENT '计划结束时间',
  `flow_instance_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联流程实例id',
  `approval_status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '审批状态(0未提交/1审批中/2已通过/3已退回/4已终止)',
  `plan_status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '计划状态(0未执行/1进行中/2已完成/3已取消)',
  `customer_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '客户名称',
  `contract_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '销售合同号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生产计划表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_production_team`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'production',
  `workshop_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `line_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `leader_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active',
  `sort_no` int NULL DEFAULT 0,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_team_code`(`team_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_activity`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `activity_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动编码',
  `activity_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动名称',
  `activity_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动类型 iqc-来料检验 ipqc-过程检验 oqc-出货检验 spc-统计过程控制 msa-测量系统分析',
  `trigger_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'manual' COMMENT '触发方式 manual-手动 schedule-定时 event-事件',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联产品编码',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联BOM ID',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联工单ID',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'draft' COMMENT '状态 draft-草稿 active-进行中 paused-暂停 completed-完成 cancelled-取消',
  `priority` int NULL DEFAULT 2 COMMENT '优先级 1-高 2-中 3-低',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_activity_code`(`activity_code` ASC) USING BTREE,
  INDEX `idx_activity_type`(`activity_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_product_code`(`product_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质量活动表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_inspection_data`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `record_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联执行记录ID',
  `task_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联任务ID',
  `parameter_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数名称',
  `parameter_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数编码',
  `measured_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '实测值',
  `standard_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标准值',
  `min_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下限值',
  `max_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上限值',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `is_pass` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否合格 0-否 1-是',
  `collect_time` datetime NULL DEFAULT NULL COMMENT '采集时间',
  `collect_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '采集方式 manual-手动 auto-自动 scan-扫码',
  `equipment_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '采集设备ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_record_id`(`record_id` ASC) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_parameter_code`(`parameter_code` ASC) USING BTREE,
  INDEX `idx_collect_time`(`collect_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检数据收集表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_inspection_def`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `def_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '定义编码',
  `def_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '定义名称',
  `inspection_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检验类型 iqc-来料检验 ipqc-过程检验 oqc-出货检验',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品编码',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM ID',
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联工序ID',
  `inspection_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'visual' COMMENT '检验方法 visual-目视 measure-测量 test-试验 sample-抽样',
  `inspection_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检验项目',
  `standard_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标准值',
  `tolerance_upper` decimal(14, 4) NULL DEFAULT NULL COMMENT '上公差',
  `tolerance_lower` decimal(14, 4) NULL DEFAULT NULL COMMENT '下公差',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `sample_plan` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抽样方案',
  `aql_level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'AQL等级',
  `sample_qty` int NULL DEFAULT NULL COMMENT '抽样数量',
  `is_critical` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否关键检验项 0-否 1-是',
  `sort_no` int NULL DEFAULT 0 COMMENT '排序号',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态 active-启用 inactive-停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_def_code`(`def_code` ASC) USING BTREE,
  INDEX `idx_inspection_type`(`inspection_type` ASC) USING BTREE,
  INDEX `idx_product_code`(`product_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检定义表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_inspection_plan`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `plan_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计划编码',
  `plan_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计划名称',
  `activity_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联质量活动ID',
  `inspection_def_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '质检定义ID',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联工单ID(sp_dispatch_order)',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品编码',
  `plan_qty` decimal(10, 2) NOT NULL COMMENT '计划检验数量',
  `completed_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已完成检验数量',
  `pass_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '合格数量',
  `fail_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '不合格数量',
  `plan_start_time` datetime NULL DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` datetime NULL DEFAULT NULL COMMENT '计划结束时间',
  `actual_start_time` datetime NULL DEFAULT NULL COMMENT '实际开始时间',
  `actual_end_time` datetime NULL DEFAULT NULL COMMENT '实际结束时间',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '状态 pending-待执行 executing-执行中 completed-已完成 closed-关闭',
  `priority` int NULL DEFAULT 2 COMMENT '优先级 1-高 2-中 3-低',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plan_code`(`plan_code` ASC) USING BTREE,
  INDEX `idx_inspection_def_id`(`inspection_def_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检调度计划表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_inspection_record`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `record_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '记录编码',
  `task_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联任务ID',
  `inspection_def_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '质检定义ID',
  `inspector_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检验员ID(sp_sys_user)',
  `inspection_time` datetime NULL DEFAULT NULL COMMENT '检验时间',
  `result` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检验结果 pass-合格 fail-不合格 rework-返工 scrap-报废',
  `defect_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缺陷类型 appearance-外观 dimension-尺寸 function-功能 material-材质',
  `defect_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缺陷描述',
  `defect_qty` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '缺陷数量',
  `defect_severity` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缺陷等级 critical-致命 major-严重 minor-轻微',
  `measured_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '实测值',
  `standard_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标准值',
  `handle_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理方式 rework-返工 scrap-报废 concession-让步接收 return-退货',
  `handle_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理备注',
  `attachment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '附件路径',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_record_code`(`record_code` ASC) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_inspector_id`(`inspector_id` ASC) USING BTREE,
  INDEX `idx_result`(`result` ASC) USING BTREE,
  INDEX `idx_inspection_time`(`inspection_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检执行记录表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_inspection_task`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `task_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务编号',
  `plan_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检计划ID',
  `inspection_def_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检定义ID',
  `inspector_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质检员ID',
  `process_unit_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '加工单元ID',
  `assigned_qty` decimal(10, 2) NULL DEFAULT NULL COMMENT '分配数量',
  `completed_qty` int NULL DEFAULT 0 COMMENT '已完成数量',
  `pass_qty` int NULL DEFAULT 0 COMMENT '合格数量',
  `fail_qty` int NULL DEFAULT 0 COMMENT '不合格数量',
  `assign_time` datetime NULL DEFAULT NULL COMMENT '分配时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '状态 pending-待执行 assigned-已分配 executing-执行中 completed-已完成 cancelled-已取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_code`(`task_code` ASC) USING BTREE,
  INDEX `idx_plan_id`(`plan_id` ASC) USING BTREE,
  INDEX `idx_inspector_id`(`inspector_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检任务表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_qc_resource`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `resource_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资源编码',
  `resource_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资源名称',
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资源类型 equipment-设备 tool-工具 gauge-量具 fixture-夹具',
  `resource_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `manufacturer` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存放位置',
  `calibration_cycle` int NULL DEFAULT NULL COMMENT '校准周期(天)',
  `last_calibration_date` date NULL DEFAULT NULL COMMENT '上次校准日期',
  `next_calibration_date` date NULL DEFAULT NULL COMMENT '下次校准日期',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态 active-正常 inactive-停用 scrapped-报废 maintenance-维修中',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_resource_code`(`resource_code` ASC) USING BTREE,
  INDEX `idx_resource_type`(`resource_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '质检资源表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_department`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_num` int NOT NULL,
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_dict`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名',
  `value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据值',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `sort_num` int NOT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '父级id',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sp_sys_dict_name`(`type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统字典表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_equipment`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编码',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备名称',
  `model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备型号',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备类型',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '运行状态:0正常,1故障,2维修中,3报废',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生产设备表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_equipment_group`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编组代码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编组名称',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_equipment_group_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备编组表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_equipment_group_equipment`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `equipment_group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编组id',
  `equipment_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_equ_group_id`(`equipment_group_id` ASC) USING BTREE,
  INDEX `idx_equ_id`(`equipment_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备编组设备关联表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_group`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '编组代码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班组名称',
  `descr` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0:删除;1:正常;2:禁用)',
  `create_time` datetime NULL DEFAULT NULL,
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_group_user`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班组ID',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT NULL,
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_menu`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单URL',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父菜单ID，一级菜单设为0',
  `grade` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '层级：1级、2级、3级......',
  `sort_num` int NOT NULL COMMENT '排序',
  `type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：0 目录；1 菜单；2 按钮',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '菜单图标',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_menu_name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_menu_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_process_unit`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单元编码',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单元名称',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联班组id',
  `equipment_group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联设备编组id',
  `daily_standard_capacity` decimal(10, 2) NULL DEFAULT NULL COMMENT '日标准产能',
  `has_limited_side_storage` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否有有限边库:0否,1是',
  `side_storage_capacity` decimal(10, 2) NULL DEFAULT NULL COMMENT '边库容量',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '运行状态:0正常,1停用',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '加工单元表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_role`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '角色描述',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_role_name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_role_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_role_menu`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `menu_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色对应的菜单表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_user`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '部门id',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '邮箱',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `tel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '固定电话',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '性别(0:女;1:男;2:其他)',
  `birthday` datetime NULL DEFAULT NULL COMMENT '出生年月日',
  `pic_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '图片id，对应sys_file表中的id',
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '身份证',
  `hobby` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '爱好',
  `province` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '省份',
  `city` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '城市',
  `district` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '区县',
  `street` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '街道',
  `street_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '门牌号',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_user_username`(`username` ASC) USING BTREE COMMENT '用户名唯一索引',
  UNIQUE INDEX `idx_sp_sys_user_mobile`(`mobile` ASC) USING BTREE COMMENT '用户手机号唯一索引',
  INDEX `idx_sp_sys_user_email`(`email` ASC) USING BTREE COMMENT '用户邮箱唯一索引',
  INDEX `idx_sp_sys_user_id_card`(`id_card` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_sys_user_role`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户对应的角色表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_table_manager`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称',
  `table_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '\"\"' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `index1`(`table_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '主数据通用管理' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_table_manager_item`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称id',
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段',
  `field_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段描述',
  `must_fill` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否必填',
  `sort_num` int NOT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '主数据基础数据明细表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_warehouse`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库房编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库房名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库房类型:原料仓/半成品仓/成品仓/线边仓',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库房地址',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态:0正常,1停用',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `total_inventory` decimal(18, 4) NULL DEFAULT 0.0000 COMMENT 'warehouse total inventory',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_warehouse_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库房表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_warehouse_location`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `warehouse_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属库房id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库位编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库位名称',
  `row_no` int NOT NULL DEFAULT 0 COMMENT '行号(用于看板定位)',
  `col_no` int NOT NULL DEFAULT 0 COMMENT '列号(用于看板定位)',
  `location_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库位类型:存储位/暂存位/检验位/不良品位',
  `max_capacity` decimal(12, 2) NULL DEFAULT NULL COMMENT '最大容量',
  `current_inventory` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '当前库存量',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '库位状态:0空闲,1使用中,2已满,3超储',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_whloc_warehouse_id`(`warehouse_id` ASC) USING BTREE,
  INDEX `idx_whloc_position`(`row_no` ASC, `col_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库位表' ROW_FORMAT = DYNAMIC;
CREATE TABLE `sp_work_shop`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `work_shop` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `work_shop_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作车间表' ROW_FORMAT = DYNAMIC;
BEGIN;
LOCK TABLES `mes2026`.`sp_dispatch_order` WRITE;
DELETE FROM `mes2026`.`sp_dispatch_order`;
INSERT INTO `mes2026`.`sp_dispatch_order` (`id`,`order_no`,`product_code`,`product_name`,`bom_id`,`qty`,`completed_qty`,`qualified_qty`,`scrap_qty`,`plan_start_time`,`plan_end_time`,`actual_start_time`,`actual_end_time`,`priority`,`status`,`source_order_no`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1745491200000001001', 'WO-20260524-001', 'PRD-001', '成品A', NULL, 100.00, 0.00, 0.00, 0.00, '2026-05-25 08:00:00', '2026-05-25 17:00:00', NULL, NULL, 2, 'assigned', NULL, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 22:46:59', 'admin'),('1745491200000001002', 'WO-20260524-002', 'PRD-002', '成品B', NULL, 200.00, 0.00, 0.00, 0.00, '2026-05-25 08:00:00', '2026-05-26 17:00:00', NULL, NULL, 1, 'draft', NULL, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 00:10:04', 'admin'),('1745491200000001003', 'WO-20260524-003', 'PRD-001', '成品A', NULL, 150.00, 0.00, 0.00, 0.00, '2026-05-26 08:00:00', '2026-05-26 17:00:00', NULL, NULL, 2, 'draft', NULL, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 00:10:04', 'admin'),('2060184884479016961', 'PLAN-20260529102207', '103', 'CPU', NULL, 123.00, 0.00, 0.00, 0.00, '2026-05-29 10:21:44', '2026-05-29 10:21:45', NULL, NULL, 2, 'draft', '213123', '2313', '0', '2026-05-29 10:22:08', 'admin', '2026-05-29 10:22:08', 'admin'),('2060189500520308738', 'PLAN-20260529104028', '1', '电脑', NULL, 234.00, 0.00, 0.00, 0.00, '2026-05-29 10:40:13', '2026-05-29 10:40:14', NULL, NULL, 2, 'draft', '324324', '34324', '0', '2026-05-29 10:40:28', 'admin', '2026-05-29 10:40:28', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_dispatch_record` WRITE;
DELETE FROM `mes2026`.`sp_dispatch_record`;
INSERT INTO `mes2026`.`sp_dispatch_record` (`id`,`dispatch_order_id`,`dispatch_type`,`team_id`,`operator_id`,`user_id`,`process_unit_id`,`equipment_id`,`plan_qty`,`completed_qty`,`qualified_qty`,`scrap_qty`,`work_hours`,`dispatch_time`,`start_time`,`end_time`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058922782233772034', '1745491200000001001', 'person', '2058378411801403394', NULL, '2058217005470736386', '2058383728161341442', NULL, 100.00, 0.00, 0.00, 0.00, 0.00, '2026-05-25 22:46:58', NULL, NULL, 'pending', NULL, '0', '2026-05-25 22:46:59', 'admin', '2026-05-25 22:46:59', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_flow` WRITE;
DELETE FROM `mes2026`.`sp_flow`;
INSERT INTO `mes2026`.`sp_flow` (`id`,`flow`,`flow_desc`,`process`,`flow_type`,`flow_category_id`,`flow_category_name`,`product_part_id`,`product_part_code`,`version`,`state`,`script_content`,`bind_type`,`button_code`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060265702731882497', '324234', '32423', '{\"nodes\":[{\"id\":\"node_1780047016893_1\",\"operId\":1336864575324192,\"title\":\"APK-01\",\"desc\":\"APK-01\",\"type\":\"task\",\"sortNo\":1,\"x\":120,\"y\":100},{\"id\":\"node_1780047018881_2\",\"operId\":1336864537575456,\"title\":\"TST-02\",\"desc\":\"TST-02\",\"type\":\"task\",\"sortNo\":2,\"x\":357,\"y\":120},{\"id\":\"node_1780048760497_3\",\"operId\":1336864613072928,\"title\":\"TST-01\",\"desc\":\"TST-01\",\"type\":\"task\",\"sortNo\":3,\"x\":395,\"y\":313}],\"links\":[{\"from\":\"node_1780047016893_1\",\"to\":\"node_1780047018881_2\"},{\"from\":\"node_1780047016893_1\",\"to\":\"node_1780048760497_3\"}]}', NULL, '2060261587574374401', '234', NULL, NULL, NULL, '0', '', 'process', '4234', '0', '2026-05-29 15:43:16', 'admin', '2026-05-29 17:59:31', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_flow_category` WRITE;
DELETE FROM `mes2026`.`sp_flow_category`;
INSERT INTO `mes2026`.`sp_flow_category` (`id`,`category_code`,`category_name`,`category_desc`,`sort_num`,`state`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060261587574374401', '34', '234', '234', 1, '0', '0', '2026-05-29 15:26:55', 'admin', '2026-05-29 15:26:55', 'admin'),('2060263655907360769', 'prod', '生产流程', '', 30, '0', '0', '2026-05-29 15:35:08', 'admin', '2026-05-29 15:35:08', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_flow_definition` WRITE;
DELETE FROM `mes2026`.`sp_flow_definition`;
INSERT INTO `mes2026`.`sp_flow_definition` (`id`,`flow_code`,`flow_name`,`flow_category_id`,`flow_category_name`,`flow_type`,`version`,`state`,`description`,`bind_type`,`button_code`,`script_content`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060715117737172994', '2312', '123219149122', '2060261587574374401', '234', '3221', '1.0', '0', '', 'process', '2323', NULL, '0', '2026-05-30 21:29:05', 'admin', '2026-05-30 21:29:05', 'admin'),('2063298836528390145', 'FLOW_IT_001', '测试流程', NULL, NULL, 'production', '1.0', '0', NULL, 'process', NULL, NULL, '0', '2026-06-07 00:35:52', 'system', '2026-06-07 00:35:52', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_flow_form` WRITE;
DELETE FROM `mes2026`.`sp_flow_form`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_flow_oper_relation` WRITE;
DELETE FROM `mes2026`.`sp_flow_oper_relation`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_inbound_application` WRITE;
DELETE FROM `mes2026`.`sp_inbound_application`;
INSERT INTO `mes2026`.`sp_inbound_application` (`id`,`application_code`,`mrp_code`,`order_code`,`product_code`,`product_name`,`total_qty`,`supplier_code`,`supplier_name`,`expected_delivery_date`,`warehouse_id`,`warehouse_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1760000000000000021', 'INB-20260526140000', 'MRP-20260526-HC001', 'WO-20260524-001', 'PRD-001', '成品A', 1100.00, 'SUP-001', '钢材供应商A', '2026-05-28 08:00:00', 'WH-001', '原料仓A区', 'pending', NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_inbound_order` WRITE;
DELETE FROM `mes2026`.`sp_inbound_order`;
INSERT INTO `mes2026`.`sp_inbound_order` (`id`,`inbound_no`,`source_mrp_nos`,`status`,`item_count`,`total_demand_qty`,`remark`,`is_deleted`,`warehouse_id`,`warehouse_location_id`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060196743307329538', 'IB-20260529110914', 'MRP-20260529104028,MRP-20260529104028,MRP-20260529104028', 'confirmed', 3, 936.0000, NULL, '0', 'wh001', 'loc001', '2026-05-29 11:09:15', 'admin', '2026-05-29 11:09:58', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_inbound_order_item` WRITE;
DELETE FROM `mes2026`.`sp_inbound_order_item`;
INSERT INTO `mes2026`.`sp_inbound_order_item` (`id`,`inbound_order_id`,`source_mrp_record_id`,`mrp_no`,`order_code`,`bom_code`,`product_code`,`product_name`,`part_code`,`part_name`,`demand_qty`,`unit`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060196743340883970', '2060196743307329538', '2060189500625166337', 'MRP-20260529104028', '324324', '12', '1', '电脑', '101', '玻璃板', 234.0000, '', '0', '2026-05-29 11:09:15', 'admin', '2026-05-29 11:09:15', 'admin'),('2060196743345078273', '2060196743307329538', '2060189500629360642', 'MRP-20260529104028', '324324', '12', '1', '电脑', '102', '铁板', 468.0000, '', '0', '2026-05-29 11:09:15', 'admin', '2026-05-29 11:09:15', 'admin'),('2060196743349272578', '2060196743307329538', '2060189500629360643', 'MRP-20260529104028', '324324', '12', '1', '电脑', '103', 'CPU', 234.0000, '个', '0', '2026-05-29 11:09:15', 'admin', '2026-05-29 11:09:15', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_line` WRITE;
DELETE FROM `mes2026`.`sp_line`;
INSERT INTO `mes2026`.`sp_line` (`id`,`line`,`line_desc`,`process_section`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1336867983196192', 'WZY-ASY-01', '装配线体01线', '从vv', '2020-03-14 10:32:10', 'admin', '2020-06-14 02:20:09', 'admin'),('1336868041916448', 'WZY-TEST-01', '测试01线体', 'TST', '2020-03-14 10:32:38', 'admin', '2020-03-14 10:32:38', 'admin'),('1336868662673440', 'WZY-DC-01', '电池组装01线', 'ASY', '2020-03-14 10:37:34', 'admin', '2020-06-16 11:47:04', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_material_info` WRITE;
DELETE FROM `mes2026`.`sp_material_info`;
INSERT INTO `mes2026`.`sp_material_info` (`id`,`code`,`name`,`mat_type`,`mat_source`,`unit`,`texture`,`model`,`size`,`lead_time`,`safety_stock`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`,`image_url`) VALUES ('2058374871985004545', '202605240001', '电脑', 'FG', '2', '台', '2', '13', '300*400*200', 3.00, 100.00, '', '0', '2026-05-24 10:29:47', 'admin', '2026-06-06 17:36:45', 'admin', '/upload/2026/06/06/2b040374c9dc4821beb0273394203ee8.JPG'),('2063298816127295489', 'MAT_IT_001', '测试物料', '原材料', NULL, '个', NULL, NULL, NULL, NULL, NULL, NULL, '0', '2026-06-07 00:35:47', 'system', '2026-06-07 00:35:47', 'system', NULL),('2063298820455817218', 'MAT_E2E_001', '测试原材料', '原材料', NULL, '个', NULL, NULL, NULL, NULL, NULL, NULL, '0', '2026-06-07 00:35:48', 'system', '2026-06-07 00:35:48', 'system', NULL)
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_material_requirement_plan` WRITE;
DELETE FROM `mes2026`.`sp_material_requirement_plan`;
INSERT INTO `mes2026`.`sp_material_requirement_plan` (`id`,`mrp_code`,`order_code`,`order_id`,`product_code`,`product_name`,`bom_id`,`material_code`,`material_name`,`material_spec`,`unit`,`unit_qty`,`total_qty`,`available_stock`,`shortage_qty`,`supplier_code`,`supplier_name`,`delivery_date`,`status`,`inbound_application_id`,`sort_no`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1760000000000000011', 'MRP-20260526-HC001', 'WO-20260524-001', '1745491200000001001', 'PRD-001', '成品A', '1336870706896933', 'MAT-001', '钢材-SUS304', '2.0mm', 'kg', 5.00, 500.00, 200.00, 300.00, 'SUP-001', '钢材供应商A', '2026-05-28 08:00:00', 'pending', NULL, 1, NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin'),('1760000000000000012', 'MRP-20260526-HC001', 'WO-20260524-001', '1745491200000001001', 'PRD-001', '成品A', '1336870706896933', 'MAT-002', '铝材-6061', '3.0mm', 'kg', 3.00, 300.00, 150.00, 150.00, 'SUP-002', '铝材供应商B', '2026-05-28 08:00:00', 'pending', NULL, 2, NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin'),('1760000000000000013', 'MRP-20260526-HC001', 'WO-20260524-001', '1745491200000001001', 'PRD-001', '成品A', '1336870706896933', 'MAT-003', '铜材-H62', '1.5mm', 'kg', 2.00, 200.00, 80.00, 120.00, 'SUP-003', '铜材供应商C', '2026-05-28 08:00:00', 'pending', NULL, 3, NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin'),('1760000000000000014', 'MRP-20260526-HC001', 'WO-20260524-001', '1745491200000001001', 'PRD-001', '成品A', '1336870706896933', 'MAT-004', '塑料-ABS', 'PC-ABS', 'pcs', 1.00, 100.00, 500.00, 0.00, 'SUP-004', '塑料供应商D', '2026-05-28 08:00:00', 'pending', NULL, 4, NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_mrp_record` WRITE;
DELETE FROM `mes2026`.`sp_mrp_record`;
INSERT INTO `mes2026`.`sp_mrp_record` (`id`,`mrp_no`,`order_code`,`bom_code`,`product_code`,`product_name`,`part_code`,`part_name`,`demand_qty`,`unit`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060189500625166337', 'MRP-20260529104028', '324324', '12', '1', '电脑', '101', '玻璃板', 234.0000, '', '2026-05-29 10:40:28', 'admin', '2026-05-29 10:40:28', 'admin'),('2060189500629360642', 'MRP-20260529104028', '324324', '12', '1', '电脑', '102', '铁板', 468.0000, '', '2026-05-29 10:40:28', 'admin', '2026-05-29 10:40:28', 'admin'),('2060189500629360643', 'MRP-20260529104028', '324324', '12', '1', '电脑', '103', 'CPU', 234.0000, '个', '2026-05-29 10:40:28', 'admin', '2026-05-29 10:40:28', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_oper` WRITE;
DELETE FROM `mes2026`.`sp_oper`;
INSERT INTO `mes2026`.`sp_oper` (`id`,`oper`,`oper_desc`,`oper_type`,`standard_time`,`equipment_type`,`is_key_oper`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1336864489340960', 'ASY-01', '装配工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:04:24', 'admin', '2020-03-14 10:04:24', 'admin'),('1336864537575456', 'TST-02', '测试工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:04:47', 'admin', '2020-03-14 10:04:47', 'admin'),('1336864575324192', 'APK-01', '包装工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:05:05', 'admin', '2020-03-14 10:05:05', 'admin'),('1336864613072928', 'TST-01', '集成测试工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:05:23', 'admin', '2020-03-14 10:05:23', 'admin'),('1336868360683552', 'HJ-01', '焊接', NULL, NULL, NULL, '0', '0', '2020-03-14 10:35:10', 'admin', '2020-03-14 10:35:10', 'admin'),('1336868452958240', 'FJ-01', '封胶工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:35:54', 'admin', '2020-03-14 10:35:54', 'admin'),('1336868507484192', 'JS-01', '加酸工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:36:20', 'admin', '2020-03-14 10:36:20', 'admin'),('1336868562010144', 'QX-01', '清洗工序', NULL, NULL, NULL, '0', '0', '2020-03-14 10:36:46', 'admin', '2020-03-14 10:36:46', 'admin'),('1337248255574048', 'RK-01', '入库工序', NULL, NULL, NULL, '0', '0', '2020-03-16 12:54:18', 'admin', '2020-03-16 12:54:18', 'admin'),('2063293391411650561', NULL, NULL, NULL, NULL, NULL, '0', '0', '2026-06-07 00:14:13', 'system', '2026-06-07 00:14:13', 'system'),('2063293394389606402', NULL, NULL, NULL, NULL, NULL, '0', '0', '2026-06-07 00:14:14', 'system', '2026-06-07 00:14:14', 'system'),('2063298824658509825', 'OP_IT_001', '测试工序', '机加工序', NULL, NULL, '0', '0', '2026-06-07 00:35:49', 'system', '2026-06-07 00:35:49', 'system'),('2063438187631501313', 'OP_IT_001', '测试工序', '机加工序', NULL, NULL, '0', '0', '2026-06-07 09:49:35', 'system', '2026-06-07 09:49:35', 'system'),('2063440535774834690', 'OP_IT_001', '测试工序', '机加工序', NULL, NULL, '0', '0', '2026-06-07 09:58:55', 'system', '2026-06-07 09:58:55', 'system'),('2063441411142971394', 'OP_IT_001', '测试工序', '机加工序', NULL, NULL, '0', '0', '2026-06-07 10:02:24', 'system', '2026-06-07 10:02:24', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_order` WRITE;
DELETE FROM `mes2026`.`sp_order`;
INSERT INTO `mes2026`.`sp_order` (`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`source_order_no`,`generated_plan_no`,`generated_mrp_no`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060189455364431874', '324324', '34324', 234, 'P', '234324', '1', '电脑', '2026-05-29 10:40:13', '2026-05-29 10:40:14', 4, '324324', 'PLAN-20260529104028', 'MRP-20260529104028', '2026-05-29 10:40:17', 'admin', '2026-05-29 10:40:28', 'admin'),('2063298821504393218', 'ORD_E2E_001', '端到端测试订单', 100, NULL, NULL, 'P_E2E_001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 00:35:48', 'system', '2026-06-07 00:35:48', 'system'),('2063298822955622401', 'ORD_IT_001', '集成测试订单', 100, NULL, NULL, 'P001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 00:35:48', 'system', '2026-06-07 00:35:48', 'system'),('2063438184565465089', 'ORD_E2E_001', '端到端测试订单', 100, NULL, NULL, 'P_E2E_001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 09:49:35', 'system', '2026-06-07 09:49:35', 'system'),('2063438185983139841', 'ORD_IT_001', '集成测试订单', 100, NULL, NULL, 'P001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 09:49:35', 'system', '2026-06-07 09:49:35', 'system'),('2063440532956262401', 'ORD_E2E_001', 'End-to-end test order', 100, NULL, NULL, 'P_E2E_001', 'Test Product', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 09:58:55', 'system', '2026-06-07 09:58:55', 'system'),('2063440534264885249', 'ORD_IT_001', '集成测试订单', 100, NULL, NULL, 'P001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 09:58:55', 'system', '2026-06-07 09:58:55', 'system'),('2063441408219541505', 'ORD_E2E_001', 'End-to-end test order', 100, NULL, NULL, 'P_E2E_001', 'Test Product', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 10:02:23', 'system', '2026-06-07 10:02:23', 'system'),('2063441409603661826', 'ORD_IT_001', '集成测试订单', 100, NULL, NULL, 'P001', '测试产品', NULL, '0', 1, NULL, NULL, NULL, '2026-06-07 10:02:24', 'system', '2026-06-07 10:02:24', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_part` WRITE;
DELETE FROM `mes2026`.`sp_part`;
INSERT INTO `mes2026`.`sp_part` (`id`,`part_code`,`part_name`,`part_type`,`spec`,`unit`,`material`,`weight`,`drawing_no`,`version`,`status`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058404060490387458', '101', '玻璃板', '原料', '2', '个', '玻璃', 5.0000, '032', '1', '0', '', '0', '2026-05-24 12:25:46', 'admin', '2026-05-24 12:25:46', 'admin'),('2058404866010664962', '102', '铁板', '原料', '2', '片', '铁材', 4.0000, '035', '1', '0', '', '0', '2026-05-24 12:28:58', 'admin', '2026-05-24 12:29:28', 'admin'),('2058404918946975746', '104', '木板', '原料', '3', '片', '木材', 4.0000, '035', '1', '0', '', '0', '2026-05-24 12:29:11', 'admin', '2026-05-24 12:29:11', 'admin'),('2058413189191774209', '1', '电脑', '成品', '12', '个', '其他', 21.0000, '2', '1', '0', '', '0', '2026-05-24 13:02:02', 'admin', '2026-05-24 13:02:02', 'admin'),('2058431392013938690', '10', '主板', '半成品', '1', '个', '其他', 0.5000, '2', '1', '0', '', '0', '2026-05-24 14:14:22', 'admin', '2026-05-24 14:14:22', 'admin'),('2058431588286394369', '103', 'CPU', '半成品', '1', '个', '31', 31.0000, '13', '1', '0', '', '0', '2026-05-24 14:15:09', 'admin', '2026-05-24 14:15:09', 'admin'),('2058431961306820609', '11', '机箱', '半成品', '2', '个', '其他', 1.0000, '5', '1', '0', '', '0', '2026-05-24 14:16:38', 'admin', '2026-06-06 22:44:31', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_planned_inbound` WRITE;
DELETE FROM `mes2026`.`sp_planned_inbound`;
INSERT INTO `mes2026`.`sp_planned_inbound` (`id`,`inbound_code`,`application_id`,`application_code`,`order_code`,`material_code`,`material_name`,`qty`,`unit`,`supplier_code`,`supplier_name`,`warehouse_id`,`warehouse_name`,`location_code`,`logistics_company`,`logistics_no`,`estimated_arrival_date`,`actual_arrival_date`,`qc_inspector_id`,`qc_result`,`qc_remark`,`step`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1760000000000000031', 'PIN-20260526150000', '1760000000000000021', 'INB-20260526140000', 'WO-20260524-001', 'MAT-001', '钢材-SUS304', 500.00, 'kg', 'SUP-001', '钢材供应商A', 'WH-001', '原料仓A区', NULL, '顺丰物流', 'SF1234567890', '2026-05-28 08:00:00', NULL, NULL, NULL, NULL, 'order_processed', 'processing', NULL, '0', '2026-05-27 19:05:37', 'admin', '2026-05-27 19:05:37', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_process_content` WRITE;
DELETE FROM `mes2026`.`sp_process_content`;
INSERT INTO `mes2026`.`sp_process_content` (`id`,`oper_id`,`bom_item_id`,`bom_id`,`oper_code`,`oper_name`,`work_hour`,`oper_type`,`oper_step`,`tech_require`,`notice`,`equipment`,`tooling`,`cutter`,`img_list`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2063293395698229249', 'test_oper_id', 'test_bom_item_id', 'test_bom_id', 'OP001', '下料', NULL, NULL, '1.准备材料\n2.切割', '精度±0.1mm', NULL, 'CNC-001', '夹具A', NULL, NULL, 'lock', '0', '2026-06-07 00:14:14', 'system', '2026-06-07 00:14:15', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_process_material` WRITE;
DELETE FROM `mes2026`.`sp_process_material`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_product_bom` WRITE;
DELETE FROM `mes2026`.`sp_product_bom`;
INSERT INTO `mes2026`.`sp_product_bom` (`id`,`bom_code`,`bom_name`,`product_part_id`,`product_part_code`,`product_part_name`,`version`,`bom_type`,`state`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058413286625456130', '12', '电脑BOM', '2058413189191774209', '1', '电脑', '1', 'EBOM', 'locked', '', '0', '2026-05-24 13:02:26', 'admin', '2026-05-24 17:02:59', 'admin'),('2058413811924283394', '13', '22', '2058413189191774209', '1', '电脑', '1', 'EBOM', 'create', '', '0', '2026-05-24 13:04:31', 'admin', '2026-05-24 14:34:38', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_product_bom_item` WRITE;
DELETE FROM `mes2026`.`sp_product_bom_item`;
INSERT INTO `mes2026`.`sp_product_bom_item` (`id`,`bom_id`,`parent_item_id`,`part_id`,`part_code`,`part_name`,`line_no`,`level_no`,`qty`,`unit`,`scrap_rate`,`oper_id`,`oper_code`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058431786458869761', '2058413286625456130', '', '2058431392013938690', '10', '主板', 3, 1, 1.0000, '个', 0.00, '1336864537575456', 'TST-02', '', '0', '2026-05-24 14:15:56', 'admin', '2026-06-06 18:42:47', 'admin'),('2058431840653471746', '2058413286625456130', '2058431786458869761', '2058431588286394369', '103', 'CPU', 10, 2, 1.0000, '个', 0.00, '1336868507484192,1336864537575456,1336868562010144', 'JS-01,TST-02,QX-01', '', '0', '2026-05-24 14:16:09', 'admin', '2026-05-24 17:02:06', 'admin'),('2058431995331014658', '2058413286625456130', '', '', '', '', 10, 1, 1.0000, '', 0.00, NULL, '', '', '1', '2026-05-24 14:16:46', 'admin', '2026-05-24 14:16:52', 'admin'),('2058432098032742401', '2058413286625456130', '', '2058431961306820609', '11', '机箱', 10, 1, 1.0000, '', 0.00, '1336868360683552', 'HJ-01', '', '0', '2026-05-24 14:17:11', 'admin', '2026-05-24 17:02:51', 'admin'),('2058432145885556737', '2058413286625456130', '2058432098032742401', '2058404866010664962', '102', '铁板', 11, 2, 1.0000, '', 0.00, '1336868452958240', 'FJ-01', '', '0', '2026-05-24 14:17:22', 'admin', '2026-05-24 17:02:54', 'admin'),('2058432170610978817', '2058413286625456130', '2058432098032742401', '2058404060490387458', '101', '玻璃板', 11, 2, 1.0000, '', 0.00, '1336868562010144', 'QX-01', '', '0', '2026-05-24 14:17:28', 'admin', '2026-05-24 17:02:57', 'admin'),('2058432468331065346', '2058413286625456130', '2058431786458869761', '2058404866010664962', '102', '铁板', 10, 2, 1.0000, '', 0.00, '1336864575324192', 'APK-01', '', '0', '2026-05-24 14:18:39', 'admin', '2026-05-24 17:02:48', 'admin'),('2058436290453499905', '2058413811924283394', '', '2058413189191774209', '1', '电脑', 10, 1, 1.0000, '', 0.00, '1336864575324192,1336868360683552', 'APK-01,HJ-01', '', '0', '2026-05-24 14:33:50', 'admin', '2026-06-06 18:43:09', 'admin'),('2058436316542070786', '2058413811924283394', '2058436290453499905', '2058431392013938690', '10', '主板', 10, 2, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:33:56', 'admin', '2026-05-24 14:33:56', 'admin'),('2058436352470478849', '2058413811924283394', '2058436290453499905', '2058431961306820609', '11', '机箱', 10, 2, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:05', 'admin', '2026-05-24 14:34:05', 'admin'),('2058436382120013825', '2058413811924283394', '2058436316542070786', '2058431588286394369', '103', 'CPU', 10, 3, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:12', 'admin', '2026-05-24 14:34:12', 'admin'),('2058436411756965889', '2058413811924283394', '2058436316542070786', '2058404866010664962', '102', '铁板', 10, 3, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:19', 'admin', '2026-05-24 14:34:19', 'admin'),('2058436437329637377', '2058413811924283394', '2058436352470478849', '2058404866010664962', '102', '铁板', 10, 3, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:25', 'admin', '2026-05-24 14:34:25', 'admin'),('2058436457760092162', '2058413811924283394', '2058436352470478849', '2058404060490387458', '101', '玻璃板', 10, 3, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:30', 'admin', '2026-05-24 14:34:30', 'admin'),('2058436481776676866', '2058413811924283394', '2058436352470478849', '2058404918946975746', '104', '木板', 10, 3, 1.0000, '', 0.00, NULL, '', '', '0', '2026-05-24 14:34:36', 'admin', '2026-05-24 14:34:36', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_production_plan` WRITE;
DELETE FROM `mes2026`.`sp_production_plan`;
INSERT INTO `mes2026`.`sp_production_plan` (`id`,`plan_code`,`plan_name`,`order_id`,`order_code`,`order_type`,`product_code`,`product_name`,`product_spec`,`plan_qty`,`unit`,`scheduling_type`,`plan_start_time`,`plan_end_time`,`flow_instance_id`,`approval_status`,`plan_status`,`customer_name`,`contract_no`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2060002457261453313', '434324', '24', NULL, '234324', 'demand', '324324', '342', '34234', 343, '件', 'forward', NULL, NULL, '2060002505189765121', '3', '0', '', '', '', '0', '2026-05-28 22:17:13', 'admin', '2026-05-28 22:17:57', 'admin'),('2060017684455686146', '34324', '234', NULL, '234324', 'demand', '324324', '234', '324', 234, '件', 'forward', NULL, NULL, '2060017732597907457', '2', '1', '', '', '', '0', '2026-05-28 23:17:44', 'admin', '2026-05-28 23:17:59', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_production_team` WRITE;
DELETE FROM `mes2026`.`sp_production_team`;
INSERT INTO `mes2026`.`sp_production_team` (`id`,`team_code`,`team_name`,`team_type`,`workshop_id`,`line_id`,`leader_id`,`status`,`sort_no`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1745491200000000001', 'TEAM-001', '生产作业班组1', 'production', NULL, '1336867983196192', NULL, 'active', 0, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 00:10:04', 'admin'),('1745491200000000002', 'TEAM-002', '生产作业班组2', 'production', NULL, '1336868041916448', NULL, 'active', 0, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 00:10:04', 'admin'),('1745491200000000003', 'TEAM-003', '检验班组', 'team', NULL, NULL, NULL, 'active', 0, NULL, '0', '2026-05-25 00:10:04', 'admin', '2026-05-25 00:10:04', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_activity` WRITE;
DELETE FROM `mes2026`.`sp_qc_activity`;
INSERT INTO `mes2026`.`sp_qc_activity` (`id`,`activity_code`,`activity_name`,`activity_type`,`trigger_type`,`product_code`,`bom_id`,`order_id`,`status`,`priority`,`start_time`,`end_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1745491200000002001', 'QC-ACT-001', '2026年5月来料检验活动', 'iqc', 'manual', NULL, NULL, NULL, 'active', 3, '2026-05-01 08:00:00', '2026-05-31 17:00:00', NULL, '0', '2026-05-25 23:55:16', 'admin', '2026-05-25 23:55:16', 'admin'),('1745491200000002002', 'QC-ACT-002', '成品A过程检验活动', 'ipqc', 'manual', NULL, NULL, NULL, 'active', 2, '2026-05-15 08:00:00', '2026-06-15 17:00:00', NULL, '0', '2026-05-25 23:55:16', 'admin', '2026-05-25 23:55:16', 'admin'),('2059134794201059329', 'QC-ACT-003', '电脑成品出厂检验', 'spc', 'manual', '23123', '1231', '32133', 'active', 2, '2026-05-26 00:00:00', '2026-05-26 00:00:00', '', '0', '2026-05-26 12:49:26', 'admin', '2026-05-26 12:54:41', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_inspection_data` WRITE;
DELETE FROM `mes2026`.`sp_qc_inspection_data`;
INSERT INTO `mes2026`.`sp_qc_inspection_data` (`id`,`record_id`,`task_id`,`parameter_name`,`parameter_code`,`measured_value`,`standard_value`,`min_value`,`max_value`,`unit`,`is_pass`,`collect_time`,`collect_method`,`equipment_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1750000000000000041', '1750000000000000031', '1750000000000000021', '表面光洁度', 'SURFACE-001', 'A级', 'A级', 'C级', 'A级', NULL, '1', '2026-05-26 09:30:00', '目视', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000042', '1750000000000000031', '1750000000000000021', '颜色一致性', 'COLOR-001', '一致', '一致', NULL, NULL, NULL, '1', '2026-05-26 09:31:00', '目视', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000043', '1750000000000000031', '1750000000000000021', '尺寸公差', 'SIZE-001', '合格', '合格', NULL, NULL, NULL, '1', '2026-05-26 09:32:00', '测量', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000044', '1750000000000000032', '1750000000000000022', '表面光洁度', 'SURFACE-001', 'C级', 'A级', 'C级', 'A级', NULL, '0', '2026-05-26 10:15:00', '目视', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000045', '1750000000000000032', '1750000000000000022', '颜色一致性', 'COLOR-001', '一致', '一致', NULL, NULL, NULL, '1', '2026-05-26 10:16:00', '目视', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000046', '1750000000000000033', '1750000000000000023', '长度尺寸', 'LENGTH-001', '100.2', '100.0', '99.5', '100.5', 'mm', '1', '2026-05-26 11:00:00', '卡尺', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000047', '1750000000000000033', '1750000000000000023', '宽度尺寸', 'WIDTH-001', '50.1', '50.0', '49.5', '50.5', 'mm', '1', '2026-05-26 11:01:00', '卡尺', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000048', '1750000000000000033', '1750000000000000023', '高度尺寸', 'HEIGHT-001', '25.0', '25.0', '24.5', '25.5', 'mm', '1', '2026-05-26 11:02:00', '卡尺', NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_inspection_def` WRITE;
DELETE FROM `mes2026`.`sp_qc_inspection_def`;
INSERT INTO `mes2026`.`sp_qc_inspection_def` (`id`,`def_code`,`def_name`,`inspection_type`,`product_code`,`product_name`,`bom_id`,`oper_id`,`inspection_method`,`inspection_item`,`standard_value`,`tolerance_upper`,`tolerance_lower`,`unit`,`sample_plan`,`aql_level`,`sample_qty`,`is_critical`,`sort_no`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1745491200000004001', 'QC-DEF-001', '成品A外观检验', 'iqc', 'PRD-001', '', NULL, NULL, 'visual', '外观检查', '无划痕', NULL, NULL, '', '', '', NULL, '1', 0, 'active', '', '0', '2026-05-25 23:55:16', 'admin', '2026-06-06 22:44:15', 'admin'),('1745491200000004002', 'QC-DEF-002', '成品A尺寸检验', 'iqc', 'PRD-001', '', NULL, NULL, 'measure', '长度', '100.00', 0.1000, -0.1000, 'mm', '', '', NULL, '1', 0, 'active', '', '0', '2026-05-25 23:55:16', 'admin', '2026-06-06 22:29:56', 'admin'),('1750000000000000001', 'IQC-DEF-001', '来料外观检验', 'iqc', 'PRD-001', '成品A', NULL, NULL, 'visual', '外观检验', '无瑕疵', NULL, NULL, NULL, 'GB/T 2828.1', 'II', 50, '1', 1, 'active', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000002', 'IPQC-DEF-001', '过程尺寸检验', 'ipqc', 'PRD-001', '成品A', NULL, NULL, 'measure', '长度尺寸', '100.0', 100.5000, 99.5000, 'mm', 'GB/T 2828.1', 'II', 20, '1', 2, 'active', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000003', 'OQC-DEF-001', '出货功能检验', 'oqc', 'PRD-002', '成品B', NULL, NULL, 'test', '功能测试', '合格', NULL, NULL, NULL, '全检', NULL, 100, '1', 3, 'active', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('2059135908455665665', 'QC-DEF-003', '电脑成品外观检验', 'oqc', '121', '3123', '1231', '1313', 'visual', '1334', '131', 313.0000, 13.0000, '13', '1313', '131', 3131, '0', 0, 'active', '', '0', '2026-05-26 12:53:52', 'admin', '2026-06-06 22:24:39', 'admin'),('2063293392799965186', 'QC_E2E_001', '成品检验', 'oqc', NULL, NULL, NULL, NULL, 'measure', NULL, '10.0', 0.1000, -0.1000, 'mm', NULL, NULL, NULL, '1', 0, 'active', NULL, '0', '2026-06-07 00:14:14', 'system', '2026-06-07 00:14:14', 'system'),('2063293397413699586', 'QC_DEF_001', '尺寸检验', 'ipqc', NULL, NULL, NULL, NULL, 'measure', NULL, '10.0', 0.1000, -0.1000, 'mm', NULL, NULL, NULL, '1', 0, 'active', NULL, '0', '2026-06-07 00:14:15', 'system', '2026-06-07 00:14:15', 'system'),('2063298827716157441', 'QC_IT_001', '集成测试质检', 'oqc', NULL, NULL, NULL, NULL, 'measure', NULL, '10.0', 0.1000, -0.1000, 'mm', NULL, NULL, NULL, '1', 0, 'active', NULL, '0', '2026-06-07 00:35:49', 'system', '2026-06-07 00:35:49', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_inspection_plan` WRITE;
DELETE FROM `mes2026`.`sp_qc_inspection_plan`;
INSERT INTO `mes2026`.`sp_qc_inspection_plan` (`id`,`plan_code`,`plan_name`,`activity_id`,`inspection_def_id`,`order_id`,`product_code`,`plan_qty`,`completed_qty`,`pass_qty`,`fail_qty`,`plan_start_time`,`plan_end_time`,`actual_start_time`,`actual_end_time`,`status`,`priority`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1750000000000000011', 'QC-PLAN-20260526-001', '成品A来料检验计划', NULL, '1750000000000000001', NULL, 'PRD-001', 100.00, 50.00, 50.00, 0.00, '2026-05-26 08:00:00', '2026-05-26 17:00:00', '2026-05-26 08:00:00', NULL, 'pending', 1, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000012', 'QC-PLAN-20260526-002', '成品A过程检验计划', NULL, '1750000000000000002', NULL, 'PRD-001', 200.00, 100.00, 100.00, 0.00, '2026-05-26 08:00:00', '2026-05-26 17:00:00', '2026-05-26 08:00:00', NULL, 'executing', 2, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('2059135260255342593', '23112', '123219149122', '1745491200000002002', '1745491200000004002', '13121', '31', 12.00, 1322.00, 1313.00, 3131.00, '2026-05-26 00:00:00', '2026-05-26 00:00:00', '2026-05-26 13:18:21', '2026-05-26 13:28:14', 'executing', 1, '', '0', '2026-05-26 12:51:18', 'admin', '2026-05-26 13:42:13', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_inspection_record` WRITE;
DELETE FROM `mes2026`.`sp_qc_inspection_record`;
INSERT INTO `mes2026`.`sp_qc_inspection_record` (`id`,`record_code`,`task_id`,`inspection_def_id`,`inspector_id`,`inspection_time`,`result`,`defect_type`,`defect_desc`,`defect_qty`,`defect_severity`,`measured_value`,`standard_value`,`handle_method`,`handle_remark`,`attachment`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1750000000000000031', 'QC-REC-20260526001', '1750000000000000021', '1750000000000000001', '1184019107907227649', '2026-05-26 09:30:00', 'pass', NULL, NULL, 0.00, NULL, '无瑕疵', '无瑕疵', NULL, NULL, NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000032', 'QC-REC-20260526002', '1750000000000000022', '1750000000000000001', '1184009088826392578', '2026-05-26 10:15:00', 'fail', 'appearance', '表面有划痕', 2.00, 'minor', '有划痕', '无瑕疵', 'rework', NULL, NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000033', 'QC-REC-20260526003', '1750000000000000023', '1750000000000000002', '1266201180838801409', '2026-05-26 11:00:00', 'pass', NULL, NULL, 0.00, NULL, '100.2', '100.0', NULL, NULL, NULL, NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('2059144554619080706', 'QC-REC-1779773293534', '2059142070689345537', '1745491200000004002', '1184010472443396098', '2026-05-26 13:28:14', 'pass', '', '', 1.00, '', '', NULL, '', NULL, NULL, NULL, '0', '2026-05-26 13:28:14', 'admin', '2026-05-26 13:28:14', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_inspection_task` WRITE;
DELETE FROM `mes2026`.`sp_qc_inspection_task`;
INSERT INTO `mes2026`.`sp_qc_inspection_task` (`id`,`task_code`,`plan_id`,`inspection_def_id`,`inspector_id`,`process_unit_id`,`assigned_qty`,`completed_qty`,`pass_qty`,`fail_qty`,`assign_time`,`start_time`,`end_time`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1750000000000000021', 'QC-TASK-20260526001', '1750000000000000011', '1750000000000000001', '1184019107907227649', '1750000000000000101', 50.00, 50, 50, 0, '2026-05-26 13:56:28', NULL, '2026-05-26 13:56:28', 'completed', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000022', 'QC-TASK-20260526002', '1750000000000000011', '1750000000000000001', '1184009088826392578', '1750000000000000102', 50.00, 0, 0, 0, '2026-05-26 13:56:28', '2026-05-26 13:56:28', NULL, 'started', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000023', 'QC-TASK-20260526003', '1750000000000000012', '1750000000000000002', '1266201180838801409', '1750000000000000101', 100.00, 100, 100, 0, '2026-05-26 13:56:28', NULL, '2026-05-26 13:56:28', 'completed', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('1750000000000000024', 'QC-TASK-20260526004', '1750000000000000012', '1750000000000000002', '1276512902757724162', '1750000000000000102', 100.00, 0, 0, 0, '2026-05-26 13:56:28', NULL, NULL, 'assigned', NULL, '0', '2026-05-26 13:56:28', 'admin', '2026-05-26 13:56:28', 'admin'),('2059142070689345537', 'QC-TASK-1779772701319', '2059135260255342593', '1745491200000004002', '1184010472443396098', '2058383728161341442', 1.00, 1, 1, 0, '2026-05-26 13:18:21', NULL, '2026-05-26 13:28:14', 'completed', NULL, '0', '2026-05-26 13:18:21', 'admin', '2026-05-26 13:28:14', 'admin'),('2059150613953933313', 'QC-TASK-1779774737696', '2059135260255342593', '1745491200000004002', '2058217005470736386', '2058383728161341442', 10086.00, 0, 0, 0, '2026-05-26 13:52:18', NULL, NULL, 'assigned', NULL, '0', '2026-05-26 13:52:18', 'admin', '2026-05-26 13:52:18', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_qc_resource` WRITE;
DELETE FROM `mes2026`.`sp_qc_resource`;
INSERT INTO `mes2026`.`sp_qc_resource` (`id`,`resource_code`,`resource_name`,`resource_type`,`resource_spec`,`manufacturer`,`location`,`calibration_cycle`,`last_calibration_date`,`next_calibration_date`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1745491200000003001', 'QC-RES-001', '数显卡尺', 'tool', '0-150mm/0.01mm', '', '', NULL, NULL, NULL, 'active', '', '0', '2026-05-25 23:55:16', 'admin', '2026-06-06 22:24:20', 'admin'),('1745491200000003002', 'QC-RES-002', '三坐标测量仪', 'equipment', 'ZEISS CONTURA', NULL, NULL, NULL, NULL, NULL, 'active', NULL, '0', '2026-05-25 23:55:16', 'admin', '2026-05-25 23:55:16', 'admin'),('2059135059327209473', '21412', '21412', 'fixture', '123123', '12321', '12312', 123, '2026-05-26', '2026-05-28', 'maintenance', '', '0', '2026-05-26 12:50:30', 'admin', '2026-06-06 22:30:23', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_department` WRITE;
DELETE FROM `mes2026`.`sp_sys_department`;
INSERT INTO `mes2026`.`sp_sys_department` (`id`,`parent_id`,`name`,`sort_num`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('03', '0', '工程部', 3, '0', '2026-05-24 10:41:36', 'admin', '2026-05-24 10:41:36', 'admin'),('031', '03', '工程队1', 1, '0', '2026-05-24 10:42:07', 'admin', '2026-05-24 10:42:07', 'admin'),('1', '0', '行政部', 1, '0', '2026-05-23 18:13:23', 'admin', '2026-05-23 18:13:28', 'admin'),('11', '1', '法律部', 3, '0', '2026-05-24 09:45:46', 'admin', '2026-05-24 09:45:46', 'admin'),('12', '1', '财政部', 4, '0', '2026-05-24 09:47:14', 'admin', '2026-05-24 09:47:14', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_dict` WRITE;
DELETE FROM `mes2026`.`sp_sys_dict`;
INSERT INTO `mes2026`.`sp_sys_dict` (`id`,`name`,`value`,`type`,`descr`,`sort_num`,`parent_id`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1337618042191904', '成品', 'FG', 'material_type', '物料类型', 2, '\"\"', '0', '2020-03-18 13:53:06', 'admin', '2020-03-18 13:53:06', 'admin'),('1337618163826720', '半成品', 'PG', 'material_type', '物料类型', 3, '\"\"', '0', '2020-03-18 13:54:04', 'admin', '2020-03-18 13:54:04', 'admin'),('1337618837012512', '个', 'PCS', 'ORDER_UNIT', '生产单位', 1, '\"\"', '0', '2020-03-18 13:59:25', 'admin', '2020-03-18 13:59:41', 'admin'),('1337618939772960', '箱', 'BOX', 'ORDER_UNIT', '生产单位', 2, '\"\"', '0', '2020-03-18 14:00:14', 'admin', '2020-03-18 14:00:14', 'admin'),('13390001', '原材料', '1', 'material_type', '物料类型-原材料', 1, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390002', '半成品', '2', 'material_type', '物料类型-半成品', 2, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390003', '成品', '3', 'material_type', '物料类型-成品', 3, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390004', '辅料', '4', 'material_type', '物料类型-辅料', 4, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390005', '自制', '1', 'material_source', '物料来源-自制', 1, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390006', '外购', '2', 'material_source', '物料来源-外购', 2, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390007', '委外', '3', 'material_source', '物料来源-委外', 3, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390008', '钢材', '1', 'material_texture', '材质-钢材', 1, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390009', '铝材', '2', 'material_texture', '材质-铝材', 2, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390010', '铜材', '3', 'material_texture', '材质-铜材', 3, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390011', '塑料', '4', 'material_texture', '材质-塑料', 4, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390012', '橡胶', '5', 'material_texture', '材质-橡胶', 5, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('13390013', '复合材料', '6', 'material_texture', '材质-复合材料', 6, '0', '0', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_equipment` WRITE;
DELETE FROM `mes2026`.`sp_sys_equipment`;
INSERT INTO `mes2026`.`sp_sys_equipment` (`id`,`code`,`name`,`model`,`type`,`status`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058374185176113154', '10025', '数控机床', '0x12', '机床', '0', '', '0', '2026-05-24 10:27:03', 'admin', '2026-05-24 10:27:03', 'admin'),('2058374257125203970', '2312312', '3123', '123', '123', '0', '123', '0', '2026-05-24 10:27:20', 'admin', '2026-05-24 10:27:20', 'admin'),('2063298819415629825', 'EQ_E2E_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 00:35:47', 'system', '2026-06-07 00:35:47', 'system'),('2063298833206501378', 'EQ_IT_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 00:35:51', 'system', '2026-06-07 00:35:51', 'system'),('2063438182564782081', 'EQ_E2E_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 09:49:34', 'system', '2026-06-07 09:49:34', 'system'),('2063438195663593473', 'EQ_IT_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 09:49:37', 'system', '2026-06-07 09:49:37', 'system'),('2063440531211431937', 'EQ_E2E_001', 'Test Equipment', NULL, 'Machine Center', '0', NULL, '0', '2026-06-07 09:58:54', 'system', '2026-06-07 09:58:54', 'system'),('2063440543739817986', 'EQ_IT_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 09:58:57', 'system', '2026-06-07 09:58:57', 'system'),('2063441406436962305', 'EQ_E2E_001', 'Test Equipment', NULL, 'Machine Center', '0', NULL, '0', '2026-06-07 10:02:23', 'system', '2026-06-07 10:02:23', 'system'),('2063441419221200898', 'EQ_IT_001', '测试设备', NULL, '加工中心', '0', NULL, '0', '2026-06-07 10:02:26', 'system', '2026-06-07 10:02:26', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_equipment_group` WRITE;
DELETE FROM `mes2026`.`sp_sys_equipment_group`;
INSERT INTO `mes2026`.`sp_sys_equipment_group` (`id`,`code`,`name`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058378929294630913', '101', '智能设备编组', '现代化智能设备组', '0', '2026-05-24 10:45:54', 'admin', '2026-05-24 11:37:32', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_equipment_group_equipment` WRITE;
DELETE FROM `mes2026`.`sp_sys_equipment_group_equipment`;
INSERT INTO `mes2026`.`sp_sys_equipment_group_equipment` (`id`,`equipment_group_id`,`equipment_id`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058391925106466817', '2058378929294630913', '2058374185176113154', '2026-05-24 11:37:33', 'admin', '2026-05-24 11:37:33', 'admin'),('2058391925114855425', '2058378929294630913', '2058374257125203970', '2026-05-24 11:37:33', 'admin', '2026-05-24 11:37:33', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_group` WRITE;
DELETE FROM `mes2026`.`sp_sys_group`;
INSERT INTO `mes2026`.`sp_sys_group` (`id`,`code`,`name`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058231922059931649', '1001', '领导小组', '', '0', '2026-05-24 01:01:45', 'admin', '2026-05-24 01:01:45', 'admin'),('2058378411801403394', '025', '智能工程队1', '熟练使用智能化工程设备', '0', '2026-05-24 10:43:51', 'admin', '2026-05-24 10:43:51', 'admin'),('2063158292632330241', '026', '电脑组装班组', '电脑组装专门小组', '0', '2026-06-06 15:17:23', 'admin', '2026-06-06 15:17:23', 'admin'),('2063293389436133378', NULL, NULL, NULL, '0', '2026-06-07 00:14:13', 'system', '2026-06-07 00:14:13', 'system'),('2063293403520606209', NULL, NULL, NULL, '0', '2026-06-07 00:14:16', 'system', '2026-06-07 00:14:16', 'system'),('2063298818396413953', 'TEST_GROUP_E2E', '测试班组', NULL, '0', '2026-06-07 00:35:47', 'system', '2026-06-07 00:35:47', 'system'),('2063298833726595073', 'TEST_GROUP_IT', '测试班组', NULL, '0', '2026-06-07 00:35:51', 'system', '2026-06-07 00:35:51', 'system'),('2063438181587509250', 'TEST_GROUP_E2E', '测试班组', NULL, '0', '2026-06-07 09:49:34', 'system', '2026-06-07 09:49:34', 'system'),('2063438196145938434', 'TEST_GROUP_IT', '测试班组', NULL, '0', '2026-06-07 09:49:37', 'system', '2026-06-07 09:49:37', 'system'),('2063440530355793922', 'TEST_GROUP_E2E', 'Test Group', NULL, '0', '2026-06-07 09:58:54', 'system', '2026-06-07 09:58:54', 'system'),('2063440544159248386', 'TEST_GROUP_IT', '测试班组', NULL, '0', '2026-06-07 09:58:57', 'system', '2026-06-07 09:58:57', 'system'),('2063441405585518594', 'TEST_GROUP_E2E', 'Test Group', NULL, '0', '2026-06-07 10:02:23', 'system', '2026-06-07 10:02:23', 'system'),('2063441419644825601', 'TEST_GROUP_IT', '测试班组', NULL, '0', '2026-06-07 10:02:26', 'system', '2026-06-07 10:02:26', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_group_user` WRITE;
DELETE FROM `mes2026`.`sp_sys_group_user`;
INSERT INTO `mes2026`.`sp_sys_group_user` (`id`,`group_id`,`user_id`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058231922135429121', '2058231922059931649', '2058121374051958786', '2026-05-24 01:01:45', 'admin', '2026-05-24 01:01:45', 'admin'),('2058231922148012034', '2058231922059931649', '1276512902757724162', '2026-05-24 01:01:45', 'admin', '2026-05-24 01:01:45', 'admin'),('2058378411876900866', '2058378411801403394', '1266201180838801409', '2026-05-24 10:43:51', 'admin', '2026-05-24 10:43:51', 'admin'),('2058378411885289474', '2058378411801403394', '2058217005470736386', '2026-05-24 10:43:51', 'admin', '2026-05-24 10:43:51', 'admin'),('2058378411889483777', '2058378411801403394', '1184010472443396098', '2026-05-24 10:43:51', 'admin', '2026-05-24 10:43:51', 'admin'),('2063158293248892929', '2063158292632330241', '1276512902757724162', '2026-06-06 15:17:23', 'admin', '2026-06-06 15:17:23', 'admin'),('2063158293387304962', '2063158292632330241', '2058217005470736386', '2026-06-06 15:17:23', 'admin', '2026-06-06 15:17:23', 'admin'),('2063158293546688514', '2063158292632330241', '1184010472443396098', '2026-06-06 15:17:23', 'admin', '2026-06-06 15:17:23', 'admin'),('2063158293689294849', '2063158292632330241', '2063156791599980546', '2026-06-06 15:17:24', 'admin', '2026-06-06 15:17:24', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_menu` WRITE;
DELETE FROM `mes2026`.`sp_sys_menu`;
INSERT INTO `mes2026`.`sp_sys_menu` (`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1', 'currency', '常规管理', '#', '0', '1', 1, '0', 'user:add', 'fa fa-address-book', '', '2019-10-18 11:18:29', 'SongPeng', '2020-03-13 14:07:09', 'admin'),('10', 'system', '系统管理', '#', '1', '2', 1, '0', 'user:add', 'fa fa-gears', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('101', 'menu', '菜单管理', '/admin/sys/menu/list-ui', '10', '3', 1, '0', 'user:add', 'fa fa-bars', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('105', 'basedata', '基础数据配置平台', '/basedata/manager/list-ui', '10', '3', 5, '0', 'user:add', 'fa fa-cog', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('106', 'basedatamanager', '基础数据维护', '/basedata/manager/item/list-ui', '10', '3', 6, '0', 'user:add', 'fa fa-database', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('11', 'resource', '资源分配管理', '#', '1', '2', 1, '0', 'user:add', 'fa fa-archive', '\"\"', '2026-05-24 10:01:16', 'wangyu', '2026-05-24 10:01:28', 'wangyu'),('111', 'user', '用户管理', '/admin/sys/user/list-ui', '11', '3', 2, '0', 'user:add', 'fa fa-user', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('112', 'role', '角色管理', '/admin/sys/role/list-ui', '11', '3', 3, '0', 'user:add', 'fa fa-child', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('113', 'department', '部门管理', '/admin/sys/department/list-ui', '11', '3', 4, '0', 'user:add', 'fa fa-sitemap', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('114', 'group', '班组管理', '/admin/sys/group/list-ui', '11', '3', 5, '0', 'user:add', 'fa fa-group', '', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('115', 'equipment', '生产设备管理', '/admin/sys/equipment/list-ui', '11', '3', 6, '0', 'user:add', 'fa fa-server', '', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('116', 'equipmentgroup', '设备编组管理', '/admin/sys/equipmentgroup/list-ui', '11', '3', 7, '1', 'user:add', 'fa fa-cubes', '', '2026-05-24 10:37:59', 'admin', '2026-05-24 10:37:59', 'admin'),('117', 'processunit', '加工单元管理', '/admin/sys/processunit/list-ui', '11', '3', 8, '0', 'user:add', 'fa fa-cubes', '', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('12', 'order', '生产管理', '', '1', '2', 4, '0', 'user:add', 'fa fa-calendar', '', '2019-10-18 11:18:29', 'Wangziyang', '2021-02-21 14:59:56', 'admin'),('121', 'order-release', '生产订单录入', '/order/release/list-ui', '12', '3', 1, '0', '\"\"', 'fa fa-list-alt', '\"\"', '2026-05-29 09:56:50', 's', '2026-05-29 09:56:54', 's'),('122', 'dispatch', '生产作业派工', '/production/dispatch/list-ui', '12', '3', 2, '0', 'user:add', 'fa fa-file-text-o', '\"\"', '2026-05-25 00:01:54', 'admin', '2026-05-25 00:02:02', 'admin'),('13', 'materiel', '物料管理', '#', '1', '2', 2, '0', 'user:add', 'fa fa-cubes', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang'),('132', 'materialinfo', '物料信息定义', '/basedata/materialinfo/list-ui', '13', '3', 2, '0', 'user:add', 'fa fa-list-alt', '', '2026-05-24 10:00:00', 'admin', '2026-05-24 10:00:00', 'admin'),('133', 'mrp', '物料需求计划', '/order/mrp/list-ui', '13', '3', 1, '0', 'user:add', 'fa fa-list-alt', '', '2026-05-27 19:09:24', 'admin', '2026-05-27 19:09:24', 'admin'),('14', 'Digitalplatform\n\n', '数字化平台', '#', '1', '2', 6, '0', 'user:add', 'fa fa-pie-chart', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang'),('141', 'plandg', '智慧大屏', '/digitization/plan/plan-ui', '14', '3', 1, '0', 'user:add', 'fa fa-desktop', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('15', 'ProcessManage', '产品数据中心', '', '1', '2', 3, '0', 'user:add', 'fa fa-database', '', '2019-10-18 11:18:29', 'Wangziyang', '2021-02-21 15:01:47', 'admin'),('153', 'part', '零部件定义', '/productdata/part/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-cogs', '', '2026-05-24 12:08:28', 'admin', '2026-05-24 12:08:28', 'admin'),('154', 'productbom', '产品BOM管理', '/productdata/productbom/list-ui', '15', '3', 2, '0', 'user:add', 'fa fa-sitemap', '', '2026-05-24 12:08:28', 'admin', '2026-05-24 12:08:28', 'admin'),('155', 'operinfo', '工序信息定义', '/productdata/oper/list-ui', '15', '3', 3, '0', 'user:add', 'fa fa-tasks', '', '2026-05-24 12:08:28', 'admin', '2026-05-24 12:08:28', 'admin'),('156', 'flowmanage', '工艺流程管理', '/productdata/flow/list-ui', '15', '3', 4, '0', 'user:add', 'fa fa-retweet', '', '2026-05-24 12:08:28', 'admin', '2026-05-24 12:08:28', 'admin'),('157', 'processContent', '工艺内容编制', '/productdata/content/list-ui', '15', '3', 4, '0', 'productdata:content:list,productdata:content:save,productdata:content:complete', 'layui-icon-edit', '工艺内容编制管理', '2026-06-04 10:15:55', 'admin', '2026-06-04 10:15:55', 'admin'),('16', 'wip', '在制品管理', '#', '1', '2', 5, '0', 'user:add', 'fa fa-industry', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('161', 'generalSnProcess', 'SN通用过程采集', '/rrr', '16', '3', 1, '0', 'user:add', 'fa fa-product-hunt', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('17', 'DigitalSimulation', '黑科数字孪生', '#', '1', '2', 7, '0', 'user:add', 'fa fa-ravelry', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang'),('171', 'DigitalSimulationFrom', '数字仿真3D仓库', '/digital/simulation/list-ui', '17', '3', 1, '0', 'user:add', 'fa fa-codepen', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang'),('18', 'logistics', '仓库管理', '#', '1', '2', 8, '0', 'user:add', 'fa fa-truck', '', '2026-05-24 11:44:39', 'admin', '2026-05-24 11:44:39', 'admin'),('181', 'warehouse', '库房管理', '/warehouse/warehouse/list-ui', '18', '3', 1, '0', 'user:add', 'fa fa-warehouse', '', '2026-05-24 11:44:39', 'admin', '2026-05-24 11:44:39', 'admin'),('182', 'warehouseboard', '库房看板', '/warehouse/warehouse/board-ui', '18', '3', 2, '0', 'user:add', 'fa fa-th', '', '2026-05-24 11:44:39', 'admin', '2026-05-24 11:44:39', 'admin'),('183', 'plannedInbound', '计划入库管理', '/order/inbound/list-ui', '18', '3', 3, '0', 'user:add', 'fa fa-archive', '', '2026-05-27 19:09:24', 'admin', '2026-05-27 19:09:24', 'admin'),('19', 'quality', '质量管理', '#', '1', '2', 8, '0', 'user:add', 'fa fa-check-square-o', '', '2026-05-26 00:10:15', 'admin', '2026-05-26 00:10:15', 'admin'),('191', 'qcActivity', '质量活动管理', '/quality/activity/list-ui', '19', '3', 1, '0', 'user:add', 'fa fa-calendar-check-o', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('192', 'qcResource', '质检资源管理', '/quality/resource/list-ui', '19', '3', 2, '0', 'user:add', 'fa fa-wrench', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('193', 'qcDef', '质检定义管理', '/quality/def/list-ui', '19', '3', 3, '0', 'user:add', 'fa fa-file-text-o', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('194', 'qcPlan', '质检调度', '/quality/plan/list-ui', '19', '3', 4, '0', 'user:add', 'fa fa-tasks', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('196', 'qcExecution', '质检执行', '/quality/execution/list-ui', '19', '3', 6, '0', 'user:add', 'fa fa-play-circle-o', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('197', 'qcData', '质检数据收集', '/quality/data/list-ui', '19', '3', 7, '0', 'user:add', 'fa fa-database', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('198', 'qcStatistics', '统计分析', '/quality/statistics/list-ui', '19', '3', 8, '0', 'user:add', 'fa fa-bar-chart', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('199', 'qcTrace', '质检跟踪追溯', '/quality/trace/list-ui', '19', '3', 9, '0', 'user:add', 'fa fa-search', '', '2026-05-26 00:10:43', 'admin', '2026-05-26 00:10:43', 'admin'),('1A', 'order-manage', '流程管理', '#', '1', '2', 1, '0', '\"\"', '\"\"', '\"\"', '2026-05-29 14:39:38', 'a', '2026-05-29 14:39:41', 'a'),('1A1', 'flowCategory', '流程分类管理', '/technology/flow/category/list-ui', '1A', '3', 1, '0', 'user:add', 'fa fa-tags', '', '2026-05-29 15:19:23', 'admin', '2026-05-29 15:19:23', 'admin'),('1A2', 'flowDefine', '流程定义管理', '/technology/flow/list-ui', '1A', '3', 2, '0', 'user:add', 'fa fa-random', '', '2026-05-29 15:19:23', 'admin', '2026-05-29 15:19:23', 'admin'),('1A3', 'flowDesign', '流程模型设计', '/basedata/flow/process/list-ui', '1A', '3', 3, '0', 'user:add', 'fa fa-cogs', '', '2026-05-29 15:19:23', 'admin', '2026-05-29 15:19:23', 'admin'),('2', 'component', 'OPC操作', '#', '0', '1', 1, '0', 'user:add', 'fa fa-lemon-o', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng'),('201', 'dispatch-order', '派工管理', '/production/dispatch/list-ui', '200', '2', 1, '2', 'user:add', 'fa fa-file-text-o', '', '2026-05-25 00:11:23', 'admin', '2026-05-25 00:11:23', 'admin'),('3', 'other', '其他管理', '#', '0', '1', 1, '0', 'user:add', 'fa fa-slideshare', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_process_unit` WRITE;
DELETE FROM `mes2026`.`sp_sys_process_unit`;
INSERT INTO `mes2026`.`sp_sys_process_unit` (`id`,`code`,`name`,`group_id`,`equipment_group_id`,`daily_standard_capacity`,`has_limited_side_storage`,`side_storage_capacity`,`status`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058383728161341442', '1', '智能小组加工', '2058378411801403394', '2058378929294630913', 15.00, '0', 2.00, '0', '', '0', '2026-05-24 11:04:58', 'admin', '2026-05-24 11:04:58', 'admin'),('2063298819935723521', 'PU_E2E_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 00:35:48', 'system', '2026-06-07 00:35:48', 'system'),('2063298832287948802', 'PU_IT_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 00:35:51', 'system', '2026-06-07 00:35:51', 'system'),('2063438183072292865', 'PU_E2E_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 09:49:34', 'system', '2026-06-07 09:49:34', 'system'),('2063438194782789634', 'PU_IT_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 09:49:37', 'system', '2026-06-07 09:49:37', 'system'),('2063440531643445250', 'PU_E2E_001', 'Test Process Unit', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 09:58:54', 'system', '2026-06-07 09:58:54', 'system'),('2063440542968066049', 'PU_IT_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 09:58:57', 'system', '2026-06-07 09:58:57', 'system'),('2063441406885752834', 'PU_E2E_001', 'Test Process Unit', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 10:02:23', 'system', '2026-06-07 10:02:23', 'system'),('2063441418436866050', 'PU_IT_001', '测试加工单元', NULL, NULL, NULL, '0', NULL, '0', NULL, '0', '2026-06-07 10:02:26', 'system', '2026-06-07 10:02:26', 'system')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_role` WRITE;
DELETE FROM `mes2026`.`sp_sys_role`;
INSERT INTO `mes2026`.`sp_sys_role` (`id`,`name`,`code`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1185025876737396738', '超级管理员', 'admin', '超级管理员', '0', '2019-10-18 10:52:40', 'SongPeng', '2026-06-04 10:16:18', 'admin'),('1232532514523213826', '体验者123', 'experience', '体验者', '0', '2020-02-26 13:07:05', 'admin', '2026-05-23 23:49:28', 'admin'),('1336542182244384', '王子杨', '123', '王子杨', '0', '2020-03-12 15:22:56', 'admin', '2026-05-24 00:15:18', 'admin'),('2063155402400358401', '检验员', '003', '产品检验员', '0', '2026-06-06 15:05:54', 'admin', '2026-06-06 19:38:12', 'xmei')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_role_menu` WRITE;
DELETE FROM `mes2026`.`sp_sys_role_menu`;
INSERT INTO `mes2026`.`sp_sys_role_menu` (`id`,`role_id`,`menu_id`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058213733762621442', '1232532514523213826', '1', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733783592962', '1232532514523213826', '10', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733791981569', '1232532514523213826', '101', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733800370178', '1232532514523213826', '112', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733808758785', '1232532514523213826', '103', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733812953090', '1232532514523213826', '104', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733821341697', '1232532514523213826', '105', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733821341698', '1232532514523213826', '106', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733833924609', '1232532514523213826', '13', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733838118913', '1232532514523213826', '131', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733842313218', '1232532514523213826', '15', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733846507522', '1232532514523213826', '151', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733854896129', '1232532514523213826', '152', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733859090433', '1232532514523213826', '12', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733867479041', '1232532514523213826', '121', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733871673346', '1232532514523213826', '16', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733880061954', '1232532514523213826', '161', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733884256258', '1232532514523213826', '14', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733884256259', '1232532514523213826', '141', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733892644865', '1232532514523213826', '17', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733896839169', '1232532514523213826', '171', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733905227777', '1232532514523213826', '2', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058213733905227778', '1232532514523213826', '3', '2026-05-23 23:49:29', 'admin', '2026-05-23 23:49:29', 'admin'),('2058220234564722689', '1336542182244384', '2', '2026-05-24 00:15:18', 'admin', '2026-05-24 00:15:18', 'admin'),('2058220234568916993', '1336542182244384', '3', '2026-05-24 00:15:18', 'admin', '2026-05-24 00:15:18', 'admin'),('2062357744866131970', '1185025876737396738', '10', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745050681345', '1185025876737396738', '101', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745239425026', '1185025876737396738', '105', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745415585794', '1185025876737396738', '106', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745600135170', '1185025876737396738', '1A', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745793073153', '1185025876737396738', '1A1', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357745994399746', '1185025876737396738', '1A2', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357746187337729', '1185025876737396738', '1A3', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357746371887105', '1185025876737396738', '11', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357746548047873', '1185025876737396738', '111', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357746732597249', '1185025876737396738', '112', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357746912952321', '1185025876737396738', '113', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357747101696002', '1185025876737396738', '114', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357747282051074', '1185025876737396738', '115', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357747458211842', '1185025876737396738', '116', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357747651149826', '1185025876737396738', '117', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357747839893506', '1185025876737396738', '13', '2026-06-04 10:16:18', 'admin', '2026-06-04 10:16:18', 'admin'),('2062357748028637186', '1185025876737396738', '133', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357748204797954', '1185025876737396738', '132', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357748393541633', '1185025876737396738', '15', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357748578091010', '1185025876737396738', '153', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357748766834690', '1185025876737396738', '154', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357748938801153', '1185025876737396738', '155', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357749123350530', '1185025876737396738', '157', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357749307899906', '1185025876737396738', '156', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357749488254977', '1185025876737396738', '12', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357749672804354', '1185025876737396738', '121', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357749844770817', '1185025876737396738', '122', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750020931586', '1185025876737396738', '16', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750205480962', '1185025876737396738', '161', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750402613249', '1185025876737396738', '19', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750595551234', '1185025876737396738', '191', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750780100610', '1185025876737396738', '192', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357750964649986', '1185025876737396738', '193', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357751140810753', '1185025876737396738', '194', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357751329554434', '1185025876737396738', '196', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357751505715201', '1185025876737396738', '197', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357751690264578', '1185025876737396738', '198', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357751862231042', '1185025876737396738', '199', '2026-06-04 10:16:19', 'admin', '2026-06-04 10:16:19', 'admin'),('2062357752050974722', '1185025876737396738', '18', '2026-06-04 10:16:20', 'admin', '2026-06-04 10:16:20', 'admin'),('2062357752231329793', '1185025876737396738', '181', '2026-06-04 10:16:20', 'admin', '2026-06-04 10:16:20', 'admin'),('2062357752411684866', '1185025876737396738', '182', '2026-06-04 10:16:20', 'admin', '2026-06-04 10:16:20', 'admin'),('2062357752600428545', '1185025876737396738', '183', '2026-06-04 10:16:20', 'admin', '2026-06-04 10:16:20', 'admin'),('2063223929438318594', '2063155402400358401', '11', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223929572536321', '2063155402400358401', '111', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223929702559746', '2063155402400358401', '112', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223929832583169', '2063155402400358401', '113', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223929975189506', '2063155402400358401', '114', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223930105212930', '2063155402400358401', '115', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223930243624961', '2063155402400358401', '116', '2026-06-06 19:38:12', 'xmei', '2026-06-06 19:38:12', 'xmei'),('2063223930377842690', '2063155402400358401', '117', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223930507866114', '2063155402400358401', '132', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223930637889537', '2063155402400358401', '19', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223930767912961', '2063155402400358401', '191', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223930902130690', '2063155402400358401', '192', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931040542721', '2063155402400358401', '193', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931166371842', '2063155402400358401', '194', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931304783873', '2063155402400358401', '196', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931434807297', '2063155402400358401', '197', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931564830722', '2063155402400358401', '198', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei'),('2063223931699048450', '2063155402400358401', '199', '2026-06-06 19:38:13', 'xmei', '2026-06-06 19:38:13', 'xmei')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_user` WRITE;
DELETE FROM `mes2026`.`sp_sys_user`;
INSERT INTO `mes2026`.`sp_sys_user` (`id`,`name`,`username`,`password`,`dept_id`,`email`,`mobile`,`tel`,`sex`,`birthday`,`pic_id`,`id_card`,`hobby`,`province`,`city`,`district`,`street`,`street_number`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1184009088826392578', '宋鹏', 'iamsongpeng', '9d7281eeaebded0b091340cfa658a7e8', '11', '', '13776337795', '', '1', NULL, '', '', '', '', '', '', '', '', '', '0', '2019-10-15 15:32:19', 'SongPeng', '2020-02-28 16:44:59', 'admin'),('1184010472443396098', '猴子', 'monkey', '9d7281eeaebded0b091340cfa658a7e8', '031', '', '137763377', '', '0', NULL, '', '', '', '', '', '', '', '', '', '0', '2019-10-15 15:37:52', 'SongPeng', '2020-02-26 15:03:32', 'admin'),('1184019107907227649', '超级管理员', 'admin', '9d7281eeaebded0b091340cfa658a7e8', '11', '', '13776337796', '44', '0', NULL, '55', '66', '77', '88', '99', '10', '11', '12', '13', '0', '2019-10-15 16:12:08', 'SongPeng', '2020-03-24 11:08:22', 'admin'),('1266201180838801409', 'cassman', 'cassman', '33cad7cd4719df4abaede73c63ed261e', '031', 'cassman.yang@qq.com', '1111', '86195', '1', '2019-05-21 00:00:00', '#sd', '45+645+65+6511', 'swim', 'sad', 'dsa', 'fasd', 'daf', 'dsaf', 'daf', '0', '2020-05-29 10:54:21', 'admin', '2026-05-24 00:15:36', 'admin'),('1276512902757724162', '小明', 'xm', 'a7c3fcdeca8ce6d49d2680eecd5e7431', '031', '1@qq.com', '19298833438', '323232', '0', '1998-09-12 00:00:00', '1', '1', '12', '1', '1', '1', '1', '1', '1', '0', '2020-06-26 21:49:27', 'admin', '2026-05-24 00:32:41', 'admin'),('2058121374051958786', 'wy', 'wangyu', '1e703a48e058c14df2ddb09df89c16d3', '1', '1313@qq.com', '121312', '113', '0', '2020-03-12 15:22:56', '234', '32144', 'dfsdf', 'dfd', 'fsdf', 'sdfsdf', 'df', 'sdf', 'fsd', '0', '2026-05-23 17:42:28', 'admin', '2026-05-23 23:51:00', 'admin'),('2058217005470736386', '小美', 'xmei', '5b5f1c15df6ea451798429b46ccfced0', '031', '329@qq.com', '1733', '1588', '0', '2026-06-06 00:00:00', '21', '3e2', '23113', '131', '13', '131', '313', '13', 'weea', '0', '2026-05-24 00:02:29', 'admin', '2026-06-06 19:38:57', 'admin'),('2063156791599980546', '王彧', 'wy123', 'a3ae420890da1dbcd350471f91d8f023', '03', '3295586312@qq.com', '17332009437', '17332009471', '0', '2005-01-08 00:00:00', '123', '211', '羽毛球', '河北', '邯郸', '复习区', '百家村街道', '23-1', '无', '0', '2026-06-06 15:11:25', 'admin', '2026-06-06 15:11:25', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_sys_user_role` WRITE;
DELETE FROM `mes2026`.`sp_sys_user_role`;
INSERT INTO `mes2026`.`sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1242287110472966146', '1184019107907227649', '1185025876737396738', '2020-03-24 11:08:22', 'admin', '2020-03-24 11:08:22', 'admin'),('2058214115872104450', '2058121374051958786', '1232532514523213826', '2026-05-23 23:51:00', 'admin', '2026-05-23 23:51:00', 'admin'),('2058220309210750978', '1266201180838801409', '1336542182244384', '2026-05-24 00:15:36', 'admin', '2026-05-24 00:15:36', 'admin'),('2058224608024326146', '1276512902757724162', '1336542182244384', '2026-05-24 00:32:41', 'admin', '2026-05-24 00:32:41', 'admin'),('2063156791918747650', '2063156791599980546', '1185025876737396738', '2026-06-06 15:11:25', 'admin', '2026-06-06 15:11:25', 'admin'),('2063224118806949890', '2058217005470736386', '2063155402400358401', '2026-06-06 19:38:57', 'admin', '2026-06-06 19:38:57', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_table_manager` WRITE;
DELETE FROM `mes2026`.`sp_table_manager`;
INSERT INTO `mes2026`.`sp_table_manager` (`id`,`table_name`,`table_desc`,`create_time`,`create_username`,`update_time`,`update_username`,`is_deleted`,`permission`) VALUES ('1283020801696837633', 'sp_bom', '', '2020-07-14 20:49:31', 'admin', '2020-07-14 20:49:31', 'admin', '0', '\"\"')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_table_manager_item` WRITE;
DELETE FROM `mes2026`.`sp_table_manager_item`;
INSERT INTO `mes2026`.`sp_table_manager_item` (`id`,`table_name_id`,`field`,`field_desc`,`must_fill`,`sort_num`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1283020801742974978', '1283020801696837633', 'materiel_desc', '888', 'Y', 1, '2020-07-14 20:49:31', 'admin', '2020-07-14 20:49:31', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_warehouse` WRITE;
DELETE FROM `mes2026`.`sp_warehouse`;
INSERT INTO `mes2026`.`sp_warehouse` (`id`,`code`,`name`,`type`,`address`,`status`,`descr`,`total_inventory`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('2058403303464652801', 'a1', '颜料库', '原料仓', 'a-1', '0', '', 0.0000, '1', '2026-05-24 12:22:45', 'admin', '2026-05-24 13:00:58', 'admin'),('wh001', 'WH-RAW-01', '原料仓A区', '原料仓', 'A栋1楼东侧', '0', '存放各类原材料', 936.0000, '0', '2026-05-24 12:53:58', 'admin', '2026-05-29 11:09:58', 'admin'),('wh002', 'WH-WIP-01', '半成品仓B区', '半成品仓', 'B栋2楼西侧', '0', '存放半成品及在制品', 0.0000, '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('wh003', 'WH-FG-01', '成品仓C区', '成品仓', 'C栋1楼全层', '0', '存放成品及待发货产品', 0.0000, '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('wh004', 'WH-LINE-01', '线边仓产线1', '线边仓', '车间1号线旁', '0', '产线1临时物料存放', 0.0000, '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_warehouse_location` WRITE;
DELETE FROM `mes2026`.`sp_warehouse_location`;
INSERT INTO `mes2026`.`sp_warehouse_location` (`id`,`warehouse_id`,`code`,`name`,`row_no`,`col_no`,`location_type`,`max_capacity`,`current_inventory`,`status`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('loc001', 'wh001', 'RAW-A-1-1', '原料仓A区1行1列', 1, 1, '存储位', 1000.00, 1786.00, '1', '钢材存放位', '0', '2026-05-24 12:53:58', 'admin', '2026-05-29 11:09:58', 'admin'),('loc002', 'wh001', 'RAW-A-1-2', '原料仓A区1行2列', 1, 2, '存储位', 1000.00, 1000.00, '2', '铝材存放位', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc003', 'wh001', 'RAW-A-1-3', '原料仓A区1行3列', 1, 3, '存储位', 800.00, 200.00, '1', '铜材存放位', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc004', 'wh001', 'RAW-A-2-1', '原料仓A区2行1列', 2, 1, '暂存位', 500.00, 0.00, '0', '来料待检区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc005', 'wh001', 'RAW-A-2-2', '原料仓A区2行2列', 2, 2, '检验位', 200.00, 50.00, '1', '来料检验区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc006', 'wh001', 'RAW-A-2-3', '原料仓A区2行3列', 2, 3, '不良品位', 100.00, 15.00, '1', '不良品暂存区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc007', 'wh001', 'RAW-A-3-1', '原料仓A区3行1列', 3, 1, '存储位', 1000.00, 1200.00, '3', '塑料件存放位(超储)', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc008', 'wh001', 'RAW-A-3-2', '原料仓A区3行2列', 3, 2, '存储位', 600.00, 0.00, '0', '辅料存放位', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc009', 'wh001', 'RAW-A-3-3', '原料仓A区3行3列', 3, 3, '存储位', 600.00, 350.00, '1', '包装材料存放位', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc010', 'wh002', 'WIP-B-1-1', '半成品仓1行1列', 1, 1, '存储位', 500.00, 320.00, '1', '机加工半成品', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc011', 'wh002', 'WIP-B-1-2', '半成品仓1行2列', 1, 2, '存储位', 500.00, 500.00, '2', '焊接半成品', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc012', 'wh002', 'WIP-B-1-3', '半成品仓1行3列', 1, 3, '暂存位', 300.00, 80.00, '1', '待装配组件', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc013', 'wh002', 'WIP-B-2-1', '半成品仓2行1列', 2, 1, '存储位', 500.00, 0.00, '0', '冲压件暂存', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc014', 'wh002', 'WIP-B-2-2', '半成品仓2行2列', 2, 2, '检验位', 200.00, 45.00, '1', '半成品检验区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc015', 'wh002', 'WIP-B-2-3', '半成品仓2行3列', 2, 3, '存储位', 400.00, 280.00, '1', '组装半成品', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc016', 'wh003', 'FG-C-1-1', '成品仓1行1列', 1, 1, '存储位', 800.00, 560.00, '1', '成品A型存放', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc017', 'wh003', 'FG-C-1-2', '成品仓1行2列', 1, 2, '存储位', 800.00, 800.00, '2', '成品B型存放', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc018', 'wh003', 'FG-C-1-3', '成品仓1行3列', 1, 3, '暂存位', 400.00, 0.00, '0', '待发货暂存区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc019', 'wh003', 'FG-C-2-1', '成品仓2行1列', 2, 1, '存储位', 600.00, 150.00, '1', '成品C型存放', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc020', 'wh003', 'FG-C-2-2', '成品仓2行2列', 2, 2, '不良品位', 100.00, 8.00, '1', '成品不良品暂存', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc021', 'wh003', 'FG-C-2-3', '成品仓2行3列', 2, 3, '存储位', 600.00, 0.00, '0', '成品D型存放', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc022', 'wh004', 'LINE-1-1', '线边仓1行1列', 1, 1, '暂存位', 200.00, 120.00, '1', '产线1物料暂存', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc023', 'wh004', 'LINE-1-2', '线边仓1行2列', 1, 2, '暂存位', 200.00, 0.00, '0', '产线1备料区', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin'),('loc024', 'wh004', 'LINE-1-3', '线边仓1行3列', 1, 3, '暂存位', 150.00, 90.00, '1', '产线1成品暂存', '0', '2026-05-24 12:53:58', 'admin', '2026-05-24 12:53:58', 'admin')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `mes2026`.`sp_work_shop` WRITE;
DELETE FROM `mes2026`.`sp_work_shop`;
INSERT INTO `mes2026`.`sp_work_shop` (`id`,`work_shop`,`work_shop_desc`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES ('1336875254022176', 'DC-车间1', '电池组装车间', '2020-03-14 11:29:57', 'admin', '2020-03-18 10:52:39', 'admin'),('1336875591663648', 'DC-JS01', '加酸车间', '2020-03-14 11:32:38', 'admin', '2020-03-14 11:32:38', 'admin')
;
UNLOCK TABLES;
COMMIT;
