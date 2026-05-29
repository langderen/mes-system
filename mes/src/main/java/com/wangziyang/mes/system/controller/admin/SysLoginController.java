package com.wangziyang.mes.system.controller.admin;

import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysMenuService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 系统登录
 *
 * @author SongPeng
 * @date 2019/9/27 16:05
 */
@RequestMapping("/admin")
@Controller("adminSysLoginController")
public class SysLoginController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysLoginController.class);

    /**
     * 系统菜单 Service
     */
    @Autowired
    private ISysMenuService sysMenuService;

    /**
     * 后台管理首页
     *
     * @param model
     * @return
     */
    @GetMapping({"", "/index"})
    public String indexUI(Model model) {
        try {
            Subject subject = SecurityUtils.getSubject();
            if (subject != null && subject.getPrincipal() != null) {
                Object principal = subject.getPrincipal();
                if (principal instanceof SysUser) {
                    SysUser user = (SysUser) principal;
                    model.addAttribute("currentUser", user);
                }
            }
        } catch (Exception e) {
            logger.warn("获取当前登录用户失败", e);
        }
        return "admin/index";
    }

    /**
     * 后台管理欢迎页
     *
     * @param model
     * @return
     */
    @ApiOperation("后台管理欢迎页")
    @GetMapping("/welcome-ui")
    public String welcomeUI(Model model) {
        return "admin/welcome";
    }

    /**
     * 系统首页初始化菜单树数据
     * @return 菜单树数据
     * @throws Exception 异常
     */
    @ApiOperation("系统首页初始化菜单树数据")
    @GetMapping("/list/index/menu/tree")
    @ResponseBody
    public Result tree() throws Exception {
        Set<String> roleIds = getCurrentUserRoleIds();
        Map<String, Object> result = sysMenuService.listIndexMenuTreeByRoleIds(roleIds);
        return Result.success(result);
    }

    /**
     * 用户搜索系统首页初始化菜单树数据
     * @param menuName 菜单名字
     * @return 菜单树数据
     * @throws Exception 异常
     */
    @ApiOperation("系统首页初始化菜单树数据")
    @GetMapping("/list/index/menu/search/tree/{menuName}")
    @ResponseBody
    public Result searchTree(@PathVariable String menuName) throws Exception {
        Set<String> roleIds = getCurrentUserRoleIds();
        Map<String, Object> result = sysMenuService.listIndexMenuSearchTreeByRoleIds(menuName, roleIds);
        return Result.success(result);
    }

    private Set<String> getCurrentUserRoleIds() {
        Set<String> roleIds = new HashSet<>();
        try {
            Subject subject = SecurityUtils.getSubject();
            if (subject != null && subject.getPrincipal() != null) {
                Object principal = subject.getPrincipal();
                if (principal instanceof SysUserDTO) {
                    SysUserDTO user = (SysUserDTO) principal;
                    if (CollectionUtils.isNotEmpty(user.getSysRoleDTOs())) {
                        for (SysRoleDTO role : user.getSysRoleDTOs()) {
                            roleIds.add(role.getId());
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.warn("获取当前用户角色失败", e);
        }
        return roleIds;
    }
}
