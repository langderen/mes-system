package com.wangziyang.mes.util;

import com.wangziyang.mes.common.util.TreeUtil;
import com.wangziyang.mes.system.vo.TreeVO;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

/**
 * TreeUtil 单元测试
 */
public class TreeUtilUnitTest {

    @Test
    public void testBuild_nullInput() {
        TreeVO<Object> result = TreeUtil.build(null);
        assertNull("null输入应返回null", result);
    }

    @Test
    public void testBuild_singleNode() {
        List<TreeVO<String>> nodes = new ArrayList<>();
        TreeVO<String> node = new TreeVO<>();
        node.setId("1");
        node.setPid("0");
        node.setName("根节点");
        nodes.add(node);

        TreeVO<String> root = TreeUtil.build(nodes);
        assertNotNull("单个节点不应返回null", root);
        assertEquals("1", root.getId());
        assertEquals("根节点", root.getName());
    }

    @Test
    public void testBuild_twoLevelTree() {
        List<TreeVO<String>> nodes = new ArrayList<>();
        TreeVO<String> parent = new TreeVO<>();
        parent.setId("1");
        parent.setPid("0");
        parent.setName("父节点");
        nodes.add(parent);

        TreeVO<String> child = new TreeVO<>();
        child.setId("2");
        child.setPid("1");
        child.setName("子节点");
        nodes.add(child);

        TreeVO<String> root = TreeUtil.build(nodes);
        assertNotNull(root);
        assertTrue("父节点应有子节点", root.isHaveChild() || root.getChildren().size() > 0);
    }

    @Test
    public void testBuild_multipleTopNodes() {
        List<TreeVO<String>> nodes = new ArrayList<>();
        for (int i = 1; i <= 3; i++) {
            TreeVO<String> node = new TreeVO<>();
            node.setId(String.valueOf(i));
            node.setPid("0");
            node.setName("节点" + i);
            nodes.add(node);
        }

        TreeVO<String> root = TreeUtil.build(nodes);
        assertNotNull(root);
        assertEquals("-1", root.getId());
        assertEquals("顶级节点", root.getName());
        assertEquals(3, root.getChildren().size());
    }

    @Test
    public void testBuildList_nullInput() {
        List<TreeVO<String>> result = TreeUtil.buildList(null, "0");
        assertNull("null输入应返回null", result);
    }

    @Test
    public void testBuildList_withIdParam() {
        List<TreeVO<String>> nodes = new ArrayList<>();
        TreeVO<String> node1 = new TreeVO<>();
        node1.setId("1");
        node1.setPid("root");
        node1.setName("节点1");
        nodes.add(node1);

        TreeVO<String> node2 = new TreeVO<>();
        node2.setId("2");
        node2.setPid("1");
        node2.setName("节点2");
        nodes.add(node2);

        List<TreeVO<String>> topNodes = TreeUtil.buildList(nodes, "root");
        assertEquals(1, topNodes.size());
        assertEquals("节点1", topNodes.get(0).getName());
    }

    @Test
    public void testBuildList_emptyList() {
        List<TreeVO<String>> nodes = new ArrayList<>();
        List<TreeVO<String>> result = TreeUtil.buildList(nodes, "0");
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}