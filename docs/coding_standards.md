# 代码规范与团队协作规范

为保障多人协作下的代码一致性、可维护性与可审查性，所有合入主干的代码必须遵守本规范并通过 `flutter analyze` 与 `flutter test` 门禁。

---

## 1. 命名规范

| 类别 | 规范风格 | 正确示例 | 错误示例 |
| :--- | :--- | :--- | :--- |
| 文件与目录名 | 小写蛇形命名（`snake_case`） | `home_page.dart`, `app_exception.dart` | `HomePage.dart`, `appException.dart` |
| 类、枚举、Typedef、Extension | 大驼峰（`UpperCamelCase`） | `DioClient`, `AppOverviewEntity`, `BuildContextX` | `dioClient`, `app_overview` |
| 变量、方法、参数、命名常量 | 小驼峰（`lowerCamelCase`） | `connectTimeout`, `getAccessToken()` | `CONNECT_TIMEOUT`, `GetToken()` |
| 私有成员 | 下划线前缀 + 小驼峰 | `_dioClient`, `_loadOverview()` | `mDioClient` |
| Provider 变量名 | 语义名 + `Provider` 后缀 | `themeControllerProvider`, `homeRepositoryProvider` | `themeCtrl`, `homeRepo` |
| 页面 Widget 类名 | 语义名 + `Page` 后缀 | `HomePage`, `SettingsPage`, `OrderDetailPage` | `HomeScreenView`, `PageHome` |

---

## 2. 中文注释规范

本项目统一使用**中文注释**，遵循“解释为什么（Why），而非复述代码字面意思（What）”的原则：

1. **对外暴露的类、接口、Provider、公开方法与关键字段**：必须使用 Dartdoc 三斜杠注释 `///`，清晰说明职责、参数约束及典型用法。
2. **复杂业务逻辑与边界条件**：使用双斜杠 `//` 解释背后的业务规则或防坑原因（如为什么使用 `MediaQuery.sizeOf` 而非 `MediaQuery.of`）。
3. **待办标记（TODO）**：必须采用标准格式 `// TODO(责任人或模块): 具体待办事项`，严禁写模糊的 `// todo fix`。

---

## 3. Dart & Flutter 编码最佳实践

### 3.1 导入规范
- 强制使用 `package:flutter_template/...` 绝对包导入（已由 `always_use_package_imports` 规则强制约束），禁止使用 `../../../` 相对导入。
- 导入分组顺序：Dart SDK -> Flutter/第三方包 -> 本项目包（按字母序排列）。

### 3.2 类型安全与不可变性
- 禁止在业务代码中滥用 `dynamic`，必须显式声明函数返回类型与泛型参数。
- 优先使用 `final` 声明局部变量与字段，优先使用 `const` 构造函数以减少 Widget 重建开销。
- 多行参数列表务必保留尾部逗号（`require_trailing_commas`），配合 `dart format .` 自动排版。

### 3.3 Widget 拆分原则
- 单个 `build()` 方法尽量控制在 **80 行以内**；超过时优先拆分为独立的私有 `StatelessWidget`（如 `_HomeContent`、`_InfoRow`），而不是返回 `Widget` 的辅助函数（独立 Widget 具备独立的 Element 与 `const` 优化能力）。
- 禁止在 `build()` 中直接发起网络请求、读写磁盘或创建新的 `TextEditingController` / `ScrollController`。
- 使用 `ref.watch` 仅监听当前 Widget 真正依赖的最小状态切片（必要时使用 `.select(...)` 精准订阅）。

### 3.4 异步与生命周期安全
- 在 `await` 之后使用 `BuildContext`（如弹出 SnackBar 或导航跳转）前，必须先检查 `if (!context.mounted) return;`。
- 所有 `StreamSubscription`、`Timer`、`Debouncer`、`FocusNode`、`TextEditingController` 必须在 `dispose()` 中及时释放。
- 禁止吞掉异常（空 `catch {}` 已被 Lint 禁止）；业务层统一通过 `Result<T>` 或 `AsyncValue` 显式处理错误。

### 3.5 日志与硬编码红线
- 严禁提交 `print()`，统一使用 `AppLogger.d/i/w/e(...)`。
- 严禁在业务页面硬编码以下内容：
  - 接口 URL -> 统一收口到 `ApiEndpoints`
  - 本地存储 Key -> 统一收口到 `StorageKeys`
  - 路由路径 -> 统一收口到 `RoutePaths` / `RouteNames`
  - 品牌颜色与间距 -> 统一使用 `context.colorScheme`、`AppColors`、`AppSpacing`
  - 面向用户的展示文案 -> 统一维护在 `lib/l10n/app_*.arb`，通过 `context.l10n` 引用

---

## 4. Git 提交规范（Conventional Commits）

推荐采用标准语义化提交格式：`<type>(<scope>): <中文简要说明>`

| Type | 说明 | 示例 |
| :--- | :--- | :--- |
| `feat` | 新增业务功能或架构能力 | `feat(auth): 新增手机号验证码登录流程` |
| `fix` | 修复缺陷 | `fix(network): 修复 401 响应后未清理本地 Token 的问题` |
| `refactor` | 代码重构（不改变外部行为） | `refactor(home): 拆分首页概览卡片组件` |
| `style` | 格式调整、注释完善（不影响逻辑） | `style(theme): 统一按钮圆角常量` |
| `docs` | 文档新增或更新 | `docs(arch): 补充网络层拦截器时序说明` |
| `test` | 新增或修复自动化测试 | `test(utils): 补充表单校验器单元测试` |
| `chore` | 构建脚本、依赖升级、工程配置 | `chore(deps): 升级 dio 至 5.x 最新兼容版本` |

---

## 5. 合入前自检清单（PR Checklist）

提交 Merge Request / Pull Request 前请确认：
- [ ] 已执行 `dart format .` 完成代码格式化
- [ ] 已执行 `flutter analyze` 且输出 **No issues found!**
- [ ] 已执行 `flutter test` 且所有测试用例全部通过
- [ ] 新增文案已同时补充中英文 ARB 文件并运行 `flutter gen-l10n`
- [ ] 无遗留调试代码、硬编码测试账号或明文敏感信息
