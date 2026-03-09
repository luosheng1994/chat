import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: '手机号')),
            Row(
              children: [
                const Expanded(
                  child: TextField(decoration: InputDecoration(labelText: '短信验证码')),
                ),
                const SizedBox(width: 12),
                FilledButton(onPressed: () {}, child: const Text('发送验证码')),
              ],
            ),
            TextField(decoration: const InputDecoration(labelText: '邀请码')),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text('提交注册'))
          ],
        ),
      ),
    );
  }
}
