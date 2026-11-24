import 'dart:async';

import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/widgets.dart';

/// Animates pointer-scroll signals without replacing Flutter's drag behavior.
///
/// Rapid signals accumulate against the pending destination rather than the
/// current animated offset. Set [enabled] to false or [duration] to zero to
/// retain native pointer scrolling. Use a non-overshooting [curve].
class GlideScrollController extends ScrollController {
  GlideScrollController({
    this.duration = const Duration(milliseconds: 115),
    this.curve = Curves.easeOutCubic,
    this.enabled = true,
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
    super.onAttach,
    super.onDetach,
  }) : assert(!duration.isNegative);

  final Duration duration;
  final Curve curve;
  final bool enabled;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _GlideScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel,
      wheelDuration: enabled ? duration : Duration.zero,
      wheelCurve: curve,
    );
  }
}

class _GlideScrollPosition extends ScrollPositionWithSingleContext {
  _GlideScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    super.initialPixels,
    super.keepScrollOffset,
    super.debugLabel,
    required this.wheelDuration,
    required this.wheelCurve,
  });

  final Duration wheelDuration;
  final Curve wheelCurve;
  double? _wheelTarget;
  bool _startingWheel = false;

  @override
  void pointerScroll(double delta) {
    if (!delta.isFinite) return;
    if (!hasPixels || !hasContentDimensions) return;

    final reducedMotion =
        MediaQuery.maybeOf(context.storageContext)?.disableAnimations ?? false;
    if (delta == 0 || wheelDuration <= Duration.zero || reducedMotion) {
      _wheelTarget = null;
      super.pointerScroll(delta);
      return;
    }

    // Accumulate rapid input against the outstanding destination.
    final target = ((_wheelTarget ?? pixels) + delta)
        .clamp(minScrollExtent, maxScrollExtent)
        .toDouble();
    if (target == _wheelTarget) return;

    // A reversal may land exactly on the current offset. Cancel the old
    // animation even when no further movement is necessary.
    if ((target - pixels).abs() < physics.toleranceFor(this).distance ||
        target == pixels) {
      _wheelTarget = null;
      super.pointerScroll(target - pixels);
      return;
    }

    _wheelTarget = target;
    _startingWheel = true;
    try {
      unawaited(super.animateTo(
        target,
        duration: wheelDuration,
        curve: wheelCurve,
      ));
      updateUserScrollDirection(
        delta < 0 ? ScrollDirection.forward : ScrollDirection.reverse,
      );
    } finally {
      _startingWheel = false;
    }
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    // Clear pending destinations when a drag, external animation, jump,
    // ballistic activity or idle activity takes ownership of the position.
    if (!_startingWheel && newActivity != null) _wheelTarget = null;
    super.beginActivity(newActivity);
  }

  @override
  void dispose() {
    _wheelTarget = null;
    super.dispose();
  }
}
