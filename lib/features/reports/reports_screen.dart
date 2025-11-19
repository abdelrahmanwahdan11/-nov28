import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/skeletons.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).reportsController;
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('reports'))),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.reports,
          builder: (_, reports, __) {
            return ListView.builder(
              itemCount: reports.length + 1,
              itemBuilder: (_, index) {
                if (index == reports.length) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: controller.loading,
                    builder: (_, loading, __) => loading
                        ? const SkeletonCard.list()
                        : TextButton(
                            onPressed: controller.loadMore,
                            child: Text(loc.translate('load_more')),
                          ),
                  );
                }
                final report = reports[index];
                final score = (report['score'] as num?) ?? 0;
                return ListTile(
                  title: Text(report['summary']),
                  subtitle: Text(report['status']),
                  trailing: Text(score.toStringAsFixed(1)),
                  onTap: () => Navigator.of(context).pushNamed('/report_detail',
                      arguments: report),
                ).animate().fadeIn();
              },
            );
          },
        ),
      ),
    );
  }
}
