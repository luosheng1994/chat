import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: '用户名')),
            TextField(
              decoration: const InputDecoration(labelText: '密码'),
              obscureText: true,
            ),
            Row(
              children: [
                const Expanded(
                  child: TextField(decoration: InputDecoration(labelText: '图片验证码')),
                ),
                const SizedBox(width: 12),
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  height: 40,
                  color: Colors.grey.shade300,
                  child: const Text('验证码'),
                )
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.read<AuthController>().login(),
              child: const Text('登录'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              child: const Text('去注册'),
            ),
            OutlinedButton(
              onPressed: () => context.read<AuthController>().login(),
              child: const Text('免密体验进入'),
            )
          ],
        ),
      ),
    );
  }
}
