import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';

class AnimationHelper {
  // Fade animations
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return child.animate(delay: delay).fadeIn(
      duration: duration ?? AppConstants.fadeAnimationDuration,
      curve: curve,
    );
  }

  static Widget fadeOut({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.easeInOut,
  }) {
    return child.animate(delay: delay).fadeOut(
      duration: duration ?? AppConstants.fadeAnimationDuration,
      curve: curve,
    );
  }

  // Scale animations
  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.elasticOut,
  }) {
    return child.animate(delay: delay).scale(
      duration: duration ?? AppConstants.bounceAnimationDuration,
      begin: Offset(begin, begin),
      end: Offset(end, end),
      curve: curve,
    );
  }

  static Widget pulse({
    required Widget child,
    Duration? duration,
    double scale = 1.1,
    int iterations = 1,
  }) {
    return child.animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      duration: duration ?? const Duration(milliseconds: 800),
      begin: const Offset(1.0, 1.0),
      end: Offset(scale, scale),
      curve: Curves.easeInOut,
    ).then().scale(
      duration: duration ?? const Duration(milliseconds: 800),
      begin: Offset(scale, scale),
      end: const Offset(1.0, 1.0),
      curve: Curves.easeInOut,
    );
  }

  // Slide animations
  static Widget slideInFromLeft({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double distance = 100.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return child.animate(delay: delay).slideX(
      duration: duration ?? AppConstants.slideAnimationDuration,
      begin: -distance,
      end: 0,
      curve: curve,
    );
  }

  static Widget slideInFromRight({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double distance = 100.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return child.animate(delay: delay).slideX(
      duration: duration ?? AppConstants.slideAnimationDuration,
      begin: distance,
      end: 0,
      curve: curve,
    );
  }

  static Widget slideInFromTop({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double distance = 100.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return child.animate(delay: delay).slideY(
      duration: duration ?? AppConstants.slideAnimationDuration,
      begin: -distance,
      end: 0,
      curve: curve,
    );
  }

  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double distance = 100.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return child.animate(delay: delay).slideY(
      duration: duration ?? AppConstants.slideAnimationDuration,
      begin: distance,
      end: 0,
      curve: curve,
    );
  }

  // Bounce animation
  static Widget bounceIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve curve = Curves.bounceOut,
  }) {
    return child.animate(delay: delay).scale(
      duration: duration ?? AppConstants.bounceAnimationDuration,
      begin: const Offset(0.3, 0.3),
      end: const Offset(1.0, 1.0),
      curve: curve,
    );
  }

  // Shake animation
  static Widget shake({
    required Widget child,
    Duration? duration,
    double distance = 10.0,
    int count = 3,
  }) {
    return child.animate().shake(
      duration: duration ?? const Duration(milliseconds: 500),
      hz: count.toDouble(),
      offset: Offset(distance, 0),
    );
  }

  // Combined animations
  static Widget fadeInAndSlideUp({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double distance = 50.0,
  }) {
    final animationDuration = duration ?? AppConstants.slideAnimationDuration;
    return child
        .animate(delay: delay)
        .fadeIn(duration: animationDuration)
        .slideY(
          duration: animationDuration,
          begin: distance,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget fadeInAndScale({
    required Widget child,
    Duration? duration,
    Duration? delay,
    double beginScale = 0.8,
  }) {
    final animationDuration = duration ?? AppConstants.fadeAnimationDuration;
    return child
        .animate(delay: delay)
        .fadeIn(duration: animationDuration)
        .scale(
          duration: animationDuration,
          begin: Offset(beginScale, beginScale),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOutBack,
        );
  }

  // Success/Error feedback animations
  static Widget successFeedback({
    required Widget child,
    Color? color,
  }) {
    return child
        .animate()
        .scale(
          duration: const Duration(milliseconds: 200),
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.2, 1.2),
          curve: Curves.easeOut,
        )
        .then()
        .scale(
          duration: const Duration(milliseconds: 200),
          begin: const Offset(1.2, 1.2),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeIn,
        )
        .tint(
          duration: const Duration(milliseconds: 400),
          color: color ?? Colors.green,
        );
  }

  static Widget errorFeedback({
    required Widget child,
    Color? color,
  }) {
    return child
        .animate()
        .shake(
          duration: const Duration(milliseconds: 500),
          hz: 4,
          offset: const Offset(10, 0),
        )
        .tint(
          duration: const Duration(milliseconds: 400),
          color: color ?? Colors.red,
        );
  }

  // Staggered list animations
  static Widget staggeredList({
    required List<Widget> children,
    Duration? duration,
    Duration? stagger,
    Axis direction = Axis.vertical,
  }) {
    final staggerDuration = stagger ?? const Duration(milliseconds: 100);
    final animationDuration = duration ?? AppConstants.slideAnimationDuration;
    
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return child.animate(
          delay: staggerDuration * index,
        ).fadeIn(
          duration: animationDuration,
        ).slideY(
          duration: animationDuration,
          begin: direction == Axis.vertical ? 30 : 0,
          end: 0,
        ).slideX(
          duration: animationDuration,
          begin: direction == Axis.horizontal ? 30 : 0,
          end: 0,
        );
      }).toList(),
    );
  }
}
