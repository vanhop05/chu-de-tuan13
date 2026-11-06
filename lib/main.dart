import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChuDeTuan13App());
}

class ChuDeTuan13App extends StatelessWidget {
  const ChuDeTuan13App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chủ Đề 6 - Biểu Mẫu & Kiểm Tra Dữ Liệu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeNavigationScreen(),
    );
  }
}
