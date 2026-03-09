import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('发现')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.qr_code_scanner), title: Text('扫一扫')),
          ListTile(leading: CircleAvatar(), title: Text('留言墙')),
          ListTile(leading: CircleAvatar(), title: Text('小课堂')),
          ListTile(leading: CircleAvatar(), title: Text('爱心奖池')),
          ListTile(leading: CircleAvatar(), title: Text('两重建设')),
        ],
      ),
    );
  }
}
