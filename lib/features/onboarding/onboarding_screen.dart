import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final controller = ControllerScope.of(context).onboardingController;

  final pages = const [
    (
      title: 'Pastel peace',
      body: 'Visualize your vitals in a calming gradient space.',
      image:
          'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?auto=format&fit=crop&w=900&q=80',
    ),
    (
      title: 'AI assist',
      body: 'Plan preventive actions with our friendly AI bot.',
      image:
          'https://images.unsplash.com/photo-1581091012184-7c54c7d3cc3a?auto=format&fit=crop&w=900&q=80',
    ),
    (
      title: 'Connected care',
      body: 'Stay in sync with reminders, vitals and telehealth.',
      image:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startAutoPlay();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (_, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.network(
                              page.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ).animate().fadeIn(duration: 400.ms).scale(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(page.title,
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(page.body,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: controller.pageIndex,
              builder: (_, value, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.all(6),
                      width: value == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: value == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      await controller.completeOnboarding();
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushReplacementNamed('/auth');
                    },
                    child: Text(loc.translate('skip')),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.pageIndex.value == pages.length - 1) {
                        await controller.completeOnboarding();
                        if (!mounted) return;
                        Navigator.of(context)
                            .pushReplacementNamed('/auth');
                      } else {
                        controller.pageController.nextPage(
                          duration: 350.ms,
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(controller.pageIndex.value == pages.length - 1
                        ? loc.translate('done')
                        : loc.translate('next')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
