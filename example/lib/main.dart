import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_x_community/core_x_community.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});
  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.blueGrey),
    darkTheme: ThemeData(colorSchemeSeed: Colors.blueGrey, brightness: Brightness.dark),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: DemoPage(onTheme: () => setState(() => dark = !dark)),
  );
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key, required this.onTheme});
  final VoidCallback onTheme;
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final controller = GlideScrollController();
  int? column;
  bool ascending = true;
  bool showTable = true;
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  void toggle() => setState(() => showTable = !showTable);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Community toolkit demo'), actions: [
      IconButton(onPressed: widget.onTheme, icon: const Icon(Icons.brightness_6), tooltip: 'Toggle theme'),
    ]),
    body: DesktopKeyboardScope(autofocus: true,
      bindings: {const SingleActivator(LogicalKeyboardKey.keyK, control: true): toggle},
      child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ResponsiveTileGrid(maxColumns: 3, children: [
          const Card(child: ListTile(title: Text('Responsive grid'), subtitle: Text('Resize the window'))),
          Card(child: ListTile(title: const Text('Keyboard'), subtitle: const Text('Ctrl+K'), onTap: toggle)),
          Card(child: ListTile(title: const Text('Motion'), subtitle: const Text('Switch demo'), onTap: toggle)),
        ]),
        const SizedBox(height: 12),
        MotionSwap(child: Text(showTable ? 'Table demonstration' : 'Motion demonstration', key: ValueKey(showTable))),
        Expanded(child: showTable
          ? ToolkitTable<int>(key: const ValueKey('table'), controller: controller,
              rows: List<int>.generate(100, (i) => i + 1), sortColumn: column,
              ascending: ascending, onSort: (i, a) => setState(() { column = i; ascending = a; }),
              columns: [
                ToolkitColumn(label: 'ID', cell: (_, n) => Text('$n'), compare: (a, b) => a.compareTo(b)),
                ToolkitColumn(label: 'Sample', flex: 3, cell: (_, n) => Text('Example item $n')),
              ])
          : const Center(key: ValueKey('motion'), child: Text('Motion demo — press Ctrl+K to return'))),
      ]))),
  );
}
