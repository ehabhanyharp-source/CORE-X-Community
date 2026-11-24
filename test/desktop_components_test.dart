import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_x_community/core_x_community.dart';

void main() {
  testWidgets('grid adjusts tile width to constraints', (tester) async {
    const key = Key('tile');
    await tester.pumpWidget(const Directionality(textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 500, child: ResponsiveTileGrid(
        minTileWidth: 200, spacing: 12, children: [
          SizedBox(key: key, height: 40), SizedBox(height: 40),
        ],
      )))));
    expect(tester.getSize(find.byKey(key)).width, 244);
  });

  testWidgets('local shortcut invokes callback when focused', (tester) async {
    var count = 0;
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr,
      child: DesktopKeyboardScope(autofocus: true,
        bindings: {const SingleActivator(LogicalKeyboardKey.keyK): () => count++},
        child: const Text('Keyboard sample'))));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    expect(count, 1);
  });

  testWidgets('reduced motion does not retain old child', (tester) async {
    Widget app(String value) => Directionality(textDirection: TextDirection.ltr,
      child: MediaQuery(data: const MediaQueryData(disableAnimations: true),
        child: MotionSwap(child: Text(value, key: ValueKey(value)))));
    await tester.pumpWidget(app('Before'));
    await tester.pumpWidget(app('After'));
    expect(find.text('Before'), findsNothing);
    expect(find.text('After'), findsOneWidget);
  });
}
