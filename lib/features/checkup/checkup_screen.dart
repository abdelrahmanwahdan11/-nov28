import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';

class CheckupScreen extends StatefulWidget {
  const CheckupScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<CheckupScreen> createState() => _CheckupScreenState();
}

class _CheckupScreenState extends State<CheckupScreen>
    with SingleTickerProviderStateMixin {
  late final controller = ControllerScope.of(context).checkupController;
  late final soundService = ControllerScope.of(context).soundService;
  late final tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    tabController.index = widget.initialTabIndex;
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
    final symptoms = ['Cough', 'Fever', 'Fatigue', 'Nausea', 'Headache'];

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: [
            Tab(text: loc.translate('device_checkup')),
            Tab(text: loc.translate('ai_checkup')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _DeviceCheckup(
                controller: controller,
                loc: loc,
                onComplete: () {
                  soundService.playSuccess();
                  Navigator.of(context).pushNamed('/report_detail');
                },
              ),
              _AiCheckup(
                controller: controller,
                symptoms: symptoms,
                loc: loc,
                theme: theme,
                onWarn: () => soundService.playWarning(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceCheckup extends StatefulWidget {
  const _DeviceCheckup({
    required this.controller,
    required this.loc,
    required this.onComplete,
  });

  final dynamic controller;
  final AppLocalizations loc;
  final VoidCallback onComplete;

  @override
  State<_DeviceCheckup> createState() => _DeviceCheckupState();
}

class _DeviceCheckupState extends State<_DeviceCheckup> {
  double rotation = .2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const AiInfoButton(),
          Wrap(
            spacing: 8,
            children: const [
              Chip(label: Text('Respiratory')),
              Chip(label: Text('Telehealth')),
              Chip(label: Text('Temperature')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Connected'),
              Text('Battery 82%'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  rotation += details.delta.dx * 0.005;
                });
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotation),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=900&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: widget.controller.deviceScanning,
            builder: (_, scanning, __) {
              return Column(
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: widget.controller.progress,
                    builder: (_, progress, __) => LinearProgressIndicator(
                      value: scanning ? progress : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: scanning
                        ? null
                        : () => widget.controller.runDeviceScan(widget.onComplete),
                    child: Text(widget.loc.translate('run_full_scan')),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AiCheckup extends StatelessWidget {
  const _AiCheckup({
    required this.controller,
    required this.symptoms,
    required this.loc,
    required this.theme,
    required this.onWarn,
  });

  final dynamic controller;
  final List<String> symptoms;
  final AppLocalizations loc;
  final ThemeData theme;
  final VoidCallback onWarn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const AiInfoButton(),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?auto=format&fit=crop&w=900&q=80',
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              for (final symptom in symptoms)
                ValueListenableBuilder<List<String>>(
                  valueListenable: controller.selectedSymptoms,
                  builder: (_, list, __) {
                    final selected = list.contains(symptom);
                    return FilterChip(
                      label: Text(symptom),
                      selected: selected,
                      onSelected: (_) => controller.toggleSymptom(symptom),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(loc.translate('selected_symptoms'),
                style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<List<String>>(
            valueListenable: controller.selectedSymptoms,
            builder: (_, selected, __) => Wrap(
              spacing: 8,
              children: selected
                  .map((e) => Chip(label: Text(e)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onWarn();
              controller.runAiSummary();
            },
            child: Text(loc.translate('continue')),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String?>(
            valueListenable: controller.aiSummary,
            builder: (_, summary, __) {
              if (summary == null) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(summary),
              ).animate().fadeIn();
            },
          ),
        ],
      ),
    );
  }
}
