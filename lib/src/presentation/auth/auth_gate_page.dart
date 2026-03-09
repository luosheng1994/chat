import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_controller.dart';
import '../shell/main_shell_page.dart';
import 'login_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthController>().isLoggedIn;
    return isLoggedIn ? const MainShellPage() : const LoginPage();
  }
}
