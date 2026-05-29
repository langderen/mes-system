package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysGroupDTO;
import com.wangziyang.mes.system.entity.*;
import com.wangziyang.mes.system.request.SysGroupPageReq;
import com.wangziyang.mes.system.service.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
@RequestMapping("/admin/sys/group")
public class SysGroupController extends BaseController {

    @Autowired
    private ISysGroupService sysGroupService;

    @Autowired
    private ISysGroupUserService sysGroupUserService;

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    @Autowired
    private ISysUserService sysUserService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/group/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysGroupPageReq req) {
        QueryWrapper<SysGroup> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        qw.orderByDesc(req.getOrderBy());
        IPage<SysGroup> result = sysGroupService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysGroup record) {
        Set<String> checkedUserIds = new HashSet<>();
        if (StringUtils.isNotEmpty(record.getId())) {
            SysGroup group = sysGroupService.getById(record.getId());
            model.addAttribute("group", group);

            QueryWrapper<SysGroupUser> qw = new QueryWrapper<>();
            qw.eq("group_id", record.getId());
            List<SysGroupUser> groupUsers = sysGroupUserService.list(qw);
            for (SysGroupUser gu : groupUsers) {
                checkedUserIds.add(gu.getUserId());
            }
        }

        List<Map<String, Object>> deptUserTree = buildDeptUserTree(checkedUserIds);
        model.addAttribute("deptUserTree", deptUserTree);
        return "admin/system/group/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysGroupDTO record) throws Exception {
        sysGroupService.saveOrUpdate(record);
        sysGroupService.rebuildGroupUser(record);
        return Result.success(record.getId());
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysGroup record) {
        sysGroupService.removeById(record.getId());
        return Result.success();
    }

    private List<Map<String, Object>> buildDeptUserTree(Set<String> checkedUserIds) {
        List<SysDepartment> departments = sysDepartmentService.list(
                new QueryWrapper<SysDepartment>().eq("is_deleted", "0").orderByAsc("sort_num"));
        List<SysUser> users = sysUserService.list(
                new QueryWrapper<SysUser>().eq("is_deleted", "0").orderByAsc("name"));

        Map<String, List<SysUser>> deptUserMap = new LinkedHashMap<>();
        for (SysUser user : users) {
            String deptId = user.getDeptId();
            if (StringUtils.isEmpty(deptId)) {
                deptId = "0";
            }
            deptUserMap.computeIfAbsent(deptId, k -> new ArrayList<>()).add(user);
        }

        List<Map<String, Object>> tree = new ArrayList<>();
        Set<String> usedDeptIds = new HashSet<>();

        for (SysDepartment dept : departments) {
            List<Map<String, Object>> children = new ArrayList<>();
            List<SysUser> deptUsers = deptUserMap.get(dept.getId());
            if (deptUsers != null) {
                for (SysUser user : deptUsers) {
                    children.add(buildUserNode(user, checkedUserIds));
                }
                usedDeptIds.add(dept.getId());
            }

            Map<String, Object> deptNode = buildDeptNode(dept, children, checkedUserIds);
            tree.add(deptNode);
        }

        List<SysUser> unassignedUsers = deptUserMap.get("0");
        if (unassignedUsers != null) {
            List<Map<String, Object>> unassignedChildren = new ArrayList<>();
            for (SysUser user : unassignedUsers) {
                unassignedChildren.add(buildUserNode(user, checkedUserIds));
            }
            Map<String, Object> unassignedNode = new LinkedHashMap<>();
            unassignedNode.put("id", "0");
            unassignedNode.put("name", "未分配部门");
            unassignedNode.put("type", "dept");
            unassignedNode.put("checked", !unassignedChildren.isEmpty() && unassignedChildren.stream().allMatch(c -> Boolean.TRUE.equals(c.get("checked"))));
            unassignedNode.put("children", unassignedChildren);
            tree.add(unassignedNode);
        } else {
            Map<String, Object> unassignedNode2 = new LinkedHashMap<>();
            unassignedNode2.put("id", "0");
            unassignedNode2.put("name", "未分配部门");
            unassignedNode2.put("type", "dept");
            unassignedNode2.put("checked", false);
            unassignedNode2.put("children", new ArrayList<>());
            tree.add(unassignedNode2);
        }

        for (Map.Entry<String, List<SysUser>> entry : deptUserMap.entrySet()) {
            if (!usedDeptIds.contains(entry.getKey()) && !"0".equals(entry.getKey())) {
                List<Map<String, Object>> orphanChildren = new ArrayList<>();
                for (SysUser user : entry.getValue()) {
                    orphanChildren.add(buildUserNode(user, checkedUserIds));
                }
                Map<String, Object> orphanNode = new LinkedHashMap<>();
                orphanNode.put("id", entry.getKey());
                orphanNode.put("name", "未知部门(" + entry.getKey() + ")");
                orphanNode.put("type", "dept");
                orphanNode.put("checked", !orphanChildren.isEmpty() && orphanChildren.stream().allMatch(c -> Boolean.TRUE.equals(c.get("checked"))));
                orphanNode.put("children", orphanChildren);
                tree.add(orphanNode);
            }
        }

        return tree;
    }

    private Map<String, Object> buildDeptNode(SysDepartment dept, List<Map<String, Object>> children, Set<String> checkedUserIds) {
        Map<String, Object> node = new LinkedHashMap<>();
        node.put("id", dept.getId());
        node.put("name", dept.getName());
        node.put("type", "dept");
        node.put("checked", !children.isEmpty() && children.stream().allMatch(c -> Boolean.TRUE.equals(c.get("checked"))));
        node.put("children", children);
        return node;
    }

    private Map<String, Object> buildUserNode(SysUser user, Set<String> checkedUserIds) {
        Map<String, Object> node = new LinkedHashMap<>();
        node.put("id", user.getId());
        node.put("name", user.getName() + "(" + user.getUsername() + ")");
        node.put("type", "user");
        node.put("checked", checkedUserIds.contains(user.getId()));
        node.put("children", new ArrayList<>());
        return node;
    }
}