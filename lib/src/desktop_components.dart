import 'package:flutter/widgets.dart';

/// A width-aware grid with bounded column count and no scroll ownership.
class ResponsiveTileGrid extends StatelessWidget {
  const ResponsiveTileGrid({super.key, required this.children,
    this.minTileWidth = 220, this.spacing = 12, this.maxColumns = 6})
      : assert(minTileWidth > 0), assert(spacing >= 0), assert(maxColumns > 0);
  final List<Widget> children;
  final double minTileWidth;
  final double spacing;
  final int maxColumns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (!constraints.hasBoundedWidth) {
        return Column(mainAxisSize: MainAxisSize.min, children: children);
      }
      final width = constraints.maxWidth;
      final columns = ((width + spacing) / (minTileWidth + spacing))
          .floor().clamp(1, maxColumns).toInt();
      final tileWidth = (width - (columns - 1) * spacing) / columns;
      return Wrap(spacing: spacing, runSpacing: spacing, children: [
        for (final child in children) SizedBox(width: tileWidth, child: child),
      ]);
    },
  );
}

/// Locally scoped keyboard navigation; focus is never captured automatically.
class DesktopKeyboardScope extends StatelessWidget {
  const DesktopKeyboardScope({super.key, required this.child,
    required this.bindings, this.autofocus = false});
  final Widget child;
  final Map<ShortcutActivator, VoidCallback> bindings;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: bindings,
    child: Focus(autofocus: autofocus, child: child),
  );
}

/// A cross-fade that respects the user's reduced-motion preference.
class MotionSwap extends StatelessWidget {
  const MotionSwap({super.key, required this.child,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOut});
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return child;
    return AnimatedSwitcher(duration: duration, switchInCurve: curve,
      switchOutCurve: curve, child: child);
  }
}
