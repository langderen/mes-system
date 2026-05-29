SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `sp_order`
  ADD COLUMN `source_order_no` varchar(255) NULL DEFAULT NULL COMMENT 'source order no' AFTER `statue`,
  ADD COLUMN `generated_plan_no` varchar(255) NULL DEFAULT NULL COMMENT 'generated plan no' AFTER `source_order_no`,
  ADD COLUMN `generated_mrp_no` varchar(255) NULL DEFAULT NULL COMMENT 'generated mrp no' AFTER `generated_plan_no`;

DROP TABLE IF EXISTS `sp_mrp_record`;
CREATE TABLE `sp_mrp_record` (
  `id` varchar(64) NOT NULL COMMENT 'primary key',
  `mrp_no` varchar(255) NOT NULL COMMENT 'mrp no',
  `order_code` varchar(255) DEFAULT NULL COMMENT 'source order no',
  `bom_code` varchar(255) DEFAULT NULL COMMENT 'bom code',
  `product_code` varchar(255) DEFAULT NULL COMMENT 'product code',
  `product_name` varchar(255) DEFAULT NULL COMMENT 'product name',
  `part_code` varchar(255) DEFAULT NULL COMMENT 'part code',
  `part_name` varchar(255) DEFAULT NULL COMMENT 'part name',
  `demand_qty` decimal(18,4) DEFAULT NULL COMMENT 'demand qty',
  `unit` varchar(64) DEFAULT NULL COMMENT 'unit',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`),
  KEY `idx_mrp_no` (`mrp_no`),
  KEY `idx_order_code` (`order_code`),
  KEY `idx_part_code` (`part_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='mrp record';

SET FOREIGN_KEY_CHECKS = 1;
