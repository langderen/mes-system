SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `sp_warehouse`
  ADD COLUMN `total_inventory` decimal(18,4) DEFAULT '0.0000' COMMENT 'warehouse total inventory' AFTER `descr`;

DROP TABLE IF EXISTS `sp_inbound_order`;
CREATE TABLE `sp_inbound_order` (
  `id` varchar(64) NOT NULL COMMENT 'primary key',
  `inbound_no` varchar(255) NOT NULL COMMENT 'inbound no',
  `source_mrp_nos` varchar(1000) DEFAULT NULL COMMENT 'source mrp nos',
  `status` varchar(64) DEFAULT NULL COMMENT 'status',
  `item_count` int(11) DEFAULT '0' COMMENT 'item count',
  `total_demand_qty` decimal(18,4) DEFAULT '0.0000' COMMENT 'total demand qty',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `is_deleted` varchar(1) DEFAULT '0' COMMENT 'deleted flag',
  `warehouse_id` varchar(64) DEFAULT NULL COMMENT 'warehouse id',
  `warehouse_location_id` varchar(64) DEFAULT NULL COMMENT 'warehouse location id',
  `warehouse_location_ids` varchar(1000) DEFAULT NULL COMMENT 'warehouse location ids',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`),
  KEY `idx_inbound_no` (`inbound_no`),
  KEY `idx_status` (`status`),
  KEY `idx_warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='plan inbound order';

DROP TABLE IF EXISTS `sp_inbound_order_item`;
CREATE TABLE `sp_inbound_order_item` (
  `id` varchar(64) NOT NULL COMMENT 'primary key',
  `inbound_order_id` varchar(64) NOT NULL COMMENT 'inbound order id',
  `source_mrp_record_id` varchar(64) NOT NULL COMMENT 'source mrp record id',
  `mrp_no` varchar(255) DEFAULT NULL COMMENT 'mrp no',
  `order_code` varchar(255) DEFAULT NULL COMMENT 'source order no',
  `bom_code` varchar(255) DEFAULT NULL COMMENT 'bom code',
  `product_code` varchar(255) DEFAULT NULL COMMENT 'product code',
  `product_name` varchar(255) DEFAULT NULL COMMENT 'product name',
  `part_code` varchar(255) DEFAULT NULL COMMENT 'part code',
  `part_name` varchar(255) DEFAULT NULL COMMENT 'part name',
  `demand_qty` decimal(18,4) DEFAULT NULL COMMENT 'demand qty',
  `unit` varchar(64) DEFAULT NULL COMMENT 'unit',
  `is_deleted` varchar(1) DEFAULT '0' COMMENT 'deleted flag',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `create_username` varchar(64) NOT NULL COMMENT 'create username',
  `update_time` datetime NOT NULL COMMENT 'update time',
  `update_username` varchar(64) NOT NULL COMMENT 'update username',
  PRIMARY KEY (`id`),
  KEY `idx_inbound_order_id` (`inbound_order_id`),
  KEY `idx_source_mrp_record_id` (`source_mrp_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='plan inbound order item';

SET FOREIGN_KEY_CHECKS = 1;
