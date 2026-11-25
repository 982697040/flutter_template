# 业务开发实战指南（SOP）

本文档以标准作业流程（SOP）的形式，演示如何基于本框架高效、规范地完成日常研发任务。

---

## 1. 新增一个业务模块（以 `profile` 个人中心为例）

推荐严格遵循与 `lib/features/home/` 一致的目录结构：

```text
lib/features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_remote_datasource.dart   # 调用 DioClient 请求接口
│   ├── models/
│   │   └── user_profile_model.dart          # JSON 序列化与 toEntity()
│   └── repositories/
│       └── profile_repository_impl.dart     # 实现 Domain 接口并做 Model -> Entity 转换
├── domain/
│   ├── entities/
│   │   └── user_profile_entity.dart         # 纯 Dart 业务实体
│   └── repositories/
│       └── profile_repository.dart          # 仓储抽象接口
└── presentation/
    ├── pages/
    │   └── profile_page.dart                # 页面主入口（ConsumerWidget）
    ├── widgets/                             # 仅本模块复用的私有子组件
    └── providers/
        └── profile_providers.dart           # Provider 装配与 AsyncNotifier 控制器
```

### 步骤清单
1. **定义实体与仓储接口（`domain/`）**：先与产品/后端对齐业务模型字段，写出不可变 `UserProfileEntity` 与 `abstract interface class ProfileRepository`。
2. **注册接口路径**：在 `lib/core/network/api_endpoints.dart` 中添加接口常量，例如 `static const String userProfile = '/user/profile';`。
3. **实现数据源与仓储（`data/`）**：
   - 在 `ProfileRemoteDataSourceImpl` 中调用 `_dioClient.get<UserProfileModel>(...)`；
   - 在 `ProfileRepositoryImpl` 中调用 `result.map((model) => model.toEntity())`。
4. **编排状态管理（`presentation/providers/`）**：
   - 注册 `profileRemoteDataSourceProvider`、`profileRepositoryProvider`；
   - 编写 `ProfileController extends AsyncNotifier<UserProfileEntity>`，通过 `result.getOrThrow()` 对接 `AsyncValue`。
5. **编写页面 UI（`presentation/pages/`）**：
   - 使用 `AppScaffold` 包装页面；
   - 使用 `state.when(loading: ..., error: ..., data: ...)` 配合 `AppLoadingView` 与 `AppErrorView` 处理全状态。

---

## 2. 接入真实后端网络接口

打开 `lib/core/network/dio_client.dart` 与 `api_response.dart`，检查并按需适配你们团队的后端协议：

1. **修改默认环境域名**：编辑 `lib/core/config/env_config.dart` 中的 `dev / staging / prod` 对应的 `apiBaseUrl`。
2. **适配统一外层响应结构**：若后端成功状态码不是 `0 / 200`，或字段名为 `errCode / errMsg / result`，只需修改 `lib/core/network/api_response.dart` 一处即可全局生效。
3. **发起不需要鉴权的公开接口请求**（如登录、注册、获取验证码）：

```dart
final Result<LoginModel> result = await _dioClient.post<LoginModel>(
  ApiEndpoints.login,
  data: <String, dynamic>{
    'phone': phone,
    'password': password,
  },
  options: Options(
    extra: const <String, dynamic>{'requiresAuth': false},
  ),
  parser: (Object? json) => LoginModel.fromJson(json! as Map<String, dynamic>),
);
```

4. **处理 401 未授权自动跳转登录页**：在 `lib/core/network/network_providers.dart` 的 `onUnauthorized` 回调中触发全局认证状态清空，并配合 `GoRouter` 的 `redirect` 自动重定向至登录页。

---

## 3. 注册新页面路由与登录守卫

1. 在 `lib/core/router/route_paths.dart` 中登记路径与路由名：
   ```dart
   static const String profile = '/profile';
   ```
2. 在 `lib/core/router/app_router.dart` 的 `routes` 列表中注册 `GoRoute`：
   ```dart
   GoRoute(
     path: RoutePaths.profile,
     name: RouteNames.profile,
     builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
   ),
   ```
3. 在页面中进行跳转：
   - 压栈跳转（可返回）：`context.push(RoutePaths.profile)` 或 `context.pushNamed(RouteNames.profile)`
   - 替换路由栈（如登录成功进首页）：`context.go(RoutePaths.home)`
4. 如需底部导航栏多 Tab 保持状态，可在 `app_router.dart` 中使用 GoRouter 官方的 `StatefulShellRoute.indexedStack`。

---

## 4. 新增多语言（国际化）词条

1. 同时编辑模板文件 `lib/l10n/app_zh.arb` 与英文文件 `lib/l10n/app_en.arb`，新增相同的 Key：
   ```json
   "profileTitle": "个人中心"
   ```
2. 在项目根目录执行代码生成命令：
   ```bash
   flutter gen-l10n
   ```
3. 在任意页面通过扩展语法直接使用（具备完整 IDE 自动补全与编译期检查）：
   ```dart
   Text(context.l10n.profileTitle)
   ```
4. 若某语言漏翻了词条，`flutter gen-l10n` 会自动在项目根目录生成 `l10n_untranslated.txt` 提醒补充。

---

## 5. 添加静态图片与自定义字体

1. 将图片放入 `assets/images/`，图标放入 `assets/icons/`（目录已在 `pubspec.yaml` 中声明）。
2. 如需引入自定义字体，将 `.ttf` / `.otf` 放入 `assets/fonts/`，并在 `pubspec.yaml` 的 `fonts:` 节点取消注释并配置字体族名称，随后在 `AppTheme` 中设置 `fontFamily`。
3. 推荐在 `lib/core/constants/` 下新增 `app_assets.dart` 统一管理所有资源路径常量，避免字符串散落。

---

## 6. 编写高质量自动化测试

本项目已将存储与网络依赖全部抽象为接口，因此测试无需连接真实后端或真机平台通道：

### 单元测试（测试 `domain` / `data` / `core`）
- 放置于 `test/` 对应镜像目录，例如 `test/features/profile/profile_repository_test.dart`。
- 直接构造 Mock/Fake 实现注入被测类，断言 `Result.isSuccess` 与转换后的实体字段。

### Widget 集成测试（测试页面交互与状态联动）
- 使用 `ProviderScope(overrides: [...])` 注入 `InMemoryStorageService`、`InMemorySecureStorageService` 或 Fake Repository；
- 参考 `test/widget_test.dart`，验证加载态、成功渲染、点击交互与异常重试流程。

```bash
# 运行全部测试
flutter test

# 仅运行指定测试文件
flutter test test/core/error/result_test.dart

# 生成测试覆盖率报告（coverage/lcov.info）
flutter test --coverage
```
