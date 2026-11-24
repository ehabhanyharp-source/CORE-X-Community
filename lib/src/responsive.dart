import 'package:flutter/widgets.dart';

/// Chooses a compact layout from local constraints.
class AdaptiveDensity extends StatelessWidget {
  final double compactBelowHeight;
  final double compactBelowWidth;
  final Widget Function(BuildContext context, bool compact) builder;

  const AdaptiveDensity({
    super.key,
    this.compactBelowHeight = 100,
    this.compactBelowWidth = 240,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < compactBelowHeight ||
            constraints.maxWidth < compactBelowWidth;
        return builder(context, compact);
      },
    );
  }
}

/// Fits a local fixed-size illustration into a bounded parent.
class DesignStage extends StatelessWidget {
  final double designWidth;
  final double designHeight;
  final Widget child;
  final Alignment alignment;

  const DesignStage({
    super.key,
    required this.designWidth,
    required this.designHeight,
    required this.child,
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: alignment,
        child: SizedBox(
          width: designWidth,
          height: designHeight,
          child: child,
        ),
      ),
    );
  }
}
