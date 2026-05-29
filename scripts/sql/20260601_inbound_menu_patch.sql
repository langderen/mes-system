SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `sp_sys_menu`
(`id`, `name`, `label`, `path`, `parent_id`, `sort`, `level`, `status`, `permission`, `icon`, `remark`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('123', 'inbound', '计划入库确认', '/order/inbound/list-ui', '12', '4', 2, '0', 'user:add', 'fa fa-database', '', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
