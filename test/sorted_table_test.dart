import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_x_community/core_x_community.dart';

void main() {
  test('sort is stable and does not mutate source', () {
    final rows = ['b1', 'a1', 'b2', 'a2'];
    int compare(String a, String b) => a[0].compareTo(b[0]);
    expect(stableSortedRows(rows, compare), ['a1', 'a2', 'b1', 'b2']);
    expect(stableSortedRows(rows, compare, ascending: false), ['b1', 'b2', 'a1', 'a2']);
    expect(rows, ['b1', 'a1', 'b2', 'a2']);
  });
  testWidgets('header requests sort and rows reflect controlled state', (tester) async {
    int? selected;
    var ascending = true;
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 350, height: 200,
        child: StatefulBuilder(builder: (context, setState) => ToolkitTable<int>(
          rows: const [3, 1, 2], sortColumn: selected, ascending: ascending,
          onSort: (i, a) => setState(() { selected = i; ascending = a; }),
          columns: [ToolkitColumn(label: 'Value', cell: (_, n) => Text('$n'),
            compare: (a, b) => a.compareTo(b))],
        )),
      ))));
    await tester.tap(find.text('Value'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('1')).dy, lessThan(tester.getTopLeft(find.text('3')).dy));
    await tester.tap(find.text('Value ↑'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('3')).dy, lessThan(tester.getTopLeft(find.text('1')).dy));
  });
  testWidgets('empty state is rendered', (tester) async {
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 200, height: 120, child: ToolkitTable<int>(
        rows: const [], columns: [ToolkitColumn(label: 'Value', cell: (_, n) => Text('$n'))],
      )))));
    expect(find.text('No rows'), findsOneWidget);
  });
}
