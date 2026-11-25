# Flutter 企业级标准开发空项目框架

一套开箱即用、面向中大型团队协作与长期演进的 **Flutter 企业级空项目模板**。采用 **Feature-First + Clean Architecture** 分层架构，内置状态管理、声明式路由、企业级网络封装、多环境配置、国际化、深浅色主题、统一异常处理与自动化测试骨架，全部核心代码均配备详尽的中文注释与配套工程文档。

---

## 核心特性一览

| 能力领域 | 选型方案 | 说明 |
| :--- | :--- | :--- |
| **架构模式** | Feature-First + Clean Architecture | 按业务域切分模块，模块内部遵循 `data / domain / presentation` 严格分层 |
| **状态管理 & DI** | `flutter_riverpod` | 编译安全、零 `BuildContext` 强耦合、天然易测、内置全局状态变更日志监听 |
| **路由导航** | `go_router` | 声明式路由、支持 Deep Link、集中式路由常量、预留认证重定向守卫与 404 兜底 |
| **网络通信** | `dio` + 拦截器体系 | 统一 `ApiResponse<T>` 解包、`Result<T>` 返回、Token 注入与 401 处理、敏感头脱敏日志、异常标准化 |
| **本地持久化** | `shared_preferences` + `flutter_secure_storage` | 面向接口编程（DIP），普通配置与敏感凭据分离存储，内置内存态实现支持无原生依赖单测 |
| **多环境管理** | `EnvConfig` + 多入口 / `--dart-define` | 支持 `dev / staging / prod` 隔离配置，支持 CI/CD 动态覆盖 `API_BASE_URL` |
| **主题与设计系统** | Material 3 (`AppTheme` + `AppColors` + `AppSpacing`) | 统一设计规范，支持浅色 / 深色 / 跟随系统动态切换并持久化 |
| **国际化（i18n）** | Flutter 官方 `gen-l10n` + ARB | 内置简体中文 & English 双语词条，支持应用内即时切换与持久化 |
| **异常与日志** | `GlobalErrorHandler` + `AppLogger` | 三层未捕获异常兜底、Release 友好防红屏界面、按环境自动过滤日志级别 |
| **代码质量门禁** | 严格 `analysis_options.yaml` | 启用 `strict-casts` / `strict-inference` / `strict-raw-types` 与企业级 Lint 规则 |

---

## 环境要求

- **Flutter SDK**: `>= 3.22.0`（当前验证版本 `Flutter 3.22.3`）
- **Dart SDK**: `>= 3.4.4 < 4.0.0`
- **推荐 IDE**: Android Studio / VS Code（安装 Flutter & Dart 插件）

> **Windows 开发者提示**：若需要编译运行 Windows 桌面端（含原生插件符号链接），请先在系统设置中开启 **开发者模式**（可在终端执行 `start ms-settings:developers`）。开发 Android / iOS / Web 及运行 `flutter test`、`flutter analyze` 不受影响。

---

## 快速开始

### 1. 拉取依赖与生成国际化代码

```bash
flutter pub get
flutter gen-l10n
```

### 2. 多环境运行

方式一：通过专用入口文件启动（推荐在 IDE Run Configurations 中分别配置）：

```bash
# 开发环境
flutter run -t lib/main_dev.dart

# 预发布 / 测试环境
flutter run -t lib/main_staging.dart

# 生产环境
flutter run -t lib/main_prod.dart
```

方式二：通过 `--dart-define` 参数动态指定环境或临时覆盖后端地址：

```bash
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=dev --dart-define=API_BASE_URL=http://192.168.1.100:8080/v1
```

### 3. 静态分析与自动化测试

```bash
# 代码静态检查（需 0 error / 0 warning）
flutter analyze

# 运行全部单元测试与 Widget 测试
flutter test
```

### 4. 多环境打包构建

```bash
# Android 生产环境 APK / AppBundle
flutter build apk -t lib/main_prod.dart --release
flutter build appbundle -t lib/main_prod.dart --release

# iOS 生产环境 IPA
flutter build ipa -t lib/main_prod.dart --release
```

---

## 目录结构说明

```text
flutter_template/
├── assets/                          # 静态资源目录（图片、图标、字体）
├── docs/                            # 企业级开发配套文档
│   ├── architecture.md              # 架构设计与分层规范
│   ├── coding_standards.md          # 代码风格、命名规范与 Git 规范
│   └── development_guide.md         # 业务模块开发 SOP 实战指南
├── lib/
│   ├── main.dart                    # 默认入口（支持 --dart-define=ENV）
│   ├── main_dev.dart                # 开发环境入口
│   ├── main_staging.dart            # 预发布环境入口
│   ├── main_prod.dart               # 生产环境入口
│   ├── bootstrap.dart               # 应用启动引导（异常兜底、依赖预热）
│   ├── app.dart                     # 顶层 App 组件（主题、语言、路由）
│   ├── core/                        # 核心基础设施层（与具体业务无关）
│   │   ├── config/                  # 多环境配置
│   │   ├── constants/               # 全局常量与存储 Key
│   │   ├── error/                   # 统一异常体系、Result<T>、全局异常捕获
│   │   ├── extensions/              # BuildContext / String 等扩展
│   │   ├── logger/                  # 日志工具与 Riverpod 状态监听
│   │   ├── network/                 # Dio 客户端、拦截器、统一响应协议
│   │   ├── router/                  # GoRouter 配置、路由常量、404 页面
│   │   ├── storage/                 # 普通 KV 存储与敏感加密存储
│   │   ├── theme/                   # 设计系统（色板、间距、字号、主题控制）
│   │   └── utils/                   # 防抖/节流、表单校验器等通用工具
│   ├── l10n/                        # 国际化 ARB 文件与语言控制器
│   ├── shared/                      # 跨业务共享 UI 组件（Loading/Empty/Error/Scaffold）
│   └── features/                    # 业务功能模块（按业务域划分）
│       ├── home/                    # 示例业务模块（完整 data/domain/presentation 示范）
│       └── settings/                # 系统设置模块（主题与语言切换）
├── test/                            # 镜像 lib/ 结构的单元测试与 Widget 测试
├── .editorconfig                    # 跨平台编辑器代码格式统一配置
├── analysis_options.yaml            # 严格静态分析配置
├── l10n.yaml                        # Flutter 官方国际化生成配置
└── pubspec.yaml                     # 项目依赖与资源声明
```

---

## 基于本模板创建新项目（5 步初始化清单）

克隆或复制本仓库开启新业务项目时，按顺序完成以下 5 步即可进入正式开发：

1. **修改项目名称与原生包名**
   - 修改 `pubspec.yaml` 中的 `name` 与 `description`，并全局替换代码中的 `package:flutter_template/` 导入前缀；
   - 修改 Android 的 `applicationId`（`android/app/build.gradle`）与 `android:label`（`AndroidManifest.xml`），以及 iOS 的 `PRODUCT_BUNDLE_IDENTIFIER` 与 `CFBundleDisplayName`（`ios/Runner/Info.plist`）。
2. **配置后端环境地址与响应协议**
   - 在 `lib/core/config/env_config.dart` 中填入真实的 `dev / staging / prod` 接口 `apiBaseUrl` 与应用名称；
   - 根据团队后端约定调整 `lib/core/network/api_response.dart` 中的成功状态码与外层字段名（如 `code / message / data`）。
3. **替换为目标项目视觉规范**
   - 在 `lib/core/theme/app_colors.dart` 替换品牌主色 `primary` 与辅色 `secondary`；
   - 如需自定义字体或图标，放入 `assets/` 并在 `pubspec.yaml` 中声明。
4. **更新应用名称与多语言默认文案**
   - 编辑 `lib/l10n/app_zh.arb` 与 `lib/l10n/app_en.arb` 中的 `appTitle` 等基础词条，随后运行 `flutter gen-l10n`。
5. **替换示例业务模块并执行门禁校验**
   - 保留 `lib/features/home/` 的分层骨架，将演示数据替换为真实首页业务接口，或参考 [业务开发实战指南](docs/development_guide.md) 新增业务模块；
   - 运行 `flutter pub get && flutter analyze && flutter test`，确认全绿后提交初始 Commit。

---

## 详细文档导航

新成员接入项目前，请务必按顺序阅读以下工程文档：

1. [架构设计文档 (`docs/architecture.md`)](docs/architecture.md)：理解目录分层、依赖方向约束、状态管理范式与错误处理链路。
2. [代码规范与协作规范 (`docs/coding_standards.md`)](docs/coding_standards.md)：统一团队命名、注释、Widget 拆分、Lint 及 Git Commit 规范。
3. [业务开发实战指南 (`docs/development_guide.md`)](docs/development_guide.md)：手把手 SOP，涵盖新增业务模块、对接接口、注册路由、添加多语言词条与编写单元测试。
