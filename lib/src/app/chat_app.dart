import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/auth_controller.dart';
import '../presentation/auth/auth_gate_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: Consumer<AuthController>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'OpenIM Chat Clone',
            debugShowCheckedModeBanner: false,
            themeMode: auth.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xFF5D8BB1),
              scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: const Color(0xFF5D8BB1),
              scaffoldBackgroundColor: const Color(0xFF0E1623),
            ),
            home: const AuthGatePage(),
          );
        },
      ),
    );
  }
}
