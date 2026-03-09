import 'package:flutter/material.dart';

class WallHomePage extends StatelessWidget {
  const WallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final card = Theme.of(context).cardColor;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('感恩墙'), Text('光荣故事会')],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      [Colors.blue, Colors.amber, Colors.red][i].withOpacity(0.7),
                      [Colors.indigo, Colors.orange, Colors.red.shade900][i],
                    ]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(hintText: '输入用户ID搜索')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _InfoCard(title: '连续留言', value: '0天', card: card)),
              const SizedBox(width: 8),
              Expanded(child: _InfoCard(title: '用户ID', value: '324544216', card: card)),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⭐ 最新发布', style: TextStyle(fontSize: 26)),
                  SizedBox(height: 8),
                  Text('这是用于设计还原阶段的静态占位内容，后续接入真实接口和OpenIM事件流。'),
                  SizedBox(height: 12),
                  Placeholder(fallbackHeight: 160),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value, required this.card});

  final String title;
  final String value;
  final Color card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: card),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        ],
      ),
    );
  }
}
