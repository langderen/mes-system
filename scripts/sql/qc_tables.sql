INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('18', 'quality', '质量管理', '#', '1', '2', 8, '0', 'user:add', 'fa fa-check-square-o', '', NOW(), 'admin', NOW(), 'admin');

-- 质量活动管理
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('181', 'qcActivity', '质量活动管理', '/quality/activity/list-ui', '18', '3', 1, '0', 'user:add', 'fa fa-calendar-check-o', '', NOW(), 'admin', NOW(), 'admin');

-- 质检资源管理
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('182', 'qcResource', '质检资源管理', '/quality/resource/list-ui', '18', '3', 2, '0', 'user:add', 'fa fa-wrench', '', NOW(), 'admin', NOW(), 'admin');

-- 质检定义管理
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('183', 'qcDef', '质检定义管理', '/quality/def/list-ui', '18', '3', 3, '0', 'user:add', 'fa fa-file-text-o', '', NOW(), 'admin', NOW(), 'admin');

-- 质检调度
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('184', 'qcPlan', '质检调度', '/quality/plan/list-ui', '18', '3', 4, '0', 'user:add', 'fa fa-tasks', '', NOW(), 'admin', NOW(), 'admin');

-- 质检分配
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('185', 'qcTask', '质检分配', '/quality/task/list-ui', '18', '3', 5, '0', 'user:add', 'fa fa-user-plus', '', NOW(), 'admin', NOW(), 'admin');

-- 质检执行
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('186', 'qcExecution', '质检执行', '/quality/execution/list-ui', '18', '3', 6, '0', 'user:add', 'fa fa-play-circle-o', '', NOW(), 'admin', NOW(), 'admin');

-- 质检数据收集
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('187', 'qcData', '质检数据收集', '/quality/data/list-ui', '18', '3', 7, '0', 'user:add', 'fa fa-database', '', NOW(), 'admin', NOW(), 'admin');

-- 统计分析
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('188', 'qcStatistics', '统计分析', '/quality/statistics/list-ui', '18', '3', 8, '0', 'user:add', 'fa fa-bar-chart', '', NOW(), 'admin', NOW(), 'admin');

-- 质检跟踪追溯
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) VALUES
('189', 'qcTrace', '质检跟踪追溯', '/quality/trace/list-ui', '18', '3', 9, '0', 'user:add', 'fa fa-search', '', NOW(), 'admin', NOW(), 'admin');