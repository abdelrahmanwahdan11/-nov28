import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/skeletons.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late final controller = ControllerScope.of(context).analysisController;
  late final tabController = TabController(length: controller.tabs.length, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectTab(controller.tabs.first);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('nav_dashboard'))),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: [for (final tab in controller.tabs) Tab(text: tab.replaceAll('_', ' '))],
            onTap: (index) => controller.selectTab(controller.tabs[index]),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.historyStream.stream,
              builder: (_, snapshot) {
                final data = snapshot.data;
                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Average', style: theme.textTheme.titleMedium),
                          Text('${data.first['value']}',
                              style: theme.textTheme.displaySmall),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(loc.translate('make_measurement')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MinMaxCard(
                            label: 'Min',
                            value: data.map((e) => e['value'] as num).reduce((a, b) => a < b ? a : b).toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MinMaxCard(
                            label: 'Max',
                            value: data.map((e) => e['value'] as num).reduce((a, b) => a > b ? a : b).toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length.clamp(0, 6).toInt(),
                        itemBuilder: (_, index) {
                          final date = data[index]['date'] as DateTime;
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Text('${date.month}/${date.day}'),
                                Text('${data[index]['value']}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: _TrendPainter(values: data.map((e) => e['value'] as num).toList()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...data.map((entry) => ListTile(
                          title: Text(entry['date'].toString()),
                          trailing: Text('${entry['value']}'),
                        )),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: controller.isLoading,
                      builder: (_, loading, __) => loading
                          ? const SkeletonCard.list()
                          : OutlinedButton(
                              onPressed: controller.loadMore,
                              child: Text(loc.translate('load_more')),
                            ),
                    ),
                  ],
                ).animate().fadeIn();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.values});

  final List<num> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final norm = (values[i] - minVal) / ((maxVal - minVal) == 0 ? 1 : (maxVal - minVal));
      final y = size.height - (norm * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.values != values;
}

class _MinMaxCard extends StatelessWidget {
  const _MinMaxCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
