import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_controller.dart';
import '../chat/chat_list_page.dart';
import '../contacts/contacts_page.dart';
import '../discover/discover_page.dart';
import '../profile/profile_page.dart';
import '../wall/wall_home_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int index = 0;

  final pages = const [
    WallHomePage(),
    ContactsPage(),
    ChatListPage(),
    DiscoverPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '留言墙'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '联系人'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: '聊天'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: '发现'),
          NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: '我的'),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const Placeholder()),
              ),
              backgroundColor: const Color(0xFFFF6B2C),
              child: const Icon(Icons.add),
            )
          : null,
      appBar: index == 4
          ? AppBar(
              title: const Text('调试操作'),
              actions: [
                IconButton(
                  onPressed: () {
                    final auth = context.read<AuthController>();
                    auth.setThemeMode(
                      auth.themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    );
                  },
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
                IconButton(
                  onPressed: () => context.read<AuthController>().logout(),
                  icon: const Icon(Icons.logout),
                ),
              ],
            )
          : null,
    );
  }
}
