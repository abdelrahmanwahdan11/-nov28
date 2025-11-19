import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class CatalogScreen extends StatefulWidget {
  CatalogScreen({super.key, required this.standalone});

  final bool standalone;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final controller = ControllerScope.of(context).catalogController;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: controller.items,
        builder: (_, items, __) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              if (widget.standalone)
                Text(loc.translate('nav_catalog'),
                    style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(IconlyLight.search),
                  hintText: loc.translate('catalog_search_hint'),
                ),
                onChanged: controller.onSearchChanged,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text(loc.translate('filters')),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: controller.grid,
                    builder: (_, grid, __) => IconButton(
                      icon: Icon(grid ? Icons.grid_view : Icons.view_agenda),
                      onPressed: controller.toggleLayout,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: controller.loading,
                builder: (_, loading, __) {
                  if (items.isEmpty && loading) {
                    return Column(
                      children: const [
                        SkeletonCard.list(),
                        SkeletonCard.list(),
                      ],
                    );
                  }
                  final grid = controller.grid.value;
                  return AnimatedSwitcher(
                    duration: 300.ms,
                    child: grid
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: .75,
                            ),
                            itemCount: items.length,
                            itemBuilder: (_, index) => _CatalogCard(
                              item: items[index],
                              onCompare: controller.toggleCompare,
                              compareSelection: controller.compareSelection,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (_, index) => _CatalogCard(
                              item: items[index],
                              onCompare: controller.toggleCompare,
                              compareSelection: controller.compareSelection,
                            ),
                          ),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: controller.loading,
                builder: (_, loading, __) => loading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<Set<String>>(
                valueListenable: controller.compareSelection,
                builder: (_, selection, __) {
                  if (selection.isEmpty) return const SizedBox.shrink();
                  return ElevatedButton(
                    onPressed: () {
                      final selectedItems = controller.items.value
                          .where((item) => selection.contains(item['id']))
                          .toList();
                      ControllerScope.of(context)
                          .compareController
                          .setItems(selectedItems);
                      Navigator.of(context).pushNamed('/compare');
                    },
                    child: Text('${selection.length} ${loc.translate('compare')}'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.item,
    required this.onCompare,
    required this.compareSelection,
  });

  final Map<String, dynamic> item;
  final void Function(String) onCompare;
  final ValueNotifier<Set<String>> compareSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _openOverlay(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: item['id'],
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  item['mainImageUrl'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(item['category'])),
                      const Spacer(),
                      IconButton(
                        icon: Icon(item['isFavorite']
                            ? IconlyBold.heart
                            : IconlyLight.heart),
                        onPressed: () => ControllerScope.of(context)
                            .catalogController
                            .toggleFavorite(item['id']),
                      ),
                    ],
                  ),
                  Text(item['title'], style: theme.textTheme.titleMedium),
                  Text(item['shortInfo']),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (item['score'] as num) / 10,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${item['score'].toStringAsFixed(1)} / 10'),
                    ],
                  ),
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: compareSelection,
                    builder: (_, selection, __) {
                      final selected = selection.contains(item['id']);
                      return CheckboxListTile(
                        value: selected,
                        onChanged: (_) => onCompare(item['id']),
                        title: Text(selected ? 'Selected' : 'Add to compare'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Future<void> _openOverlay(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        bool flipped = false;
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: AnimatedSwitcher(
              duration: 300.ms,
              transitionBuilder: (child, anim) => AnimatedBuilder(
                animation: anim,
                builder: (_, childWidget) {
                  final angle = (1 - anim.value) * 3.14;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: childWidget,
                  );
                },
                child: child,
              ),
              child: flipped
                  ? _OverlayBack(
                      item: item,
                      onFlip: () => setState(() => flipped = false),
                    )
                  : _OverlayFront(
                      item: item,
                      onFlip: () => setState(() => flipped = true),
                    ),
            ),
          ).animate().scale(),
        );
      },
    );
  }
}

class _OverlayFront extends StatelessWidget {
  const _OverlayFront({required this.item, required this.onFlip});

  final Map<String, dynamic> item;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: item['id'],
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: Image.network(item['mainImageUrl'], fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(item['title'], style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(item['longInfo']),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AiInfoButton(),
                  IconButton(
                    onPressed: onFlip,
                    icon: const Icon(Icons.flip_camera_android),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverlayBack extends StatelessWidget {
  const _OverlayBack({required this.item, required this.onFlip});

  final Map<String, dynamic> item;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Comparison insights',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('Best for cardio focus with score ${item['score'].toStringAsFixed(1)}.'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onFlip, child: const Text('Back')),
        ],
      ),
    );
  }
}
