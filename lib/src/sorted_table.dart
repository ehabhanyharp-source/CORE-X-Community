import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

/// A column definition for a small, bounded in-memory table.
class ToolkitColumn<T> {
  const ToolkitColumn({required this.label, required this.cell,
    this.compare, this.flex = 1}) : assert(flex > 0);
  final String label;
  final Widget Function(BuildContext, T) cell;
  final Comparator<T>? compare;
  final int flex;
}

/// Returns a sorted copy, preserving input order when values compare equal.
List<T> stableSortedRows<T>(Iterable<T> rows, Comparator<T> compare,
    {bool ascending = true}) {
  final values = rows.toList();
  final indexes = List<int>.generate(values.length, (i) => i);
  indexes.sort((a, b) {
    final order = ascending ? compare(values[a], values[b])
        : compare(values[b], values[a]);
    return order == 0 ? a.compareTo(b) : order;
  });
  return [for (final index in indexes) values[index]];
}

/// Controlled sort state; rows are built lazily. Place in a bounded box.
/// Header activation is delegated to the host through [onSort].
class ToolkitTable<T> extends StatelessWidget {
  const ToolkitTable({super.key, required this.rows, required this.columns,
    this.sortColumn, this.ascending = true, this.onSort,
    this.rowHeight = 48, this.headerHeight = 44, this.controller,
    this.empty = const Text('No rows')})
      : assert(rowHeight > 0), assert(headerHeight > 0);
  final List<T> rows;
  final List<ToolkitColumn<T>> columns;
  final int? sortColumn;
  final bool ascending;
  final void Function(int column, bool ascending)? onSort;
  final double rowHeight;
  final double headerHeight;
  final ScrollController? controller;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    if (columns.isEmpty) return empty;
    final index = sortColumn;
    final compare = index != null && index >= 0 && index < columns.length
        ? columns[index].compare : null;
    final ordered = compare == null ? rows
        : stableSortedRows(rows, compare, ascending: ascending);
    return Column(children: [
      SizedBox(height: headerHeight, child: Row(children: [
        for (var i = 0; i < columns.length; i++) Expanded(
          flex: columns[i].flex,
          child: _Header(label: columns[i].label,
            selected: i == index, ascending: ascending,
            activate: columns[i].compare != null && onSort != null
                ? () => onSort!(i, i == index ? !ascending : true) : null),
        ),
      ])),
      Expanded(child: ordered.isEmpty ? Center(child: empty) : ListView.builder(
        controller: controller, itemExtent: rowHeight, itemCount: ordered.length,
        itemBuilder: (context, i) => Row(children: [
          for (final column in columns) Expanded(flex: column.flex,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
              child: column.cell(context, ordered[i]))),
        ]),
      )),
    ]);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.label, required this.selected,
    required this.ascending, this.activate});
  final String label;
  final bool selected;
  final bool ascending;
  final VoidCallback? activate;
  @override
  Widget build(BuildContext context) {
    final text = Text(selected ? '$label ${ascending ? '↑' : '↓'}' : label,
      maxLines: 1, overflow: TextOverflow.ellipsis);
    final content = Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(alignment: AlignmentDirectional.centerStart, child: text));
    if (activate == null) return content;
    return Semantics(button: true, child: FocusableActionDetector(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
          activate!(); return null;
        }),
      },
      child: GestureDetector(behavior: HitTestBehavior.opaque,
        onTap: activate, child: content),
    ));
  }
}
