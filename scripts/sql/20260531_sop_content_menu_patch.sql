SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================
-- SOP工艺内容编制模块 - 菜单数据
-- 创建日期: 2026-05-31
-- =============================================

-- 1B: SOP工艺内容编制（二级菜单，父级为1-基础数据）
INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('1B', 'sopContentManage', 'SOP工艺内容编制', '/technology/sop/content/list-ui', '1', '2', 6, '0', 'user:add', 'fa fa-file-text', '', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
