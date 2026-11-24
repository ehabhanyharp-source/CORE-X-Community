import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_x_community/core_x_community.dart';

void main() {
  for (final size in const [Size(180, 150), Size(400, 60), Size(400, 150)]) {
    testWidgets('density responds to $size', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Center(child: SizedBox(
        width: size.width, height: size.height,
        child: AdaptiveDensity(builder: (_, compact) => Text(compact ? 'compact' : 'regular')),
      ))));
      expect(find.text(size.width < 240 || size.height < 100 ? 'compact' : 'regular'), findsOneWidget);
    });
  }
  testWidgets('local stage retains child design dimensions', (tester) async {
    const key = Key('stage-child');
    await tester.pumpWidget(const MaterialApp(home: Center(child: SizedBox(
      width: 200, height: 100,
      child: DesignStage(designWidth: 400, designHeight: 200, child: ColoredBox(key: key, color: Colors.blue)),
    ))));
    expect(tester.getSize(find.byKey(key)), const Size(400, 200));
    expect(tester.takeException(), isNull);
  });
}
