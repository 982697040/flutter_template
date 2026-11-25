import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/router/not_found_page.dart';
import 'package:flutter_template/core/router/route_paths.dart';
import 'package:flutter_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_template/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

/// 全局根导航器 Key，便于在无局部 BuildContext 时弹窗或导航
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);

/// 全局 [GoRouter] 路由配置 Provider
///
/// 统一维护所有页面路由、路由重定向守卫（如登录鉴权）及 404 兜底页面。
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>(
  (Ref ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RoutePaths.home,
      debugLogDiagnostics: EnvConfig.current.enableLog,
      // -----------------------------------------------------------------------
      // 全局路由守卫示例（接入认证模块后取消注释并注入 authStateProvider）：
      // redirect: (BuildContext context, GoRouterState state) {
      //   final bool isLoggedIn = ref.read(authStateProvider).isAuthenticated;
      //   final bool isGoingToLogin = state.matchedLocation == RoutePaths.login;
      //   if (!isLoggedIn && !isGoingToLogin) return RoutePaths.login;
      //   if (isLoggedIn && isGoingToLogin) return RoutePaths.home;
      //   return null;
      // },
      // -----------------------------------------------------------------------
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (BuildContext context, GoRouterState state) =>
              const SettingsPage(),
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) => NotFoundPage(
        location: state.uri.toString(),
      ),
    );
  },
  name: 'appRouterProvider',
);
