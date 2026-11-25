import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/storage/secure_storage_service.dart';
import 'package:flutter_template/core/storage/storage_providers.dart';
import 'package:flutter_template/core/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    EnvConfig.initialize(EnvConfig.dev());
  });

  testWidgets('应用完整启动、首页加载及进入设置页切换主题/语言冒烟测试', (WidgetTester tester) async {
    final InMemoryStorageService memoryStorage = InMemoryStorageService();
    final InMemorySecureStorageService memorySecureStorage =
        InMemorySecureStorageService();

    // 使用内存态存储注入 ProviderScope，实现零原生依赖的快速 Widget 测试
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          storageServiceProvider.overrideWithValue(memoryStorage),
          secureStorageServiceProvider.overrideWithValue(memorySecureStorage),
        ],
        child: const App(),
      ),
    );

    // 等待首页异步数据加载完成
    await tester.pumpAndSettle();

    // 验证首页核心内容已渲染
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.textContaining('DEV'), findsOneWidget);

    // 点击顶部设置按钮跳转至系统设置页
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // 验证设置页渲染了主题切换器与语言选项
    expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // 切换语言为 English，验证界面即时响应国际化变更
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}
