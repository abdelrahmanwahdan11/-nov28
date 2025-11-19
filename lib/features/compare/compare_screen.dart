import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).compareController;
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('compare'))),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: controller.selectedItems,
        builder: (_, items, __) {
          if (items.length < 2) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.compare_arrows, size: 72),
                  const SizedBox(height: 16),
                  Text(loc.translate('empty_compare')),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed('/catalog'),
                    child: Text(loc.translate('go_to_catalog')),
                  ),
                ],
              ),
            );
          }
          final attrs = ['score', 'category', 'shortInfo'];
          final bestScore = items
              .map((e) => (e['score'] as num?) ?? 0)
              .fold<num>(0, (prev, element) => element > prev ? element : prev);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    for (final attr in attrs)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(attr.toUpperCase()),
                      ),
                  ],
                ),
                for (int i = 0; i < items.length; i++)
                  _ComparisonColumn(
                    item: items[i],
                    highlightColor: Theme.of(context).colorScheme.primary,
                    onRemove: () => controller.removeAt(i),
                    isBest: (items[i]['score'] as num?) == bestScore,
                  ),
              ],
            ).animate().slideX(begin: .1).fadeIn(),
          );
        },
      ),
    );
  }
}

class _ComparisonColumn extends StatelessWidget {
  const _ComparisonColumn({
    required this.item,
    required this.highlightColor,
    required this.onRemove,
    required this.isBest,
  });

  final Map<String, dynamic> item;
  final Color highlightColor;
  final VoidCallback onRemove;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(item['title']),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
          ),
          _RowValue(
            label: 'Score',
            value: '${item['score']}',
            color: isBest ? highlightColor : null,
          ),
          _RowValue(label: 'Category', value: item['category']),
          _RowValue(label: 'Info', value: item['shortInfo']),
        ],
      ),
    );
  }
}

class _RowValue extends StatelessWidget {
  const _RowValue({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color ?? Theme.of(context).textTheme.titleMedium?.color,
                ),
          ),
        ],
      ),
    );
  }
}
