import 'package:flutter/material.dart';
import 'package:core_x_community/core_x_community.dart';

void main() => runApp(const MaterialApp(home: DemoPage()));

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final controller = GlideScrollController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CORE X Community — UI toolkit')),
    body: Column(children: [
      SizedBox(height: 110, child: AdaptiveDensity(
        builder: (_, compact) => Center(child: Text(compact ? 'Compact layout' : 'Regular layout')),
      )),
      const SizedBox(width: 240, height: 64, child: DesignStage(
        designWidth: 480, designHeight: 128,
        child: Center(child: Text('Local design stage', style: TextStyle(fontSize: 32))),
      )),
      Expanded(child: Scrollbar(controller: controller, child: ListView.builder(
        controller: controller, itemCount: 100,
        itemBuilder: (_, index) => ListTile(title: Text('Sample item ${index + 1}')),
      ))),
    ]),
  );
}
