package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.dto.SysMenuDTO;
import com.wangziyang.mes.system.entity.SysMenu;
import com.wangziyang.mes.system.vo.TreeVO;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
public interface ISysMenuService extends IService<SysMenu> {


    /**
     * 根据角色id查询菜单列表
     *
     * @param roleId
     * @return
     * @throws Exception
     */
    List<SysMenuDTO> listByRoleId(String roleId) throws Exception;

    /**
     * 系统首页初始化菜单树数据
     *
     * @return 系统首页初始化菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuTree() throws Exception;


    /**
     * 用户搜索系统首页初始化菜单树数据
     *
     * @return 系统首页初始化菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuSearchTree(String menuName) throws Exception;


    /**
     * 获取系统菜单树
     *
     * @return 系统菜单树
     * @throws Exception 异常
     */
    List<TreeVO<SysMenu>> listMenuTree() throws Exception;

    /**
     * 查询所有菜单并标记角色是否拥有
     *
     * @param roleId 角色ID
     * @return 菜单DTO列表(含checked标记)
     * @throws Exception 异常
     */
    List<SysMenuDTO> listWithRoleChecked(String roleId) throws Exception;

    /**
     * 根据用户角色获取菜单树（仅返回用户有权访问的菜单）
     *
     * @param roleIds 用户拥有的角色ID集合
     * @return 菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuTreeByRoleIds(Set<String> roleIds) throws Exception;

    /**
     * 根据用户角色搜索菜单树
     *
     * @param menuName 搜索关键字
     * @param roleIds 用户拥有的角色ID集合
     * @return 菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuSearchTreeByRoleIds(String menuName, Set<String> roleIds) throws Exception;
}
