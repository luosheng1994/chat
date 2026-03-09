import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('聊天'), actions: const [Icon(Icons.search), SizedBox(width: 12), Icon(Icons.add)]),
      body: ListView(
        children: const [
          ListTile(leading: CircleAvatar(), title: Text('两重建设官方群823'), subtitle: Text('赵阿芳 加入了群聊'), trailing: Text('PM 4:31')),
          ListTile(leading: CircleAvatar(), title: Text('两重建设服务号'), subtitle: Text('【两会政策发布｜两重建设持续推进】')),
        ],
      ),
    );
  }
}
