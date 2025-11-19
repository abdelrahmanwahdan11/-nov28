import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard.large({super.key}) : _height = 160, _width = double.infinity;
  const SkeletonCard.list({super.key}) : _height = 72, _width = double.infinity;

  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
        borderRadius: BorderRadius.circular(24),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(duration: 300.ms)
        .scale(begin: const Offset(1, 0.98), end: const Offset(1, 1))
        .tint(color: Colors.white.withOpacity(.1));
  }
}

class SkeletonChip extends StatelessWidget {
  const SkeletonChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
        borderRadius: BorderRadius.circular(18),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(duration: 250.ms)
        .tint(color: Colors.white.withOpacity(.08));
  }
}
