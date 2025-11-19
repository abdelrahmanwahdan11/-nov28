import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).dashboardController;
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ValueListenableBuilder<bool>(
        valueListenable: controller.loading,
        builder: (_, loading, __) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Text(loc.translate('dashboard_title'),
                      style: theme.textTheme.headlineSmall),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(IconlyLight.calendar),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: controller.selectedDate.value,
                      );
                      if (date != null) controller.selectedDate.value = date;
                    },
                  ),
                ],
              ),
              if (loading) ...[
                const SkeletonCard.large(),
                const SkeletonCard.list(),
              ] else ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: CustomPaint(
                        painter: _RingPainter(
                          segments: controller.ringSegments.value,
                          primary: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text('8.4',
                            style: theme.textTheme.displayMedium),
                        Text('Balanced',
                            style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        const AiInfoButton(),
                      ],
                    ),
                  ],
                ).animate().fadeIn(),
                const SizedBox(height: 16),
                ...controller.ringSegments.value.map(
                  (vital) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(.15),
                      child: const Icon(IconlyLight.heart),
                    ),
                    title: Text(vital['type'].toString()),
                    subtitle: LinearProgressIndicator(
                      value: (vital['score'] as num) / 10,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(.1),
                      color: theme.colorScheme.primary,
                    ),
                    trailing: Text('${vital['score']} / 10'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.segments, required this.primary});

  final List<Map<String, dynamic>> segments;
  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: 100);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    double start = -math.pi / 2;
    for (final segment in segments) {
      final sweep = ((segment['score'] as num) / 10) * 2 * math.pi / segments.length;
      paint.color = primary.withOpacity(.3 + (segment['score'] as num) / 20);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep + .1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
