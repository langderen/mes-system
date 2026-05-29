SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `type`, `sort_num`, `is_deleted`, `permission`, `icon`, `remark`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('122', 'mrp', '物料需求计划', '/order/mrp/list-ui', '12', '3', 2, '0', 'user:add', 'fa fa-list-alt', '', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
