import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_x_community/core_x_community.dart';

Future<void> mountList(
  WidgetTester tester,
  GlideScrollController controller, {
  bool reducedMotion = false,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reducedMotion),
      child: Scaffold(
        body: ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          itemCount: 100,
          itemExtent: 50,
          itemBuilder: (_, index) => Text('Item $index'),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });
}

void main() {
  testWidgets('animates one signal to its destination', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller);
    controller.position.pointerScroll(120);
    expect(controller.offset, closeTo(0, 0.01));
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(120, 0.01));
  });

  testWidgets('accumulates rapid signals', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller);
    controller.position.pointerScroll(100);
    controller.position.pointerScroll(80);
    controller.position.pointerScroll(40);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(220, 0.01));
  });

  testWidgets('reversal cancels outstanding travel', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller);
    controller.position.pointerScroll(200);
    controller.position.pointerScroll(-200);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(0, 0.01));
  });

  testWidgets('clamps to extents and scrolls away from edge', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller);
    final max = controller.position.maxScrollExtent;
    controller.position.pointerScroll(max + 1000);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(max, 0.01));
    controller.position.pointerScroll(-100);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(max - 100, 0.01));
  });

  testWidgets('jump clears pending wheel destination', (tester) async {
    final controller = GlideScrollController(initialScrollOffset: 50);
    await mountList(tester, controller);
    expect(controller.offset, closeTo(50, 0.01));
    controller.position.pointerScroll(300);
    controller.jumpTo(100);
    controller.position.pointerScroll(40);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(140, 0.01));
  });

  testWidgets('programmatic animation interrupts wheel input', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller);
    controller.position.pointerScroll(300);
    final animation = controller.animateTo(
      80,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
    await tester.pumpAndSettle();
    await animation;
    controller.position.pointerScroll(30);
    await tester.pumpAndSettle();
    expect(controller.offset, closeTo(110, 0.01));
  });

  testWidgets('disabled controller uses native pointer scrolling', (tester) async {
    final controller = GlideScrollController(enabled: false);
    await mountList(tester, controller);
    controller.position.pointerScroll(120);
    expect(controller.offset, closeTo(120, 0.01));
  });

  testWidgets('reduced motion uses native pointer scrolling', (tester) async {
    final controller = GlideScrollController();
    await mountList(tester, controller, reducedMotion: true);
    controller.position.pointerScroll(120);
    expect(controller.offset, closeTo(120, 0.01));
  });

  testWidgets('zero duration and invalid deltas are safe', (tester) async {
    final controller = GlideScrollController(duration: Duration.zero);
    await mountList(tester, controller);
    controller.position.pointerScroll(double.nan);
    controller.position.pointerScroll(double.infinity);
    expect(controller.offset, closeTo(0, 0.01));
    controller.position.pointerScroll(60);
    expect(controller.offset, closeTo(60, 0.01));
  });
}
