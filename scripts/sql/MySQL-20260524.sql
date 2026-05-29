INSERT INTO `sp_sys_menu` VALUES ('153', 'part', '零部件定义', '/productdata/part/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-cogs', '', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_menu` VALUES ('154', 'productbom', '产品BOM管理', '/productdata/productbom/list-ui', '15', '3', 2, '0', 'user:add', 'fa fa-sitemap', '', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_menu` VALUES ('155', 'operinfo', '工序信息定义', '/productdata/oper/list-ui', '15', '3', 3, '0', 'user:add', 'fa fa-tasks', '', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_menu` VALUES ('156', 'flowmanage', '工艺流程管理', '/productdata/flow/list-ui', '15', '3', 4, '0', 'user:add', 'fa fa-retweet', '', NOW(), 'admin', NOW(), 'admin');

-- =============================================
-- 库房测试数据
-- =============================================

INSERT INTO `sp_warehouse` (`id`, `code`, `name`, `type`, `address`, `status`, `descr`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('wh001', 'WH-RAW-01', '原料仓A区', '原料仓', 'A栋1楼东侧', '0', '存放各类原材料', '0', NOW(), 'admin', NOW(), 'admin'),
('wh002', 'WH-WIP-01', '半成品仓B区', '半成品仓', 'B栋2楼西侧', '0', '存放半成品及在制品', '0', NOW(), 'admin', NOW(), 'admin'),
('wh003', 'WH-FG-01', '成品仓C区', '成品仓', 'C栋1楼全层', '0', '存放成品及待发货产品', '0', NOW(), 'admin', NOW(), 'admin'),
('wh004', 'WH-LINE-01', '线边仓产线1', '线边仓', '车间1号线旁', '0', '产线1临时物料存放', '0', NOW(), 'admin', NOW(), 'admin');

INSERT INTO `sp_warehouse_location` (`id`, `warehouse_id`, `code`, `name`, `row_no`, `col_no`, `location_type`, `max_capacity`, `current_inventory`, `status`, `descr`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('loc001', 'wh001', 'RAW-A-1-1', '原料仓A区1行1列', 1, 1, '存储位', 1000.00, 850.00, '1', '钢材存放位', '0', NOW(), 'admin', NOW(), 'admin'),
('loc002', 'wh001', 'RAW-A-1-2', '原料仓A区1行2列', 1, 2, '存储位', 1000.00, 1000.00, '2', '铝材存放位', '0', NOW(), 'admin', NOW(), 'admin'),
('loc003', 'wh001', 'RAW-A-1-3', '原料仓A区1行3列', 1, 3, '存储位', 800.00, 200.00, '1', '铜材存放位', '0', NOW(), 'admin', NOW(), 'admin'),
('loc004', 'wh001', 'RAW-A-2-1', '原料仓A区2行1列', 2, 1, '暂存位', 500.00, 0.00, '0', '来料待检区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc005', 'wh001', 'RAW-A-2-2', '原料仓A区2行2列', 2, 2, '检验位', 200.00, 50.00, '1', '来料检验区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc006', 'wh001', 'RAW-A-2-3', '原料仓A区2行3列', 2, 3, '不良品位', 100.00, 15.00, '1', '不良品暂存区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc007', 'wh001', 'RAW-A-3-1', '原料仓A区3行1列', 3, 1, '存储位', 1000.00, 1200.00, '3', '塑料件存放位(超储)', '0', NOW(), 'admin', NOW(), 'admin'),
('loc008', 'wh001', 'RAW-A-3-2', '原料仓A区3行2列', 3, 2, '存储位', 600.00, 0.00, '0', '辅料存放位', '0', NOW(), 'admin', NOW(), 'admin'),
('loc009', 'wh001', 'RAW-A-3-3', '原料仓A区3行3列', 3, 3, '存储位', 600.00, 350.00, '1', '包装材料存放位', '0', NOW(), 'admin', NOW(), 'admin'),
('loc010', 'wh002', 'WIP-B-1-1', '半成品仓1行1列', 1, 1, '存储位', 500.00, 320.00, '1', '机加工半成品', '0', NOW(), 'admin', NOW(), 'admin'),
('loc011', 'wh002', 'WIP-B-1-2', '半成品仓1行2列', 1, 2, '存储位', 500.00, 500.00, '2', '焊接半成品', '0', NOW(), 'admin', NOW(), 'admin'),
('loc012', 'wh002', 'WIP-B-1-3', '半成品仓1行3列', 1, 3, '暂存位', 300.00, 80.00, '1', '待装配组件', '0', NOW(), 'admin', NOW(), 'admin'),
('loc013', 'wh002', 'WIP-B-2-1', '半成品仓2行1列', 2, 1, '存储位', 500.00, 0.00, '0', '冲压件暂存', '0', NOW(), 'admin', NOW(), 'admin'),
('loc014', 'wh002', 'WIP-B-2-2', '半成品仓2行2列', 2, 2, '检验位', 200.00, 45.00, '1', '半成品检验区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc015', 'wh002', 'WIP-B-2-3', '半成品仓2行3列', 2, 3, '存储位', 400.00, 280.00, '1', '组装半成品', '0', NOW(), 'admin', NOW(), 'admin'),
('loc016', 'wh003', 'FG-C-1-1', '成品仓1行1列', 1, 1, '存储位', 800.00, 560.00, '1', '成品A型存放', '0', NOW(), 'admin', NOW(), 'admin'),
('loc017', 'wh003', 'FG-C-1-2', '成品仓1行2列', 1, 2, '存储位', 800.00, 800.00, '2', '成品B型存放', '0', NOW(), 'admin', NOW(), 'admin'),
('loc018', 'wh003', 'FG-C-1-3', '成品仓1行3列', 1, 3, '暂存位', 400.00, 0.00, '0', '待发货暂存区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc019', 'wh003', 'FG-C-2-1', '成品仓2行1列', 2, 1, '存储位', 600.00, 150.00, '1', '成品C型存放', '0', NOW(), 'admin', NOW(), 'admin'),
('loc020', 'wh003', 'FG-C-2-2', '成品仓2行2列', 2, 2, '不良品位', 100.00, 8.00, '1', '成品不良品暂存', '0', NOW(), 'admin', NOW(), 'admin'),
('loc021', 'wh003', 'FG-C-2-3', '成品仓2行3列', 2, 3, '存储位', 600.00, 0.00, '0', '成品D型存放', '0', NOW(), 'admin', NOW(), 'admin'),
('loc022', 'wh004', 'LINE-1-1', '线边仓1行1列', 1, 1, '暂存位', 200.00, 120.00, '1', '产线1物料暂存', '0', NOW(), 'admin', NOW(), 'admin'),
('loc023', 'wh004', 'LINE-1-2', '线边仓1行2列', 1, 2, '暂存位', 200.00, 0.00, '0', '产线1备料区', '0', NOW(), 'admin', NOW(), 'admin'),
('loc024', 'wh004', 'LINE-1-3', '线边仓1行3列', 1, 3, '暂存位', 150.00, 90.00, '1', '产线1成品暂存', '0', NOW(), 'admin', NOW(), 'admin');

-- =============================================
-- BOM工序绑定表（工艺流程规划）
-- =============================================

DROP TABLE IF EXISTS `sp_bom_oper_binding`;
CREATE TABLE `sp_bom_oper_binding` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM ID',
  `bom_item_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM子项ID',
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工序ID',
  `oper_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序编码',
  `oper_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序名称',
  `sort_no` int(11) NOT NULL DEFAULT 1 COMMENT '排序号',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bom_item_id`(`bom_item_id`) USING BTREE,
  INDEX `idx_bom_id`(`bom_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT = 'BOM工序绑定表' ROW_FORMAT = Dynamic;

-- =============================================
-- 扩展 sp_product_bom_item 表的 oper_id 和 oper_code 列长度
-- 支持多个工序ID/编码的逗号拼接存储
-- =============================================
ALTER TABLE `sp_product_bom_item` MODIFY COLUMN `oper_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序ID（多个逗号分隔）';
ALTER TABLE `sp_product_bom_item` MODIFY COLUMN `oper_code` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序编码（多个逗号分隔）';
-- =============================================
-- �������̷��༰���̶�����չ�ֶ�
-- =============================================

DROP TABLE IF EXISTS `sp_flow_category`;
CREATE TABLE `sp_flow_category` (
  `id` varchar(64) NOT NULL COMMENT '����id',
  `category_code` varchar(64) NOT NULL COMMENT '�������',
  `category_name` varchar(128) NOT NULL COMMENT '��������',
  `category_desc` varchar(255) DEFAULT NULL COMMENT '��������',
  `sort_num` int(11) NOT NULL DEFAULT 1 COMMENT '����',
  `state` varchar(32) DEFAULT NULL COMMENT '״̬',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT 'ɾ�����',
  `create_time` datetime(0) NOT NULL COMMENT '����ʱ��',
  `create_username` varchar(64) NOT NULL COMMENT '������',
  `update_time` datetime(0) NOT NULL COMMENT '����ʱ��',
  `update_username` varchar(64) NOT NULL COMMENT '������',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='���̷����';

ALTER TABLE `sp_flow`
  ADD COLUMN `flow_category_id` varchar(64) DEFAULT NULL COMMENT '���̷���ID' AFTER `flow_type`,
  ADD COLUMN `flow_category_name` varchar(128) DEFAULT NULL COMMENT '���̷�������' AFTER `flow_category_id`,
  ADD COLUMN `script_content` text COMMENT '�ű�����' AFTER `state`,
  ADD COLUMN `bind_type` varchar(32) DEFAULT 'process' COMMENT '������(process/button)' AFTER `script_content`,
  ADD COLUMN `button_code` varchar(128) DEFAULT NULL COMMENT '��ť����' AFTER `bind_type`;

-- =============================================
-- 流程基础表补建
-- =============================================

CREATE TABLE IF NOT EXISTS `sp_flow` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `flow` varchar(255) NOT NULL COMMENT '流程',
  `flow_desc` varchar(255) NOT NULL COMMENT '线体描述',
  `process` text COMMENT '流程绘制JSON',
  `flow_type` varchar(64) DEFAULT NULL COMMENT '流程类型',
  `flow_category_id` varchar(64) DEFAULT NULL COMMENT '流程分类ID',
  `flow_category_name` varchar(128) DEFAULT NULL COMMENT '流程分类名称',
  `product_part_id` varchar(64) DEFAULT NULL COMMENT '产品零件ID',
  `product_part_code` varchar(255) DEFAULT NULL COMMENT '产品零件编码',
  `version` varchar(64) DEFAULT NULL COMMENT '版本',
  `state` varchar(64) DEFAULT NULL COMMENT '状态',
  `script_content` text COMMENT '脚本内容',
  `bind_type` varchar(32) DEFAULT 'process' COMMENT '绑定类型(process/button)',
  `button_code` varchar(128) DEFAULT NULL COMMENT '按钮编码',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程表';

CREATE TABLE IF NOT EXISTS `sp_flow_oper_relation` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `flow_id` varchar(255) NOT NULL COMMENT '流程ID',
  `flow` varchar(255) NOT NULL COMMENT '流程代码',
  `per_oper_id` varchar(255) DEFAULT NULL COMMENT '前道工序ID',
  `per_oper` varchar(255) DEFAULT NULL COMMENT '前道工序代码',
  `oper_id` varchar(255) DEFAULT NULL COMMENT '当前工序ID',
  `oper` varchar(255) DEFAULT NULL COMMENT '当前工序',
  `next_oper_id` varchar(255) DEFAULT NULL COMMENT '下道工序ID',
  `next_oper` varchar(255) DEFAULT NULL COMMENT '下道工序',
  `sort_num` int(11) DEFAULT NULL COMMENT '排序',
  `oper_type` varchar(64) DEFAULT NULL COMMENT '工序类型',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `flow_id_index` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程与工序关系表';

CREATE TABLE IF NOT EXISTS `sp_flow_category` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `category_code` varchar(64) NOT NULL COMMENT '分类编码',
  `category_name` varchar(128) NOT NULL COMMENT '分类名称',
  `category_desc` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `sort_num` int(11) NOT NULL DEFAULT 1 COMMENT '排序',
  `state` varchar(32) DEFAULT NULL COMMENT '状态',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程分类表';

-- =============================================
-- 增量迁移：sp_flow.process 列从 varchar(255) 改为 text，以支持流程图JSON数据
-- =============================================
ALTER TABLE `sp_flow` MODIFY COLUMN `process` text COMMENT '流程绘制JSON';

CREATE TABLE IF NOT EXISTS `sp_flow_form` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `flow_id` varchar(64) NOT NULL COMMENT '流程ID',
  `form_name` varchar(255) NOT NULL COMMENT '表单名称',
  `form_key` varchar(128) NOT NULL COMMENT '表单key',
  `form_type` varchar(32) DEFAULT 'default' COMMENT '表单类型(default/script/url)',
  `flow_title` varchar(255) DEFAULT NULL COMMENT '流程标题',
  `pc_form_url` varchar(512) DEFAULT NULL COMMENT 'PC表单地址',
  `mobile_form_url` varchar(512) DEFAULT NULL COMMENT '手机表单地址',
  `init_script` text COMMENT '表单初始化脚本',
  `approve_script` text COMMENT '审批通过脚本',
  `reject_script` text COMMENT '审批退回脚本',
  `end_script` text COMMENT '流程结束脚本',
  `skip_first` tinyint(1) DEFAULT 0 COMMENT '跳过第一个环节',
  `skip_same_handler` tinyint(1) DEFAULT 0 COMMENT '跳过相同处理人',
  `allow_return` tinyint(1) DEFAULT 1 COMMENT '允许退回',
  `allow_transfer` tinyint(1) DEFAULT 1 COMMENT '允许转办',
  `allow_delegate` tinyint(1) DEFAULT 1 COMMENT '允许委托',
  `allow_withdraw` tinyint(1) DEFAULT 1 COMMENT '允许撤回',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程表单表';
