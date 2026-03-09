import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('联系人'), actions: const [Icon(Icons.search)]),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.person_add_alt), title: Text('新的朋友')),
          ListTile(leading: Icon(Icons.groups_outlined), title: Text('我的群组')),
          Divider(),
          ListTile(
            leading: CircleAvatar(),
            title: Text('两重建设客服-芳芳'),
            subtitle: Text('最后上线于 PM 4:30'),
          ),
        ],
      ),
    );
  }
}
