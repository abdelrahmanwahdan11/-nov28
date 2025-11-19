import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../core/localization/app_localizations.dart';
import '../../widgets/app_drawer.dart';
import '../catalog/catalog_screen.dart';
import '../checkup/checkup_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final tabs = [
      const HomeScreen(),
      const DashboardScreen(),
      const CheckupScreen(),
      CatalogScreen(standalone: false),
      const ProfileScreen(),
    ];
    final navItems = [
      (IconlyBold.home, loc.translate('nav_home')),
      (IconlyBold.chart, loc.translate('nav_dashboard')),
      (IconlyBold.activity, loc.translate('nav_checkup')),
      (IconlyBold.category, loc.translate('nav_catalog')),
      (IconlyBold.profile, loc.translate('nav_profile')),
    ];
    final isWide = MediaQuery.of(context).size.width >= 900;

    final Widget navWidget = isWide
        ? NavigationRail(
            extended: true,
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: [
              for (final item in navItems)
                NavigationRailDestination(
                  icon: Icon(item.$1),
                  label: Text(item.$2),
                ),
            ],
          )
        : BottomNavigationBar(
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
            items: [
              for (final item in navItems)
                BottomNavigationBarItem(
                  icon: Icon(item.$1),
                  label: item.$2,
                ),
            ],
          );

    final content = AnimatedSwitcher(
      duration: 350.ms,
      transitionBuilder: (child, anim) => SlideTransition(
        position: Tween(begin: const Offset(0.1, 0), end: Offset.zero)
            .animate(anim),
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: IndexedStack(index: index, children: tabs, key: ValueKey(index)),
    );

    return Scaffold(
      drawer: isWide ? null : const AppDrawer(),
      body: Row(
        children: [
          if (isWide)
            SizedBox(width: 280, child: const AppDrawer())
          else
            const SizedBox.shrink(),
          if (isWide) navWidget,
          Expanded(child: content),
        ],
      ),
      bottomNavigationBar: isWide ? null : navWidget,
    );
  }
}
