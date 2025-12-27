import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'data/database/app_database.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация базы данных
  await AppDatabase.init();
  
  // Блокируем поворот экрана
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Подготовка к ЕГЭ',
      theme: AppTheme.theme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}