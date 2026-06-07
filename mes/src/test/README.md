# MES系统单元测试说明

## 测试架构

MES系统采用**单元测试**架构，使用JUnit 4 + Mockito框架进行服务层和工具类的单元测试。

```
src/test/java/com/wangziyang/mes/
├── common/
│   └── CommonUnitTest.java              # 通用类测试（Result、BasePageReq、BaseEntity）
├── entity/
│   └── EntityUnitTest.java              # 实体类测试（派工单状态流转等）
├── util/
│   ├── HashUtilTest.java                # 哈希工具测试
│   ├── IdUtilTest.java                  # ID生成工具测试
│   ├── HttpUtilTest.java                # HTTP工具测试
│   └── TreeUtilTest.java                # 树形结构工具测试
├── basedata/
│   └── MaterialInfoServiceUnitTest.java # 物料管理服务测试
├── system/
│   ├── SysRoleServiceUnitTest.java      # 角色服务测试
│   └── SysUserServiceUnitTest.java      # 用户服务测试
└── production/
    └── DispatchOrderUnitTest.java       # 派工单测试
```

## 测试框架

- **JUnit 4**: 测试框架
- **Mockito**: Mock对象框架，用于隔离依赖
- **MyBatis-Plus**: 提供Mapper层的Mock支持

## 运行方式

### 环境配置

确保Java环境已配置：
```bash
# Windows PowerShell
$env:JAVA_HOME = "C:\Users\wy\.jdks\corretto-1.8.0_492"
$env:PATH = "$env:JAVA_HOME\bin;C:\Users\wy\.m2\wrapper\dists\apache-maven-3.9.12-bin\5nmfsn99br87k5d4ajlekdq10k\apache-maven-3.9.12\bin;$env:PATH"
```

### 运行全部测试
```bash
mvn test
```

### 运行指定测试类
```bash
mvn test -Dtest=CommonUnitTest
mvn test -Dtest=SysRoleServiceUnitTest
mvn test -Dtest=MaterialInfoServiceUnitTest
```

### 运行指定测试方法
```bash
mvn test -Dtest=CommonUnitTest#testResultSuccess_noData
mvn test -Dtest=SysRoleServiceUnitTest#testRebuild_clearOldRoles
```

### 清理后重新测试
```bash
mvn clean test
```

## 测试覆盖范围

| 测试类 | 测试方法数 | 测试内容 |
|--------|-----------|---------|
| CommonUnitTest | 11 | Result类、BasePageReq、BaseEntity的getter/setter测试 |
| EntityUnitTest | 5 | 实体类属性、状态流转、业务规则验证 |
| UtilUnitTest | 14 | HashUtil、IdUtil的工具方法测试 |
| HttpUtilUnitTest | 4 | HTTP请求工具方法测试 |
| TreeUtilUnitTest | 7 | 树形结构构建工具测试 |
| MaterialInfoServiceUnitTest | 5 | 物料编码生成逻辑测试 |
| SysRoleServiceUnitTest | 6 | 角色重建、权限分配逻辑测试 |
| SysUserServiceUnitTest | 7 | 用户角色关联、权限重建测试 |
| DispatchOrderUnitTest | 7 | 派工单状态流转测试 |

**总计：66个测试用例，全部通过** ✅

## 测试详解

### 1. CommonUnitTest（通用类测试）

测试通用返回对象和基础类的功能：

```java
// Result类测试
- testResultSuccess_noData()      # 测试无数据的成功返回
- testResultSuccess_withData()    # 测试带数据的成功返回
- testResultError()               # 测试自定义错误返回
- testResultError_default()       # 测试默认错误返回
- testResultErrorWithCode()       # 测试自定义错误码返回
- testResultSetAndGet()           # 测试属性getter/setter

// BasePageReq测试
- testBasePageReq_defaultOrderBy()  # 测试默认排序字段
- testBasePageReq_customOrderBy()   # 测试自定义排序字段
- testBasePageReq_pagination()       # 测试分页参数

// BaseEntity测试
- testBaseEntity_setAndGet()       # 测试实体属性赋值
- testBaseEntity_defaultValues()   # 测试默认值
```

### 2. MaterialInfoServiceUnitTest（物料编码生成）

测试物料服务层的业务逻辑：

```java
// 物料编码生成规则：日期前缀 + 4位序号
// 例如：202606070001 表示2026年6月7日第1个物料

- testGenerateMaterialCode_firstOfDay()     # 测试当天第一个编码
- testGenerateMaterialCode_increment()      # 测试编码递增
- testGenerateMaterialCode_withPrefix()     # 测试带前缀编码
- testGenerateMaterialCode_dateChange()     # 测试跨天编码重置
- testGenerateMaterialCode_concurrent()      # 测试并发场景
```

### 3. SysRoleServiceUnitTest（角色权限服务）

测试角色重建和权限分配逻辑：

```java
- testRebuild_clearOldRoles()        # 测试清除旧角色关系
- testRebuild_addNewRoles()         # 测试添加新角色关系
- testRebuildRoleMenu_clearOldMenus() # 测试清除旧菜单权限
- testRebuildRoleMenu_addNewMenus()   # 测试添加新菜单权限
- testRebuild_emptyRoleIds()        # 测试空角色ID
- testRebuild_nullRoleIds()         # 测试null角色ID
```

### 4. DispatchOrderUnitTest（派工单状态流转）

测试派工单的完整状态生命周期：

```java
// 状态流转：draft → assigned → started → inspected → completed

- testStatusFlow_draftToAssigned()       # 草稿→已分配
- testStatusFlow_assignedToStarted()     # 已分配→已开工
- testStatusFlow_startedToInspected()    # 已开工→已质检
- testStatusFlow_inspectedToCompleted()  # 已质检→已完成
- testStatusFlow_invalidTransition()    # 测试非法状态转换
- testStatusFlow_timeTracking()          # 测试时间戳记录
- testStatusFlow_quantityValidation()    # 测试数量验证
```

### 5. UtilUnitTest（工具类测试）

测试各类工具方法的正确性：

```java
// HashUtil测试（SHA-1哈希）
- testSha1AsBytes_shouldReturn20Bytes()        # SHA-1应产生20字节
- testSha1AsBytes_sameInputSameOutput()        # 相同输入相同输出
- testSha1AsBytes_differentInputDifferentOutput() # 不同输入不同输出
- testSha1AsBytes_emptyString()                 # 空字符串哈希
- testSha1AsBytes_chineseString()               # 中文内容哈希

// IdUtil测试（ID生成）
- testNextId_notNull()          # ID不为null
- testNextId_notEmpty()         # ID不为空
- testNextId_isNumeric()        # ID为纯数字
- testNextId_uniqueness()       # ID唯一性（1000次生成）
- testNextId_positive()          # ID为正数
- testNextId_increasing()        # ID递增
- testStringIdToLongId_invalidInput()  # 无效输入处理
- testStringIdToLongId_nullInput()      # null输入处理
- testStringIdToLongId_emptyInput()     # 空字符串处理
```

## 测试配置

### pom.xml依赖

测试依赖已在 `pom.xml` 中配置：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

### 测试报告

测试完成后，Maven Surefire插件会在 `target/surefire-reports` 目录生成测试报告：

- `TEST-*.xml`: JUnit XML格式报告
- `*.txt`: 纯文本格式报告

### 编译警告说明

部分测试类使用了未经检查的操作（如泛型类型转换），编译器会提示警告：

```
有关详细信息, 请使用 -Xlint:unchecked 重新编译
```

这些警告不影响测试执行，使用了 `@SuppressWarnings("unchecked")` 注解来抑制警告。

## 最佳实践

### 1. 编写单元测试的原则

- **独立性**: 每个测试方法独立运行，不依赖其他测试
- **可重复性**: 测试结果稳定，可重复执行
- **可读性**: 测试名称清晰，描述测试意图
- **快速性**: 单元测试应快速执行

### 2. Mockito使用规范

```java
// ✅ 正确：Mock依赖的服务
@Mock
private SysRoleMapper sysRoleMapper;

@Mock
private ISysUserRoleService sysUserRoleService;

// ❌ 错误：不要Mock被测试的类本身
@InjectMocks
private SysRoleServiceImpl sysRoleService; // 这是被测类，不是Mock
```

### 3. 断言规范

```java
// ✅ 清晰的消息
assertEquals("SHA-1 应产生20字节", 20, result.length);

// ✅ 使用 assertTrue/assertFalse
assertTrue("ID应为正数", longId > 0);
assertFalse("ID应唯一", ids.contains(id));

// ✅ 异常测试
try {
    IdUtil.stringIdToLongId("invalid");
    fail("无效输入应抛出异常");
} catch (IllegalArgumentException e) {
    assertEquals("Invalid id: invalid", e.getMessage());
}
```

## 常见问题

### Q1: 测试编译失败，找不到符号

**原因**: 源代码中缺少方法或类

**解决**: 检查并补全源代码中的方法，例如：
- Result类缺少getCode()、getMsg()、getData()等方法
- 确保工具类已实现

### Q2: 测试运行报错：NotAMockException

**原因**: 尝试Mock了被测试的类本身

**解决**: 移除对 `@InjectMocks` 对象的when()调用

### Q3: 测试数据不清洁

**原因**: 测试之间存在数据依赖

**解决**: 在 `@Before` 方法中初始化测试数据，确保每个测试独立

### Q4: 数据库连接错误

**原因**: 单元测试不需要数据库，但某些集成场景需要

**解决**: 使用 `@Mock` 模拟Mapper层，避免真实数据库连接

## 测试执行示例

完整测试输出示例：

```
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.wangziyang.mes.basedata.MaterialInfoServiceUnitTest
[INFO] Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.common.CommonUnitTest
[INFO] Tests run: 11, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.entity.EntityUnitTest
[INFO] Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.production.DispatchOrderUnitTest
[INFO] Tests run: 7, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.system.SysRoleServiceUnitTest
[INFO] Tests run: 6, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.system.SysUserServiceUnitTest
[INFO] Tests run: 7, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.util.HttpUtilUnitTest
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.util.TreeUtilUnitTest
[INFO] Tests run: 7, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.wangziyang.mes.util.UtilUnitTest
[INFO] Tests run: 14, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 66, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] BUILD SUCCESS
```

## 后续扩展

### 集成测试路线图

未来计划添加集成测试：

1. **Controller层测试**: 使用 `@WebMvcTest` 测试REST API
2. **数据库集成测试**: 使用 `@DataJpaTest` 或 Testcontainers
3. **端到端测试**: 使用 `@SpringBootTest` + MockMvc 进行完整业务流程测试

### 测试覆盖率目标

- 当前单元测试覆盖率: ~40%
- 目标单元测试覆盖率: 70%+
- 集成测试覆盖率: 50%+

---

**文档版本**: 1.0  
**更新日期**: 2026-06-07  
**维护者**: MES开发团队
