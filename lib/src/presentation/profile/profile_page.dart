import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 12),
        ListTile(title: Text('账号信息')),
        ListTile(title: Text('8618063017287'), subtitle: Text('手机号')),
        ListTile(title: Text('@u18063017287'), subtitle: Text('用户名')),
        Divider(),
        ListTile(title: Text('我的钱包')),
        ListTile(title: Text('签到')),
        ListTile(title: Text('收藏夹')),
        ListTile(title: Text('隐私和安全')),
        ListTile(title: Text('通知和声音')),
        ListTile(title: Text('外观')),
      ],
    );
  }
}
